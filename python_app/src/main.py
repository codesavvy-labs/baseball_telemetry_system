import json
import time
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
DATA_FILE = BASE_DIR.parent.parent / "sample_data" / "normalized_telemetry.jsonl"

class TelemetryStats:
    def __init__(self) :
        self.count = 0
        self.velocity_sum = 0.0
        self.spin_sum = 0.0
        self.warnings = 0
        self.errors = 0
        self.min_velocity = 0.0
        self.max_velocity = 0.0

    def update(self, sample):
        self.count += 1
        self.velocity_sum += sample['pitch_velocity_mph']
        self.spin_sum += sample['spin_rate_rpm']

        status = sample["device_status"]

        self.min_velocity = min(self.min_velocity, sample["pitch_velocity_mph"])
        self.max_velocity = max(self.max_velocity, sample["pitch_velocity_mph"])
        
        if status == "warning":
            self.warnings += 1
        elif status == "error":
            self.errors += 1

    def report(self):
        if self.count == 0:
            return

        avg_velocity = self.velocity_sum / self.count
        avg_spin = self.spin_sum / self.count

        print("\nTelemetry Stats")
        print(f"Samples: {self.count}")
        print(f"Avg Velocity: {avg_velocity:.2f}")
        print(f"Avg Spin: {avg_spin:.2f}")
        print(f"Min Velocity: {self.min_velocity:.2f}")
        print(f"Max Velocity: {self.max_velocity:.2f}")
        print(f"Warnings: {self.warnings}")
        print(f"Errors: {self.errors}")
        self.min_velocity = float("inf")
        self.max_velocity = float("-inf")   

def process_sample(sample, stats):
    stats.update(sample)

    print(
        f"source={sample['source_id']} "
        f"velo={sample['pitch_velocity_mph']} "
        f"spin={sample['spin_rate_rpm']}"
    )

    if stats.count % 5 == 0:
        stats.report()

def tail_file(path: Path, stats):
    while not path.exists():
        print("Waiting for telemetry file...")
        time.sleep(1)

    with open(path, "r", encoding="utf-8") as f:
        f.seek(0, 2)  # jump to end

        while True:
            line = f.readline()

            if not line:
                time.sleep(0.25)
                continue

            line = line.strip()
            if not line:
                continue

            try:
                sample = json.loads(line)

                process_sample(sample, stats)
            except json.JSONDecodeError as e:
                print(f"Bad JSON line: {e}")


def main():
    print("Python telemetry consumer starting...")
    stats = TelemetryStats()    
    tail_file(DATA_FILE,stats)


if __name__ == "__main__":
    main()