mod forward;
mod model;
mod processing;
mod server;

use anyhow::Result;
use tracing::info;

#[tokio::main]
async fn main() -> Result<()> {
    init_tracing();

    let bind_addr = "127.0.0.1:9000";
    info!(%bind_addr, "starting rust collector");

    server::run(bind_addr).await
}

fn init_tracing() {
    tracing_subscriber::fmt()
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| "info".into()),
        )
        .with_target(false)
        .compact()
        .init();
}

