#!/usr/bin/python2

from kafka import KafkaConsumer

#consumer = KafkaConsumer(group_id='different',bootstrap_servers='192.168.10.3:9093', auto_offset_reset='earliest')
consumer = KafkaConsumer(group_id='different',bootstrap_servers='192.168.10.3:9093', auto_offset_reset='latest')
consumer.subscribe(['telemetry'])
for message in consumer:
    print message
