# All in one installation using Vagrant server image

By the end of this procedure, you are going to have a XRv router and Telemetry Ubuntu server, on your local environment (laptop with at least 8G RAM or server) and you will be able to follow and customise the <a href="https://cisco.box.com/v/consuming-XR-telemetry-lab" target="_blank">Telemetry Dcloud lab documentation</a>.

## Requirements
 - VirtualBox (last test on version 5.1.30)
 - Vagrant (at east 2.0.0 version)
 - Vagrant XRv image (tested with 6.1.4 and saved as IOS-XRv in Vagrant) or follow procedure from <a href="https://xrdocs.github.io/application-hosting/tutorials/iosxr-vagrant-quickstart" target="_blank">xrdocs link</a>
   - update Vagrantfile if you saved XRv box image with a different name than IOS-XRv.

## Installation Procedure (<a href="https://cisco.box.com/v/MDT-lab-install-box-option" target="_blank"> Video </a>)

 1. Clone this project using Git
 2. Dowload the telemetry server image from https://cisco.box.com/v/all-one-telemetry-image
 3. Load the telemetry image in Vagrant: "vagrant box add KPIG_040118 KPIG_040118.box", after checking that the file downloaded matches KPIG_040118.box
 4. Change directory to test_server in the cloned project
 5. Comment out with a # server.vm.box = "ubuntu/trusty64" in Vagrantfile
 6. Remove comment from #server.vm.box = "KPIG_040118" in Vagrantfile  
 7. Launch the XRv router and server using "vagrant up"
 5. OPTIONAL - Current installation create Influxdb with 6 hours retention and 1 hour shards (six hours of data rolling deleting the last hour). If you want a different setup, please update "environment/ansible/ansible/start_influx_grafana_kapacitor.yml", ansible task "Creating mdt_db database" with your values.
 8. When Ansible finishes, SSH to the remote server (i.e. ssh vagrant@127.0.0.1 -p 2013) and execute `./telemetry_utility.sh` to control the environment - start, stop, reset, enable traffic dump... Note that the initial credentials have been saved in the Ansible's vault and the system will ask for a vault password that is the same password as your login.
 9. Follow the information in <a href="guides/Consuming_XR_Telemetry.pdf" target="_blank">Consuming XR Telemetry</a>.

## What is installed in the remote server?
 - Latest Docker and Docker-compose 1.15.0
 - Latest Pipeline
 - Influxdb version 1.3
 - Grafana version 4.5.2
 - Kapacitor version 1.3
 - Kafka 1.0.0
 - NTP client
 - Custom utility to manage the environment (telemetry_utility.sh and XR_demo.sh which is optional with lab tag)
 - Exabgp 3.4.18 
 - Ostinato 0.8.1

## Support files
Check the repository sub-directory test_server for a copy of the lab reference Influxdb daskboard, Postman collections and Ostinato example stream, used in the lab.
 - influxdb_dashboard.json
 - InfluxDB_explore_metric.postman_collection.json
 - Kapacitor CPU KPI example.postman_collection.json
 - first_stream.ostm 

## Note for Ostinato
Ostinato Drone 0.8.1 is installed on the server but if you want to use Ostinato, you will also need a client for your system version 0.8.1.
You can download the client for a 2$+ donation from http://ostinato.org/downloads.

