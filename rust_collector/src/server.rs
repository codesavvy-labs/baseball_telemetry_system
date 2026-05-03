use std::net::SocketAddr;

use anyhow::Result;
use futures_util::StreamExt;
use tokio::net::{TcpListener, TcpStream};
use tokio_util::codec::{FramedRead, LinesCodec};
use tracing::{error, info, warn};

use crate::forward::forward_to_python;
use crate::processing::process_line;

pub async fn run(bind_addr: &str) -> Result<()> {
    let listener = TcpListener::bind(bind_addr).await?;
    info!(%bind_addr, "collector listening");

    loop {
        let (socket, peer_addr) = listener.accept().await?;
        info!(%peer_addr, "accepted connection");

        tokio::spawn(async move {
            if let Err(err) = handle_connection(socket, peer_addr).await {
                error!(%peer_addr, error = %err, "connection handler failed");
            }
        });
    }
}

async fn handle_connection(socket: TcpStream, peer_addr: SocketAddr) -> Result<()> {
    let mut lines = FramedRead::new(socket, LinesCodec::new());

    while let Some(result) = lines.next().await {
        match result {
            Ok(line) => {
                if line.trim().is_empty() {
                    continue;
                }

                match process_line(&line) {
                    Ok(normalized) => {
                        info!(
                            %peer_addr,
                            source_id = %normalized.source_id,
                            pitch_velocity_mph = normalized.pitch_velocity_mph,
                            spin_rate_rpm = normalized.spin_rate_rpm,
                            "telemetry accepted"
                        );

                        forward_to_python(&normalized).await?;
                    }
                    Err(err) => {
                        warn!(
                            %peer_addr,
                            error = %err,
                            raw_line = %line,
                            "telemetry rejected"
                        );
                    }
                }
            }
            Err(err) => {
                warn!(%peer_addr, error = %err, "line decode error");
                break;
            }
        }
    }

    info!(%peer_addr, "connection closed");
}
