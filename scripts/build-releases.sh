#!/usr/bin/env bash
set -euo pipefail

if [[ "${SAFARI_RELEASES_INTERNAL:-}" != 1 ]]; then
  repo_root=$(git rev-parse --show-toplevel)
  webkit_repo=${WEBKIT_REPO:-"$repo_root/../webkit"}
  webkit_repo=$(cd "$webkit_repo" && pwd)
  temp_dir=$(mktemp -d)
  cp "${BASH_SOURCE[0]}" "$temp_dir/build-releases.sh"
  cp "$repo_root/data/releases.tsv" "$temp_dir/releases.tsv"
  SAFARI_RELEASES_INTERNAL=1 \
    SAFARI_REPO_ROOT="$repo_root" \
    SAFARI_WEBKIT_REPO="$webkit_repo" \
    SAFARI_MAP_PATH="$temp_dir/releases.tsv" \
    SAFARI_TEMP_DIR="$temp_dir" \
    exec bash "$temp_dir/build-releases.sh"
fi

repo_root=$SAFARI_REPO_ROOT
webkit_repo=$SAFARI_WEBKIT_REPO
map_path=$SAFARI_MAP_PATH
temp_dir=$SAFARI_TEMP_DIR
trap 'rm -rf "$temp_dir"' EXIT

cd "$repo_root"
source_branch=$(git branch --show-current)
if [[ -z "$source_branch" ]]; then
  printf 'Run this script from a named branch, not a detached HEAD.\n' >&2
  exit 1
fi
if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
  printf 'The source worktree must be clean. Commit the README, mapping, and script first.\n' >&2
  exit 1
fi
has_releases_branch=0
if git show-ref --verify --quiet refs/heads/releases; then
  has_releases_branch=1
fi

seen_new_release=0
existing_release_count=0
release_count=0
while IFS=$'\t' read -r version release_date engine_version tag commit match_status; do
  [[ "$version" == safari_version ]] && continue
  release_count=$((release_count + 1))
  actual_commit=$(git -C "$webkit_repo" rev-parse --verify "$tag^{commit}")
  if [[ "$actual_commit" != "$commit" ]]; then
    printf 'Tag %s resolves to %s, expected %s.\n' "$tag" "$actual_commit" "$commit" >&2
    exit 1
  fi

  if [[ "$has_releases_branch" == 1 ]] && git show-ref --verify --quiet "refs/tags/v${version}"; then
    if [[ "$seen_new_release" == 1 ]]; then
      printf 'Existing Safari tags are not a prefix of the mapping; refusing to append out of order.\n' >&2
      exit 1
    fi
    if ! git merge-base --is-ancestor "refs/tags/v${version}" refs/heads/releases; then
      printf 'Tag v%s does not point into the releases branch.\n' "$version" >&2
      exit 1
    fi
    existing_release_count=$((existing_release_count + 1))
  else
    seen_new_release=1
  fi
done < "$map_path"

if [[ "$release_count" -eq 0 ]]; then
  printf 'The release mapping is empty.\n' >&2
  exit 1
fi
if [[ "$has_releases_branch" == 1 && "$existing_release_count" -eq 0 ]]; then
  printf 'The releases branch has no matching Safari release tags; refusing to append to unknown history.\n' >&2
  exit 1
fi

if [[ "$has_releases_branch" == 1 ]]; then
  git switch releases
else
  git switch --orphan releases
  rm -rf -- README.md data scripts
fi

previous_tag=Safari-533.15
snapshot_dir="$temp_dir/snapshot"
message_file="$temp_dir/commit-message"

while IFS=$'\t' read -r version release_date engine_version tag commit match_status; do
  [[ "$version" == safari_version ]] && continue
  if [[ "$has_releases_branch" == 1 ]] && git show-ref --verify --quiet "refs/tags/v${version}"; then
    previous_tag=$tag
    continue
  fi
  rm -rf -- "$snapshot_dir"
  mkdir -p "$snapshot_dir"
  git -C "$webkit_repo" archive --format=tar "$tag" | tar -xf - -C "$snapshot_dir"

  rsync -a --delete --delete-excluded \
    --filter='P /.git' \
    --exclude='/.git' \
    --exclude='/15.6/' --exclude='/16.5/' \
    --exclude='/.codex/config.toml' \
    --exclude='huge_trace.json' \
    --exclude='WPT_BASE_MANIFEST*.json' \
    --exclude='**/testdata/**' \
    --exclude='**/test/data/**' \
    --exclude='*.a' --exclude='*.apk' --exclude='*.bc' --exclude='*.bin' \
    --exclude='*.bz2' --exclude='*.dat' --exclude='*.data' \
    --exclude='*.db' --exclude='*.bdic' --exclude='*.crx' --exclude='*.def' \
    --exclude='*.exr' \
    --exclude='*.dic' --exclude='*.dll' --exclude='*.dmg' --exclude='*.exe' \
    --exclude='*.gpg' --exclude='*.icc' --exclude='*.ivf' --exclude='*.jar' \
    --exclude='*.jpeg' --exclude='*.jpg' --exclude='*.keystore' --exclude='*.lib' \
    --exclude='*.m4v' --exclude='*.map' --exclude='*.mskp' \
    --exclude='*.mp3' --exclude='*.mp4' --exclude='*.mov' --exclude='*.ogg' --exclude='*.ogv' \
    --exclude='*.onnx' --exclude='*.otf' --exclude='*.ops' --exclude='*.pdb' --exclude='*.pcm' --exclude='*.png' \
    --exclude='*.psd' --exclude='*.raw' --exclude='*.res' --exclude='*.sqlite' \
    --exclude='*.so' --exclude='*.svg' --exclude='*.svgz' --exclude='*.tar.xz' \
    --exclude='*.reality' --exclude='*.sdkdb' --exclude='*.tflite' --exclude='*.ttf' \
    --exclude='*.wav' --exclude='*.webm' --exclude='*.webp' --exclude='*.woff' --exclude='*.woff2' \
    --exclude='*.usdz' --exclude='*.y4m' --exclude='*.yuv' --exclude='*.wasm' --exclude='*.wast' --exclude='*.glb' --exclude='*.zip' \
    "$snapshot_dir/" "$repo_root/"

  git add -A
  {
    printf 'release: Safari %s (%s)\n\n' "$version" "$tag"
    if [[ "$match_status" == nearest* ]]; then
      printf 'Tag match: nearest, no exact WebKit tag found for Safari %s (BCD engine %s).\n' "$version" "$engine_version"
    else
      printf 'Tag match: exact.\n'
    fi
    printf 'Safari release date: %s\n' "$release_date"
    printf 'Tag: https://github.com/WebKit/WebKit/tree/%s\n' "$tag"
    if [[ "$version" != 5 && "$tag" != "$previous_tag" ]]; then
      printf 'Compare: https://github.com/WebKit/WebKit/compare/%s...%s\n' "$previous_tag" "$tag"
    fi
  } > "$message_file"
  GIT_AUTHOR_DATE="${release_date}T12:00:00Z" \
    GIT_COMMITTER_DATE="${release_date}T12:00:00Z" \
    git commit -S --allow-empty -F "$message_file"
  GIT_COMMITTER_DATE="${release_date}T12:00:00Z" \
    git tag -a "v${version}" -m "Safari ${version}"
  previous_tag=$tag
done < "$map_path"

git switch "$source_branch"
