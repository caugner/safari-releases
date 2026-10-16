#!/usr/bin/env python3
"""Print an index of WebKit commits that change version configuration lines."""

import argparse
import csv
import os
import re
import subprocess
import sys


VERSION_PATHS = (
    "Configurations/Version.xcconfig",
    "JavaScriptCore/Configurations/Version.xcconfig",
    "Source/JavaScriptCore/Configurations/Version.xcconfig",
    "WebCore/Configurations/Version.xcconfig",
    "Source/WebCore/Configurations/Version.xcconfig",
)
VERSION_LINE = re.compile(r"^([+-])(MAJOR_VERSION|MINOR_VERSION|TINY_VERSION)\s*=\s*([^;\s]+)")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "webkit_repo",
        nargs="?",
        default=os.environ.get(
            "WEBKIT_REPO",
            os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "../webkit"),
        ),
        help="WebKit checkout to inspect (default: WEBKIT_REPO or ../webkit)",
    )
    args = parser.parse_args()
    repo = os.path.abspath(args.webkit_repo)
    path_args = [f":(literal){path}" for path in VERSION_PATHS]
    output = subprocess.check_output(
        [
            "git",
            "-C",
            repo,
            "log",
            "--all",
            "--date=short",
            "--format=@@@%H%x09%cs%x09%s",
            "--patch",
            "--unified=0",
            "-G",
            r"^[[:space:]]*(MAJOR_VERSION|MINOR_VERSION|TINY_VERSION)[[:space:]]*=",
            "--",
            *path_args,
        ],
        text=True,
    )

    commits = {}
    current = None
    current_path = None
    for line in output.splitlines():
        if line.startswith("@@@"):
            commit, date, subject = line[3:].split("\t", 2)
            current = commits.setdefault(
                commit,
                {"date": date, "subject": subject.replace("\t", " "), "changes": set()},
            )
            current_path = None
        elif line.startswith("diff --git "):
            match = re.match(r"diff --git a/(.+) b/(.+)$", line)
            current_path = match.group(2) if match else None
        elif current is not None and current_path is not None:
            match = VERSION_LINE.match(line)
            if match:
                sign, key, value = match.groups()
                current["changes"].add((current_path, key, sign, value))

    records = []
    for commit, record in commits.items():
        old = {}
        new = {}
        for path, key, sign, value in record["changes"]:
            destination = old if sign == "-" else new
            destination.setdefault((path, key), set()).add(value)
        changes = []
        for path, key in sorted(set(old) | set(new)):
            before = ",".join(sorted(old.get((path, key), {"?"})))
            after = ",".join(sorted(new.get((path, key), {"?"})))
            changes.append(f"{path}:{key} {before} -> {after}")
        records.append((record["date"], commit, "; ".join(changes), record["subject"]))

    writer = csv.writer(sys.stdout, delimiter="\t", lineterminator="\n")
    writer.writerow(("commit_date", "commit", "version_changes", "subject", "commit_url"))
    for date, commit, changes, subject in sorted(records):
        writer.writerow((date, commit, changes, subject, f"https://github.com/WebKit/WebKit/commit/{commit}"))


if __name__ == "__main__":
    main()
