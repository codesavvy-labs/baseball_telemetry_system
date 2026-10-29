"""Send a small deterministic telemetry batch to the Rust collector."""

import argparse
import json
import socket
from datetime import datetime, timezone


def make_samples(count: int, source_id: str) -> list[dict[str, object]]:
    statuses = ["ok", "ok", "warning", "ok", "error"]
    samples = []
    for sequence in range(count):
        timestamp = datetime.now(timezone.utc).isoformat(timespec="milliseconds")
        samples.append(
            {
                "source_id": source_id,
                "guest_timestamp": timestamp.replace("+00:00", "Z"),
                "pitch_velocity_mph": 90.0 + sequence,
                "spin_rate_rpm": 2200 + 100 * sequence,
                "wind_speed_mph": 4.5,
                "wind_direction_deg": 135,
                "temperature_f": 68.0,
                "device_status": statuses[sequence % len(statuses)],
            }
        )
    return samples


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=9000)
    parser.add_argument("--count", type=int, default=5)
    parser.add_argument("--source-id", default="linux-demo-sensor")
    args = parser.parse_args()

    if args.count < 1:
        parser.error("--count must be at least 1")

    samples = make_samples(args.count, args.source_id)
    with socket.create_connection((args.host, args.port), timeout=5) as connection:
        for sample in samples:
            connection.sendall((json.dumps(sample, separators=(",", ":")) + "\n").encode())

    print(f"Sent {len(samples)} telemetry samples to {args.host}:{args.port}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
