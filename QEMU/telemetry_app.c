#include <stdio.h>
#include <unistd.h>

// Runs on QEMU installed OS

int main(void)
{
    puts("=== telemetry_app starting ===");

    puts("{\"sensor\":\"temp\",\"value\":72.1,\"unit\":\"F\",\"seq\":1}");
    sleep(1);

    puts("{\"sensor\":\"rpm\",\"value\":1810,\"unit\":\"rpm\",\"seq\":2}");
    sleep(1);

    puts("{\"sensor\":\"voltage\",\"value\":12.1,\"unit\":\"V\",\"seq\":3}");
    sleep(1);

    puts("{\"sensor\":\"pressure\",\"value\":31.8,\"unit\":\"psi\",\"seq\":4}");
    sleep(1);

    puts("{\"sensor\":\"fault\",\"value\":0,\"unit\":\"code\",\"seq\":5}");

    puts("=== telemetry_app complete ===");

    return 0;
}