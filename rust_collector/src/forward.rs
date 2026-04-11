use anyhow::Result;
use tracing::info;

use crate::model::NormalizedTelemetry;

pub async fn forward_to_python(sample: &NormalizedTelemetry) -> Result<()> {
    // Placeholder implementation.
    // Next step could be:
    // - append JSONL to a file
    // - POST to a Python HTTP endpoint
    // - send via socket
    // - publish to a channel

    let json = serde_json::to_string(sample)?;
    info!(payload = %json, "forwarded telemetry");

    Ok(())
}