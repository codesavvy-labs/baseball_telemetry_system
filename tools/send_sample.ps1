$client = New-Object System.Net.Sockets.TcpClient("127.0.0.1", 9000)

$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)

$writer.AutoFlush = $true

$json = '{"source_id":"qemu-guest-1","guest_timestamp":"2026-04-27T18:00:00Z","pitch_velocity_mph":94.7,"spin_rate_rpm":2410,"wind_speed_mph":8.2,"wind_direction_deg":135,"temperature_f":67.5,"device_status":"ok"}'

$writer.WriteLine($json)

$writer.Close()
$stream.Close()
$client.Close()
