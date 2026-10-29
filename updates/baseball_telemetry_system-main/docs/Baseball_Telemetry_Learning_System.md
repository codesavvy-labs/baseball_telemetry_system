# Baseball Telemetry System: implementation status

## Implemented Linux-host flow

The current end-to-end path uses a Python sender to transmit newline-delimited JSON records to a Rust TCP collector. Rust parses and validates each record, adds a host timestamp, then appends the normalized record to a JSON Lines file. A Python consumer reads that file and summarizes velocity, spin, and device-status counts.

```text
Python sender --TCP/NDJSON--> Rust collector --normalized JSONL--> Python summary
```

The path is orchestrated by `scripts/run_linux_demo.sh`. The sender simulates a device on the host, so the initial demo does not depend on a QEMU image.

## Current component boundaries

### Rust collector

- Accepts TCP clients and reads one JSON record per line.
- Deserializes the incoming telemetry schema.
- Rejects invalid values and unsupported device-status values.
- Adds a host-side UTC timestamp.
- Appends accepted records to a configurable JSONL file.

### Python sender and summary

- `send_samples.py` generates a deterministic batch and sends it over TCP.
- `main.py` reads normalized JSONL records, skips malformed or incomplete lines, and reports aggregate statistics.

### QEMU guest

The current guest init script prints generic sensor records to its serial console and powers off. Those records do not use the baseball telemetry schema and are not transmitted to the Rust collector. Connecting the guest to the collector is a planned follow-up.

### C++ target

The current C++ executable and smoke test are stubs. C++ does not yet participate in the telemetry data path; its responsibility needs to be defined before it is shown as a system component.

## Follow-up work

1. Add meaningful tests around Rust validation, persistence, and Python summary behavior.
2. Make the QEMU guest send schema-compatible records to the host collector.
3. Define a concrete C++ role and implement it, or keep C++ out of the architecture until then.
4. Consolidate phased CI workflows and publish a reproducible Linux run result.
