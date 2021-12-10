set ns [new Simulator]

set tracefile [open exemple.tr w]
$ns trace-all $tracefile

set namfile [open exemple.nam w]
$ns namtrace-all $namfile

proc finish {} {
global ns tracefile namfile
$ns flush-trace
close $tracefile
close $namfile
exec nam exemple.nam &
exit 0
}

set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

set null0 [new Agent/Null]
$ns attach-agent $n1 $null0

$ns connect $udp0 $null0

set app0 [new Application/Traffic/CBR]
$app0 attach-agent $udp0

$ns at 0.5 "$app0 start"
$ns at 4.5 "$app0 stop"

$ns at 5.0 "finish"

$ns run
