import json
import socket
from datetime import datetime, timezone


def build_sample():
    return {
        "source_id": "qemu-guest-1",
        "guest_timestamp": datetime.now(timezone.utc).isoformat(),
        "pitch_velocity_mph": 94.7,
        "spin_rate_rpm": 2410,
        "wind_speed_mph": 8.2,
        "wind_direction_deg": 135,
        "temperature_f": 67.5,
        "device_status": "ok",
    }


def main():
    payload = build_sample()
    line = json.dumps(payload) + "\n"

    with socket.create_connection(("127.0.0.1", 9000)) as sock:
        sock.sendall(line.encode("utf-8"))

    print("Telemetry sent")


if __name__ == "__main__":
    main()