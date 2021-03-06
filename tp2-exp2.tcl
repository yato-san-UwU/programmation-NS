# creation dun siulateur
set ns [new Simulator]
#creation dun fichier de trace 
set tcfl [open experienceG2.tr w]
$ns trace-all $tcfl
#		ajout de linstruction (1)
		set f1 [open file2.tr w]
		$ns trace-all $f1
				
#creation dun fichier nam
set nmfl [open experienceG2.nam w]
$ns namtrace-all $nmfl
		
#		ajout de close $f1
proc finish {} {
global ns tcfl nmfl f1
$ns flush-trace
close $tcfl
close $nmfl
close $f1
exec  nam experienceG2.nam & 
exit 0
}

#creation des 4 noueds
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n5 [$ns node]

#creation des ligne de communication 
$ns duplex-link $n1 $n2 1Mb 5ms DropTail
$ns duplex-link $n2 $n3 1Mb 5ms DropTail
$ns duplex-link $n3 $n5 1Mb 5ms DropTail


#creation des agent UDP et des agents vide qui recoivent les paquet 
#		noeud 1 et 2
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n2 $null1
$ns connect $udp1 $null1

#		noued 2 et 3
set udp2 [new Agent/UDP]
$ns attach-agent $n2 $udp2
set null2 [new Agent/Null]
$ns attach-agent $n3 $null2
$ns connect $udp2 $null2

#		noued 3 et 5
set udp3 [new Agent/UDP]
$ns attach-agent $n3 $udp3
set null3 [new Agent/LossMonitor]
$ns attach-agent $n5 $null3
$ns connect $udp3 $null3

#		procedure tracepqt 	null0 => null1 
		proc tracepqt {} {
		global null3 f1
		set ns [Simulator instance]
		set time 0.2
		set now [$ns now]
		puts $f1 "$now [$null3 set npkts_ ]"
		$ns at [expr $now+$time] "tracepqt"
		}

		$ns at 0.0 "tracepqt"

#creation des trafic CBR
#		udp1
set app1 [new Application/Traffic/CBR]
$app1 attach-agent $udp1

#		udp2
set app2 [new Application/Traffic/CBR]
$app2 attach-agent $udp2

#		udp3
set app3 [new Application/Traffic/CBR]
$app3 attach-agent $udp3

#scneario de debut et de fin 

$ns at 0.1 "$app1 start"
$ns at 0.114 "$app1 stop"

$ns at 0.114 "$app2 start"
$ns at 0.24 "$app2 stop"

$ns at 0.24 "$app3 start"
$ns at 0.28 "$app3 stop"

$ns at 0.28 "$app1 start"
$ns at 0.914 "$app1 stop"

$ns at 0.914 "$app2 start"
$ns at 1 "$app2 stop"


$ns at 1.5 "finish"

$ns run
