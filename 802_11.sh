#		CHANGE PATH IN 4 PLACES *******************************************************
#INPUT: output file AND number of iterations
output_file_format="802_11_udp"
iteration_float=1.0;

start=1
end=1

hop_15_4=5
dist_15_4=30
dist_11=$ expr $hop_15_4*$dist_15_4*2

pckt_size=64
pckt_per_sec=1000
#pckt_interval=[expr 1 / $pckt_per_sec]
#echo "INERVAL: $pckt_interval"

routing=DSDV

time_sim=10

iteration=$(printf %.0f $iteration_float)

r=$start


throughputFile="throughput.xgr"
avgDelayFile="avgDelay.xgr"
pcktDeliveryRatioFile="pcktDeliveryRatio.xgr"
pcktDropRatioFile="pcktDropRatio.xgr"
energyConsumptionFile="energyConsumption.xgr"


num_row=10
num_col=2
num_flow=10
pckt_per_sec=100
coverage_multiplier=1


varying=0
uptoVarying=5
while [ $varying -lt $uptoVarying ]
do

	r=$start
	while [ $r -le $end ]
	do
	echo "total iteration: $iteration"
	###############################START A ROUND
	l=0;thr=0.0;del=0.0;s_packet=0.0;r_packet=0.0;d_packet=0.0;del_ratio=0.0;
	dr_ratio=0.0;time=0.0;t_energy=0.0;energy_bit=0.0;energy_byte=0.0;energy_packet=0.0;total_retransmit=0.0;energy_efficiency=0.0;

	i=0
		while [ $i -lt $iteration ]
		do
		#################START AN ITERATION
		echo "                             EXECUTING $(($i+1)) th ITERATION"


		#                            CHNG PATH		1		######################################################
		ns 802_11_udp.tcl $num_row $num_col $num_flow $pckt_per_sec $coverage_multiplier # $dist_11 $pckt_size $pckt_per_sec $routing $time_sim
		echo "SIMULATION COMPLETE. BUILDING STAT......"
		#awk -f rule_th_del_enr_tcp.awk 802_11_grid_tcp_with_energy_random_traffic.tr > math_model1.out
		#                            CHNG PATH		2		######################################################
		awk -f rule_wireless_udp.awk 802_11_udp.tr > 802_11_udp.out
		#awk -f myflowcalcall.awk 802_11_udp.tr > 802_11_udp.xgr

		#xgraph 802_11_udp.xgr

		ok=1;
			while read val
			do
			#	l=$(($l+$inc))
				l=$(($l+1))


				if [ "$l" == "1" ]; then
					if [ `echo "if($val > 0.0) 1; if($val <= 0.0) 0" | bc` -eq 0 ]; then
						ok=0;
						break
						fi	
					thr=$(echo "scale=5; $thr+$val/$iteration_float" | bc)
			#		echo -ne "throughput: $thr "
				elif [ "$l" == "2" ]; then
					del=$(echo "scale=5; $del+$val/$iteration_float" | bc)
			#		echo -ne "delay: "
				elif [ "$l" == "3" ]; then
					s_packet=$(echo "scale=5; $s_packet+$val/$iteration_float" | bc)
			#		echo -ne "send packet: "
				elif [ "$l" == "4" ]; then
					r_packet=$(echo "scale=5; $r_packet+$val/$iteration_float" | bc)
			#		echo -ne "received packet: "
				elif [ "$l" == "5" ]; then
					d_packet=$(echo "scale=5; $d_packet+$val/$iteration_float" | bc)
			#		echo -ne "drop packet: "
				elif [ "$l" == "6" ]; then
					del_ratio=$(echo "scale=5; $del_ratio+$val/$iteration_float" | bc)
			#		echo -ne "delivery ratio: "
				elif [ "$l" == "7" ]; then
					dr_ratio=$(echo "scale=5; $dr_ratio+$val/$iteration_float" | bc)
			#		echo -ne "drop ratio: "
				elif [ "$l" == "8" ]; then
					time=$(echo "scale=5; $time+$val/$iteration_float" | bc)
			#		echo -ne "time: "
				elif [ "$l" == "9" ]; then
					t_energy=$(echo "scale=5; $t_energy+$val/$iteration_float" | bc)
			#		echo -ne "total_energy: "
				elif [ "$l" == "10" ]; then
					energy_bit=$(echo "scale=5; $energy_bit+$val/$iteration_float" | bc)
			#		echo -ne "energy_per_bit: "
				elif [ "$l" == "11" ]; then
					energy_byte=$(echo "scale=5; $energy_byte+$val/$iteration_float" | bc)
			#		echo -ne "energy_per_byte: "
				elif [ "$l" == "12" ]; then
					energy_packet=$(echo "scale=5; $energy_packet+$val/$iteration_float" | bc)
			#		echo -ne "energy_per_packet: "
				elif [ "$l" == "13" ]; then
					total_retransmit=$(echo "scale=5; $total_retransmit+$val/$iteration_float" | bc)
			#		echo -ne "total_retrnsmit: "
				elif [ "$l" == "14" ]; then
					energy_efficiency=$(echo "scale=9; $energy_efficiency+$val/$iteration_float" | bc)
			#		echo -ne "energy_efficiency: "
				fi


				echo "$val"
			#                            CHNG PATH		3		######################################################
			done < 802_11_udp.out

		if [ "$ok" -eq "0" ]; then
			l=0;
			ok=1;
			continue
			fi
		i=$(($i+1))
		l=0
		#################END AN ITERATION
		done

	enr_nj=$(echo "scale=2; $energy_efficiency*1000000000.0" | bc)

	#dir="/home/ubuntu/ns2\ programs/raw_data/"
	#tdir="/home/ubuntu/ns2\ programs/multi-radio\ random\ topology/"
	#                            CHNG PATH		4		######################################################

	#for getting the current directory
	cd results/
	dir=$(pwd)
	cd ..

	under="_"
	output_file="$dir/$output_file_format$under$r.out"

	#echo "$dir/$output_file_format$under$r.out"

	#touch "$output_file"


	(
	echo "Throughput:           		$thr "
	echo "AverageDelay:         		$del "
	echo "Sent Packets:         		$s_packet "
	echo "Received Packets:         	$r_packet "
	echo "Dropped Packets:          	$d_packet "
	echo "PacketDeliveryRatio:      	$del_ratio "
	echo "PacketDropRatio:      		$dr_ratio "
	echo "Total time:  					$time "
	echo ""
	echo ""
	echo "Total energy consumption:     $t_energy "
	echo "Average Energy per bit:       $energy_bit "
	echo "Average Energy per byte:      $energy_byte "
	echo "Average energy per packet:    $energy_packet "
	echo "total_retransmit:         	$total_retransmit "
	echo "energy_efficiency(nj/bit):    $enr_nj "
	echo ""
	) >> "$output_file"
	#appending

	num_node=$(($num_row*$num_col))
	echo "$num_node $thr" >> "$throughputFile"
	echo "$num_node $del" >> "$avgDelayFile"
	echo "$num_node $del_ratio" >> "$pcktDeliveryRatioFile"
	echo "$num_node $dr_ratio" >> "$pcktDropRatioFile"
	echo "$num_node $t_energy" >> "$energyConsumptionFile"


	r=$(($r+1))
	#######################################END A ROUND
	done



if [ "$varying" == "0" ]; then
		num_col=$(($num_col+1))
elif [ "$varying" == "1" ]; then
		num_flow=$(($num_flow+10))
elif [ "$varying" == "2" ]; then
		pckt_per_sec=$(($pckt_per_sec+100))
elif [ "$varying" == "3" ]; then
		coverage_multiplier=$(($coverage_multiplier+1))
fi

varying=$(($varying+1))
echo "$varying"
done
