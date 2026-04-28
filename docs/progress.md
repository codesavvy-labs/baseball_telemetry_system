# Progress

## 2026-04-28
Implemented local telemetry pipeline:

- Rust TCP collector
- JSON validation
- normalization + host timestamp
- JSONL persistence
- Python tail consumer
- PowerShell telemetry sender

Next:
- TelemetryStats in Python
- repeated sender
- Linux VM validation
- QEMU guest simulator