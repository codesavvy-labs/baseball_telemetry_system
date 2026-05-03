use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize)]
pub struct IncomingTelemetry {
    pub source_id: String,
    pub guest_timestamp: DateTime<Utc>,
    pub pitch_velocity_mph: f64,
    pub spin_rate_rpm: u32,
    pub wind_speed_mph: f64,
    pub wind_direction_deg: u16,
    pub temperature_f: f64,
    pub device_status: String,
}

#[derive(Debug, Serialize)]
pub struct NormalizedTelemetry {
    pub source_id: String,
    pub guest_timestamp: DateTime<Utc>,
    pub host_timestamp: DateTime<Utc>,
    pub pitch_velocity_mph: f64,
    pub spin_rate_rpm: u32,
    pub wind_speed_mph: f64,
    pub wind_direction_deg: u16,
    pub temperature_f: f64,
    pub device_status: String,
}
