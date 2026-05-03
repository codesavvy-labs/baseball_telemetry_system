use anyhow::Result;
use std::fs::{self, OpenOptions};
use std::io::Write;
use tracing::info;

use crate::model::NormalizedTelemetry;

pub async fn forward_to_python(sample: &NormalizedTelemetry) -> Result<()> {
    let json = serde_json::to_string(sample)?;
    info!(payload = %json, "forwarded telemetry");

    fs::create_dir_all("../sample_data")?;

    let mut file = OpenOptions::new()
        .create(true)
        .append(true)
        .open("../sample_data/normalized_telemetry.jsonl")?;

    writeln!(file, "{}", json)?;

    //Ok(())
}