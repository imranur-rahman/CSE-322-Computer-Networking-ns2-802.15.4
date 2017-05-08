#!/bin/bash

node_start=20;
node_end=60;

flow_start=10;
flow_end=50;

pack_start=100;
pack_end=500;

coverage_start=1;
coverage_end=5;

node_cur=$node_start;

printf "YUnitText: Throughput\nXUnitText: Coverage_multiplier\n\"\"\n0 0.0\n" > coverage_multiplier_vs_throughput.xgr
printf "YUnitText: Delay\nXUnitText: Coverage_multiplier\n\"\"\n0 0.0\n" > coverage_multiplier_vs_delay.xgr
printf "YUnitText: Delivery Ratio\nXUnitText: Coverage_multiplier\n\"\"\n0 0.0\n" > coverage_multiplier_vs_delv_ratio.xgr
printf "YUnitText: Drop Ratio\nXUnitText: Coverage_multiplier\n\"\"\n0 0.0\n" > coverage_multiplier_vs_drop_ratio.xgr
printf "YUnitText: Energy Consumption\nXUnitText: Coverage_multiplier\n\"\"\n0 0.0\n" > coverage_multiplier_vs_energy_consumption.xgr



while [ $coverage_start -le $coverage_end ]

do
	
	row=5;
	col=$(($node_cur/$row));

	ns 802_11_udp.tcl $row $col $flow_start $pack_start $coverage_start
	awk -f rule_wireless_udp.awk 802_11_udp.tr > 802_11_udp.out

	l=0;
	while read line
	do
		l=$(($l+1))
		#printf $line
		if [ "$l" == "1" ]; then
			printf "$coverage_start $line\n" >> coverage_multiplier_vs_throughput.xgr
		elif [ "$l" == "2" ]; then
			printf "$coverage_start $line\n" >> coverage_multiplier_vs_delay.xgr
		elif [ "$l" == "3" ]; then
			printf "$coverage_start $line\n" >> coverage_multiplier_vs_delv_ratio.xgr
		elif [ "$l" == "4" ]; then
			printf "$coverage_start $line\n" >> coverage_multiplier_vs_drop_ratio.xgr
		elif [ "$l" == "5" ]; then
			printf "$coverage_start $line\n" >> coverage_multiplier_vs_energy_consumption.xgr
		fi
	done < 802_11_udp.out
	
	coverage_start=$(($coverage_start+1))
done