#!/bin/busybox sh

/bin/busybox mount -t proc none /proc
/bin/busybox mount -t sysfs none /sys

echo "=== telemetry guest booted ==="

echo '{"sensor":"temp","value":72.1,"unit":"F","seq":1}'
/bin/busybox sleep 1

echo '{"sensor":"rpm","value":1810,"unit":"rpm","seq":2}'
/bin/busybox sleep 1

echo '{"sensor":"voltage","value":12.1,"unit":"V","seq":3}'
/bin/busybox sleep 1

echo '{"sensor":"pressure","value":31.8,"unit":"psi","seq":4}'
/bin/busybox sleep 1

echo '{"sensor":"fault","value":0,"unit":"code","seq":5}'

echo "=== telemetry complete ==="

/bin/busybox poweroff -f