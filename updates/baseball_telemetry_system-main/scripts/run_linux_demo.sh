#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bind_addr="${TELEMETRY_BIND_ADDR:-127.0.0.1:9000}"
host="${bind_addr%:*}"
port="${bind_addr##*:}"
output_dir="${TELEMETRY_DEMO_OUTPUT_DIR:-}"
if [[ -z "$output_dir" ]]; then
    output_dir="$(mktemp -d "${TMPDIR:-/tmp}/baseball-telemetry.XXXXXX")"
fi
output_file="$output_dir/normalized_telemetry.jsonl"
collector_log="$output_dir/rust-collector.log"

mkdir -p "$output_dir"
export TELEMETRY_BIND_ADDR="$bind_addr"
export TELEMETRY_OUTPUT_FILE="$output_file"

collector_pid=""
cleanup() {
    if [[ -n "$collector_pid" ]] && kill -0 "$collector_pid" 2>/dev/null; then
        kill "$collector_pid" 2>/dev/null || true
        wait "$collector_pid" 2>/dev/null || true
    fi
}
trap cleanup EXIT INT TERM

cd "$repo_root"
if ! cargo build --quiet --manifest-path rust_collector/Cargo.toml >"$collector_log" 2>&1; then
    cat "$collector_log" >&2
    exit 1
fi
./rust_collector/target/debug/rust_collector >>"$collector_log" 2>&1 &
collector_pid=$!

if ! python3 - "$host" "$port" <<'PY'
import socket
import sys
import time

host, port = sys.argv[1], int(sys.argv[2])
for _ in range(50):
    try:
        with socket.create_connection((host, port), timeout=0.2):
            raise SystemExit(0)
    except OSError:
        time.sleep(0.1)
raise SystemExit("Rust collector did not start; see its log for details")
PY
then
    cat "$collector_log" >&2
    exit 1
fi

python3 python_app/src/send_samples.py --host "$host" --port "$port"
cleanup
collector_pid=""
python3 python_app/src/main.py --input "$output_file"
printf '\nRun artifacts: %s\n' "$output_dir"
