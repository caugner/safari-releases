let f = generateHeapSnapshotForGCDebugging;
f();
f();
f();
f();
f();
f();
f();
f().replaceAll(1, f());
