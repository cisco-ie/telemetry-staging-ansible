#  Stage a POC server and stream from your own network environment

## Requirements
 - Server to configure running Ubuntu Trusty Tahr (14.4) - basic server installation with ssh.
 - SSH connectivity to the server to configure.
 - Ansible installed on the device where you clone this repository (latest test on 2.4).

## Installation Procedure
 1. Clone this project using Git 
 2. Confirm you can SSH to the remote server to configure
 3. <a href="proxy.md" target="_blank">OPTIONAL - Configuring proxy support, if you environment requires</a>
 4. Update `ansible_hosts` with the target server IP and username to login (comment or delete 192.168.10.3 local host)
 5. OPTIONAL - Current installation create Influxdb with 6 hours retention and 1 hour shards (six hours of data rolling deleting the last hour). If you want a different setup, please update "environment/ansible/ansible/start_influx_grafana_kapacitor.yml", ansible task "Creating mdt_db database" with your values.
 6. Check that Ansible can manage the remote device using `ansible all -m ping -i ansible_hosts --ask-pass`
 7. Launch the installer `ansible-playbook stage.yml -i ansible_hosts --ask-pass --ask-become-pass --extra-vars "ntp_ip=all.ntp.esl.cisco.com" --skip-tag Lab"`, update with a suitable ntp_ip, if outside Cisco.
 8. When Ansible finishes, SSH to the remote server and execute `./telemetry_utility.sh` to control the environment - start, stop, reset, enable traffic dump... Note that the initial credentials have been saved in the Ansible's vault and the system will ask for a vault password that is the same password as your login.
 9. Follow the information in <a href="guides/Consuming_XR_Telemetry.pdf" target="_blank">Consuming XR Telemetry</a> but for the section describig the XRv router (and configure your network infrastructure to stream toward this server).

## What is going to be installed in the remote server?
 - Latest Docker and Docker-compose 1.15.0
 - Latest Pipeline
 - Influxdb version 1.3
 - Grafana version 4.5.2
 - Kapacitor version 1.3
 - Kafka 1.0.0
 - Telemetry_utility.sh script to manage the environment
 - NTP client
 - Exabgp 3.4.18

## Support files
Check the repository sub-directory test_server for a copy of the lab reference Influxdb daskboard, Postman collections, used in the lab.
 - influxdb_dashboard.json
 - InfluxDB_explore_metric.postman_collection.json
 - Kapacitor CPU KPI example.postman_collection.json

