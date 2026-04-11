Baseball Telemetry Learning System – Architecture
Overview

This project is a cross-platform, multi-language system designed to simulate and analyze baseball-related telemetry data.

It combines:

Embedded Linux (QEMU) for simulated sensor data
Rust for telemetry collection, validation, and logging
Python for analytics, visualization, and experimentation
C++ (Windows only) for ETW-based observability

The system is intentionally layered to reflect real-world software architecture used in telemetry pipelines, embedded systems, and analytics platforms.

High-Level Architecture
+--------------------------------------------------------------+
|                    Baseball Learning System                  |
+--------------------------------------------------------------+

   [QEMU Embedded Linux Guest]
              |
              |  telemetry messages
              v
   +--------------------------+
   | Rust Collector / Logger  |
   | - receive data           |
   | - validate               |
   | - timestamp              |
   | - log/trace              |
   | - forward normalized     |
   +--------------------------+
            |           |
            |           +------------------------------+
            |                                          |
            v                                          v
+--------------------------+              +--------------------------+
| Python Baseball App      |              | Observability Layer      |
| - analytics              |              | - Rust structured logs   |
| - metrics                |              | - C++ ETW (Windows)      |
| - CSV / storage          |              | - Linux logging          |
| - charts / UI            |              +--------------------------+
+--------------------------+
Component Breakdown
1. QEMU Embedded Linux Guest

Purpose: Simulate a device producing telemetry data.

Responsibilities:

Generate periodic telemetry samples
Simulate sensor readings such as:
pitch velocity
spin rate
wind speed/direction
temperature
device health
Send data to host system via:
TCP socket (preferred initial approach)
or file/pipe (simpler fallback)
2. Rust Telemetry Collector

Purpose: Act as the central ingestion and processing layer.

Responsibilities:

Ingress
Listen for incoming connections (TCP/UDP/socket)
Handle multiple clients (future)
Parsing & Validation
Deserialize incoming messages (JSON initially)
Validate schema and field ranges
Reject malformed data
Normalization
Add host-side timestamp
Standardize units if necessary
Attach metadata (source ID, etc.)
Logging / Tracing
Emit structured logs
Record:
errors
warnings
lifecycle events
performance metrics
Forwarding
Send normalized data to Python app
Optionally persist to JSONL/CSV
3. Python Baseball Analytics App

Purpose: Perform analysis and visualization.

Responsibilities:

Ingest normalized telemetry data
Maintain in-memory dataset
Compute:
rolling averages
variance
anomaly detection
Store data:
CSV files
optional database (future)
Visualize:
charts (matplotlib, etc.)
possible web UI (future)
4. Observability Layer
Rust Logging (Cross-Platform)
Structured logs (JSON or text)
Covers:
ingestion events
validation failures
pipeline state
C++ ETW Provider (Windows Only)
Native Windows Event Tracing
Used for:
performance analysis
debugging pipeline behavior
system-level visibility
Linux Logging
stdout / file logs
potential future:
journald
tracing frameworks
Message Flow
(1) QEMU guest starts
      |
      v
(2) Sensor simulator generates telemetry
      |
      v
(3) Message sent to Rust collector
      |
      v
(4) Rust collector:
    - receive
    - validate
    - timestamp
    - log/trace
      |
      +----> observability (logs / ETW)
      |
      v
(5) Forward normalized message
      |
      v
(6) Python app:
    - ingest
    - compute metrics
    - update charts / storage
Data Model
TelemetrySample (Initial Schema)
{
  "source_id": "qemu-guest-1",
  "guest_timestamp": "2026-04-11T14:00:00Z",
  "pitch_velocity_mph": 94.7,
  "spin_rate_rpm": 2410,
  "wind_speed_mph": 8.2,
  "wind_direction_deg": 135,
  "temperature_f": 67.5,
  "device_status": "ok"
}
Normalized (After Rust Processing)
{
  "source_id": "qemu-guest-1",
  "guest_timestamp": "2026-04-11T14:00:00Z",
  "host_timestamp": "2026-04-11T14:00:00.124Z",
  "pitch_velocity_mph": 94.7,
  "spin_rate_rpm": 2410,
  "wind_speed_mph": 8.2,
  "wind_direction_deg": 135,
  "temperature_f": 67.5,
  "device_status": "ok"
}
Language Responsibilities
Python
Analytics
Visualization
Experimentation
Data storage
Rust
Data ingestion
Validation
Normalization
Logging
Message forwarding
C++
Windows-specific functionality
ETW tracing
Low-level system integration
Observability Design
Event Categories
Lifecycle
service start/stop
connection open/close
Transport
packet received
packet dropped
invalid payload
Performance
parse duration
forward latency
queue depth
Application
sample accepted
anomaly detected
Tracing Abstraction

To support cross-platform observability:

TraceEvent
- name
- level
- timestamp
- fields
TraceSink (interface)
- emit_event(event)
Implementations
Rust structured logging
Windows ETW (C++)
No-op / test sink
Repository Structure
baseball-system/
|
+-- python_app/
|   +-- src/
|   +-- data/
|   +-- charts/
|
+-- rust_collector/
|   +-- src/
|   +-- Cargo.toml
|
+-- cpp_etw/
|   +-- src/
|   +-- include/
|   +-- CMakeLists.txt
|
+-- qemu_guest/
|   +-- sensor_sim/
|   +-- scripts/
|
+-- docs/
|   +-- architecture.md
|
+-- sample_data/
|   +-- telemetry_samples.jsonl
Implementation Phases
Phase 1 – Local Pipeline
Simulated data (no QEMU yet)
Rust collector writes JSONL
Python reads and plots
Phase 2 – QEMU Integration
Embedded Linux simulator sends data
Rust receives over socket
Phase 3 – Observability
Add structured logging
Introduce ETW on Windows
Phase 4 – Enhancements
Async Rust (Tokio)
Multiple data sources
Replay mode
Web-based UI
Design Principles
Separation of concerns
Process boundaries over tight coupling
Cross-platform compatibility
Incremental complexity
Observability-first mindset
Summary

This system demonstrates:

Embedded systems simulation (QEMU)
Systems programming (Rust, C++)
Cross-platform design (Windows + Linux)
Observability (logging + ETW)
Data analytics (Python)

It is intentionally designed to evolve from a simple learning tool into a realistic telemetry pipeline.