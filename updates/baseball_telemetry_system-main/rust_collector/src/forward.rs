use anyhow::Result;
use std::fs::{self, OpenOptions};
use std::io::Write;
use std::path::PathBuf;
use tracing::info;

use crate::model::NormalizedTelemetry;

pub async fn forward_to_python(sample: &NormalizedTelemetry) -> Result<()> {
    let json = serde_json::to_string(sample)?;
    let output_path = output_path();
    if let Some(parent) = output_path
        .parent()
        .filter(|parent| !parent.as_os_str().is_empty())
    {
        fs::create_dir_all(parent)?;
    }

    let mut file = OpenOptions::new()
        .create(true)
        .append(true)
        .open(&output_path)?;

    writeln!(file, "{}", json)?;
    info!(path = %output_path.display(), "normalized telemetry persisted");

    Ok(())
}

fn output_path() -> PathBuf {
    if let Some(path) = std::env::var_os("TELEMETRY_OUTPUT_FILE") {
        return PathBuf::from(path);
    }

    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .expect("rust_collector must be inside the repository")
        .join("sample_data/normalized_telemetry.jsonl")
}
