#!/usr/bin/python2

from kafka import KafkaConsumer
import json

consumer = KafkaConsumer(group_id='different',bootstrap_servers='192.168.10.3:9093', auto_offset_reset='latest')
consumer.subscribe(['telemetry'])

host_ip="192.168.10.2"
measurement="Cisco-IOS-XR-wdsysmon-fd-oper:system-monitoring/cpu-utilization"
kpi=15

for message in consumer:
    data=json.loads(message.value)
    if data["Telemetry"]["encoding_path"] == measurement:
        if data["Rows"][0]["Content"]["total-cpu-one-minute"] > kpi:
		print("Trigger: one minute CPU on %s is %i" %( \
		data["Telemetry"]["node_id_str"], \
		data["Rows"][0]["Content"]["total-cpu-one-minute"]))
