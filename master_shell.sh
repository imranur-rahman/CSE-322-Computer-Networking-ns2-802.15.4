#!/bin/bash


i=0;
j=4;

while [ $i -lt $j ]
do
	#statements
	node_start=20;
	node_end=60;

	flow_start=10;
	flow_end=50;

	pack_start=100;
	pack_end=500;

	coverage_start=1;
	coverage_end=1000;

	node_cur=$node_start;

	if [ "$i" == "0" ]; then
		thr_xgr="node_vs_throughput.xgr"
		del_xgr="node_vs_delay.xgr"
		delv_ratio_xgr="node_vs_delv_ratio.xgr"
		drop_ratio_xgr="node_vs_drop_ratio.xgr"
		energy_consumption_xgr="node_vs_energy_consumption.xgr"
	elif [ "$i" == "1" ]; then
		thr_xgr="flow_vs_throughput.xgr"
		del_xgr="flow_vs_delay.xgr"
		delv_ratio_xgr="flow_vs_delv_ratio.xgr"
		drop_ratio_xgr="flow_vs_drop_ratio.xgr"
		energy_consumption_xgr="flow_vs_energy_consumption.xgr"
	elif [ "$i" == "2" ]; then
		thr_xgr="pckt_per_sec_vs_throughput.xgr"
		del_xgr="pckt_per_sec_vs_delay.xgr"
		delv_ratio_xgr="pckt_per_sec_vs_delv_ratio.xgr"
		drop_ratio_xgr="pckt_per_sec_vs_drop_ratio.xgr"
		energy_consumption_xgr="pckt_per_sec_vs_energy_consumption.xgr"
	elif [ "$i" == "3" ]; then
		thr_xgr="coverage_factor_vs_throughput.xgr"
		del_xgr="coverage_factor_vs_delay.xgr"
		delv_ratio_xgr="coverage_factor_vs_delv_ratio.xgr"
		drop_ratio_xgr="coverage_factor_vs_drop_ratio.xgr"
		energy_consumption_xgr="coverage_factor_vs_energy_consumption.xgr"
	fi

	printf "YUnitText: Throughput\nXUnitText: Num of Nodes\n\"\"\n0 0.0\n" > "$thr_xgr"
	printf "YUnitText: Delay\nXUnitText: Num of Nodes\n\"\"\n0 0.0\n" > "$del_xgr"
	printf "YUnitText: Delivery Ratio\nXUnitText: Num of Nodes\n\"\"\n0 0.0\n" > "$delv_ratio_xgr"
	printf "YUnitText: Drop Ratio\nXUnitText: Num of Nodes\n\"\"\n0 0.0\n" > "$drop_ratio_xgr"
	printf "YUnitText: Energy Consumption\nXUnitText: Num of Nodes\n\"\"\n0 0.0\n" > "$energy_consumption_xgr"


	k=0;
	l=5;

	while [ $k -lt $l ]; do
		#statements
		row=10;
		col=$(($node_cur/$row));

		ns 802_11_udp.tcl $row $col $flow_start $pack_start $coverage_start
		awk -f rule_wireless_udp.awk 802_11_udp.tr > 802_11_udp.out

		l=0;
		while read line; do
			l=$(($l+1))
			#printf $line
			if [ "$l" == "1" ]; then
				printf "$node_cur $line\n" >> node_vs_throughput.xgr
			elif [ "$l" == "2" ]; then
				printf "$node_cur $line\n" >> node_vs_delay.xgr
			elif [ "$l" == "3" ]; then
				printf "$node_cur $line\n" >> node_vs_delv_ratio.xgr
			elif [ "$l" == "4" ]; then
				printf "$node_cur $line\n" >> node_vs_drop_ratio.xgr
			elif [ "$l" == "5" ]; then
				printf "$node_cur $line\n" >> node_vs_energy_consumption.xgr
			fi
		done < 802_11_udp.out

		if [ "$i" == "0" ]; then
			node_cur=$(($node_cur+10))
		elif [ "$i" == "1" ]; then
			flow_start=$(($flow_start+10))
		elif [ "$i" == "2" ]; then
			pack_start=$(($pack_start+100))
		elif [ "$i" == "3" ]; then
			coverage_start=$(($coverage_start+1))
		fi
		k=$(($k+1))
	done
	i=$(($i+1))
done
