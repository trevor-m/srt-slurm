#!/bin/bash
BRANCH="a2afix" #feat/enable-fp4cutedslmoe+a2a

cd /sgl-workspace/sglang
git remote add trevor https://github.com/trevor-m/sglang.git #https://github.com/samuellees/sglang.git
git fetch trevor
git checkout trevor/${BRANCH}

# Debug: surface NIXL failure_record in the raised exception so the real cause
# reaches the "Decode handshake failed ... with exception ..." abort message.
python3 - <<'PY'
import pathlib
p = pathlib.Path("python/sglang/srt/disaggregation/nixl/conn.py")
s = p.read_text()
replacements = [
    ('raise RuntimeError("NIXL KVReceiver Exception")',
     'raise RuntimeError(f"NIXL KVReceiver Exception: {self.kv_mgr.failure_records.get(self.bootstrap_room, \'no record\')}")'),
    ('raise RuntimeError("NIXL KVSender Exception")',
     'raise RuntimeError(f"NIXL KVSender Exception: {self.kv_mgr.failure_records.get(self.bootstrap_room, \'no record\')}")'),
]
for old, new in replacements:
    assert old in s, f"marker not found: {old}"
    s = s.replace(old, new)
p.write_text(s)
print("[patch] NIXL failure_exception now includes failure_record")
PY
