use anyhow::{bail, Result};
use chrono::Utc;

use crate::model::{IncomingTelemetry, NormalizedTelemetry};

pub fn process_line(line: &str) -> Result<NormalizedTelemetry> {
    let incoming: IncomingTelemetry = serde_json::from_str(line)?;
    validate(&incoming)?;

    Ok(NormalizedTelemetry {
        source_id: incoming.source_id,
        guest_timestamp: incoming.guest_timestamp,
        host_timestamp: Utc::now(),
        pitch_velocity_mph: incoming.pitch_velocity_mph,
        spin_rate_rpm: incoming.spin_rate_rpm,
        wind_speed_mph: incoming.wind_speed_mph,
        wind_direction_deg: incoming.wind_direction_deg,
        temperature_f: incoming.temperature_f,
        device_status: incoming.device_status,
    })
}

pub fn validate(sample: &IncomingTelemetry) -> Result<()> {
    if sample.source_id.trim().is_empty() {
        bail!("source_id cannot be empty");
    }

    if !(40.0..=110.0).contains(&sample.pitch_velocity_mph) {
        bail!(
            "pitch_velocity_mph out of range: {}",
            sample.pitch_velocity_mph
        );
    }

    if !(500..=5000).contains(&sample.spin_rate_rpm) {
        bail!("spin_rate_rpm out of range: {}", sample.spin_rate_rpm);
    }

    if !(0.0..=80.0).contains(&sample.wind_speed_mph) {
        bail!("wind_speed_mph out of range: {}", sample.wind_speed_mph);
    }

    if sample.wind_direction_deg > 360 {
        bail!(
            "wind_direction_deg out of range: {}",
            sample.wind_direction_deg
        );
    }

    if !(-40.0..=140.0).contains(&sample.temperature_f) {
        bail!("temperature_f out of range: {}", sample.temperature_f);
    }

    match sample.device_status.as_str() {
        "ok" | "warning" | "error" => {}
        other => bail!("invalid device_status: {}", other),
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::model::IncomingTelemetry;

    fn valid_sample() -> IncomingTelemetry {
        IncomingTelemetry {
            source_id: "qemu-guest-1".to_string(),
            guest_timestamp: "2026-04-11T14:00:00Z".parse().unwrap(),
            pitch_velocity_mph: 94.7,
            spin_rate_rpm: 2410,
            wind_speed_mph: 8.2,
            wind_direction_deg: 135,
            temperature_f: 67.5,
            device_status: "ok".to_string(),
        }
    }

    fn valid_input_json() -> &'static str {
        r#"{"source_id":"qemu-guest-1","guest_timestamp":"2026-04-11T14:00:00Z","pitch_velocity_mph":94.7,"spin_rate_rpm":2410,"wind_speed_mph":8.2,"wind_direction_deg":135,"temperature_f":67.5,"device_status":"ok"}"#
    }

    #[test]
    fn validate_accepts_valid_sample() {
        let sample = valid_sample();
        let result = validate(&sample);
        assert!(result.is_ok());
    }

    #[test]
    fn validate_rejects_empty_source_id() {
        let mut sample = valid_sample();
        sample.source_id = String::new();

        let result = validate(&sample);

        assert!(result.is_err());
        assert!(result
            .unwrap_err()
            .to_string()
            .contains("source_id cannot be empty"));
    }

    #[test]
    fn validate_rejects_pitch_velocity_out_of_range() {
        let mut sample = valid_sample();
        sample.pitch_velocity_mph = 125.0;

        let result = validate(&sample);

        assert!(result.is_err());
        assert!(result
            .unwrap_err()
            .to_string()
            .contains("pitch_velocity_mph out of range"));
    }

    #[test]
    fn validate_rejects_invalid_device_status() {
        let mut sample = valid_sample();
        sample.device_status = "offline".to_string();

        let result = validate(&sample);

        assert!(result.is_err());
        assert!(result
            .unwrap_err()
            .to_string()
            .contains("invalid device_status"));
    }

    #[test]
    fn process_line_parses_and_normalizes_valid_json() {
        let result = process_line(valid_input_json());

        assert!(result.is_ok());
        let normalized = result.unwrap();

        assert_eq!(normalized.source_id, "qemu-guest-1");
        assert_eq!(normalized.pitch_velocity_mph, 94.7);
        assert_eq!(normalized.spin_rate_rpm, 2410);
        assert_eq!(normalized.wind_speed_mph, 8.2);
        assert_eq!(normalized.wind_direction_deg, 135);
        assert_eq!(normalized.temperature_f, 67.5);
        assert_eq!(normalized.device_status, "ok");
        assert!(normalized.host_timestamp >= normalized.guest_timestamp);
    }

    #[test]
    fn process_line_rejects_invalid_json() {
        let json = r#"{"source_id":"qemu-guest-1","guest_timestamp":"bad-date"}"#;

        let result = process_line(json);

        assert!(result.is_err());
    }

    #[test]
    fn process_line_rejects_semantically_invalid_data() {
        let json = r#"{"source_id":"qemu-guest-1","guest_timestamp":"2026-04-11T14:00:00Z","pitch_velocity_mph":10.0,"spin_rate_rpm":2410,"wind_speed_mph":8.2,"wind_direction_deg":135,"temperature_f":67.5,"device_status":"ok"}"#;

        let result = process_line(json);

        assert!(result.is_err());
        assert!(result
            .unwrap_err()
            .to_string()
            .contains("pitch_velocity_mph out of range"));
    }
}
