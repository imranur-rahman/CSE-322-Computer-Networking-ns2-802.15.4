set num_row 4
set num_col 3
for {set i 0} {$i < [expr $num_col * $num_row]} {incr i $num_row} {
#	puts "$i"
	for {set j 0} {$j < [expr $num_row - 1]} {incr j} {
		set from_node [expr $i + $j]
		set to_node [expr $from_node + 1] 
#		$ns_ duplex_link $node_($from_node) $node_($to_node) cbr_rate cbr_interval queue_type
		puts "$from_node $to_node"
	}
}
#set i [expr $i + $num_row]