"""Summarize normalized baseball telemetry records stored as JSON Lines."""

import argparse
import json
import math
import os
from pathlib import Path
from typing import Any

REPOSITORY_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_DATA_FILE = REPOSITORY_ROOT / "sample_data" / "normalized_telemetry.jsonl"


class TelemetryStats:
    def __init__(self) -> None:
        self.count = 0
        self.velocity_sum = 0.0
        self.spin_sum = 0
        self.warnings = 0
        self.errors = 0
        self.min_velocity = math.inf
        self.max_velocity = -math.inf

    def update(self, sample: dict[str, Any]) -> None:
        velocity = float(sample["pitch_velocity_mph"])
        spin = int(sample["spin_rate_rpm"])

        self.count += 1
        self.velocity_sum += velocity
        self.spin_sum += spin
        self.min_velocity = min(self.min_velocity, velocity)
        self.max_velocity = max(self.max_velocity, velocity)
        self.warnings += sample["device_status"] == "warning"
        self.errors += sample["device_status"] == "error"

    def report(self) -> None:
        if not self.count:
            print("No valid telemetry samples found.")
            return

        print("\nTelemetry summary")
        print(f"Samples: {self.count}")
        print(f"Average velocity: {self.velocity_sum / self.count:.2f} mph")
        print(f"Average spin: {self.spin_sum / self.count:.0f} rpm")
        print(f"Velocity range: {self.min_velocity:.2f}–{self.max_velocity:.2f} mph")
        print(f"Warnings: {self.warnings}")
        print(f"Errors: {self.errors}")


def validate_sample(sample: Any) -> dict[str, Any]:
    if not isinstance(sample, dict):
        raise ValueError("record must be a JSON object")

    required = {
        "source_id",
        "guest_timestamp",
        "host_timestamp",
        "pitch_velocity_mph",
        "spin_rate_rpm",
        "device_status",
    }
    missing = required.difference(sample)
    if missing:
        raise ValueError(f"missing required fields: {', '.join(sorted(missing))}")

    if not isinstance(sample["source_id"], str) or not sample["source_id"].strip():
        raise ValueError("source_id must be a non-empty string")
    if not isinstance(sample["device_status"], str):
        raise ValueError("device_status must be a string")

    try:
        velocity = float(sample["pitch_velocity_mph"])
        spin = int(sample["spin_rate_rpm"])
    except (TypeError, ValueError) as exc:
        raise ValueError("velocity and spin must be numeric") from exc

    if not math.isfinite(velocity):
        raise ValueError("pitch_velocity_mph must be finite")
    if spin < 0:
        raise ValueError("spin_rate_rpm cannot be negative")
    if sample["device_status"] not in {"ok", "warning", "error"}:
        raise ValueError("device_status must be ok, warning, or error")

    return sample


def summarize_file(path: Path) -> int:
    stats = TelemetryStats()
    invalid_records = 0

    with path.open("r", encoding="utf-8") as telemetry_file:
        for line_number, line in enumerate(telemetry_file, start=1):
            if not line.strip():
                continue
            try:
                sample = validate_sample(json.loads(line))
                stats.update(sample)
            except (json.JSONDecodeError, ValueError) as exc:
                invalid_records += 1
                print(f"Skipping line {line_number}: {exc}")

    print(f"Input: {path}")
    stats.report()
    if invalid_records:
        print(f"Invalid records skipped: {invalid_records}")
    return 0 if stats.count else 1


def main() -> int:
    default_path = Path(os.environ.get("TELEMETRY_OUTPUT_FILE", DEFAULT_DATA_FILE))
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--input",
        type=Path,
        default=default_path,
        help=f"JSON Lines input file (default: {default_path})",
    )
    args = parser.parse_args()

    if not args.input.is_file():
        parser.error(f"input file does not exist: {args.input}")
    return summarize_file(args.input)


if __name__ == "__main__":
    raise SystemExit(main())
