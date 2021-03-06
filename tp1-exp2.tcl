set ns [new Simulator]

set tracefile [open exemple2.tr w]
$ns trace-all $tracefile
set namfile [open exemple2.nam w]
$ns namtrace-all $namfile



proc finish {} {
global ns namfile tracefile
$ns flush-trace
close $tracefile
close $namfile

exec nam exemple2.nam &
exit 0
}


set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n3 1Mb 10ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n2 $null0
$ns connect $udp0 $null0


set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
set tcpsink [new Agent/TCPSink]
$ns attach-agent $n3 $tcpsink
$ns connect $tcp0 $tcpsink


set app0 [new Application/Traffic/CBR]
$app0 attach-agent $udp0


set app1 [new Application/FTP]
$app1 attach-agent $tcp0


$ns at 0.5 "$app0 start"
$ns at 4.5 "$app0 stop"

$ns at 0.5 "$app1 start"
$ns at 4.5 "$app1 stop"

$ns at 5 "finish"

$ns run
