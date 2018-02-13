# All in one installation staged by Ansible

By the end of this procedure, you are going to have a XRv router and Telemetry Ubuntu server, on your local environment (laptop with at least 8G RAM or server) and you will be able to follow and customise the <a href="https://cisco.box.com/v/consuming-XR-telemetry-lab" target="_blank">Telemetry Dcloud lab documentation</a>.

The Telemetry server will be configured using an Ansible playbook, that you can customised based on your requirements. 

## Requirements
 - VirtualBox (last test on version 5.1.30)
 - Vagrant (at east 2.0.0 version)
 - Vagrant XRv image (tested with 6.1.4 and saved as IOS-XRv in Vagrant) or follow procedure from <a href="https://xrdocs.github.io/application-hosting/tutorials/iosxr-vagrant-quickstart" target="_blank">xrdocs link</a>
   - update Vagrantfile is you saved XRv box image with a different name than IOS_XRv.
 - Ansible installed on the device where you clone this repository (latest test on 2.4).

## Installation Procedure
 1. Clone this project using Git.
 2. <a href="proxy.md" target="_blank">OPTIONAL - Configuring proxy support, if you environment requires</a>.
 3. Change directory to test_server in the cloned project.
 4. Optional - use `vagrant box add ubuntu/trusty64` to cache the Ubuntu server image, if you don't have already a copy. Required the first time only, it may take over 1 hour to download. 
 5. Launch the XRv router and server using `vagrant up`.
 6. Move to the project top directory (cd ..).
 7. Confirm the target server in  `ansible_hosts` is 192.168.10.3 and username vagrant.
 8. OPTIONAL - Current installation create Influxdb with 6 hours retention and 1 hour shards (six hours of data rolling deleting the last hour). If you want a different setup, please update "environment/ansible/ansible/start_influx_grafana_kapacitor.yml", ansible task "Creating mdt_db database" with your values.
 9. Check that Ansible can manage the remote device using `ansible all -m ping -i ansible_hosts --ask-pass`.
 10. Launch the installer `ansible-playbook stage.yml -i ansible_hosts --ask-pass --ask-become-pass --extra-vars "ntp_ip=all.ntp.esl.cisco.com -tag Lab"`, update with a suitable ntp_ip, if outside Cisco.
 11. When Ansible finishes, SSH to the remote server (i.e. ssh vagrant@127.0.0.1 -p 2013) and execute `./telemetry_utility.sh` to control the environment - start, stop, reset, enable traffic dump... Note that the initial credentials have been saved in the Ansible's vault and the system will ask for a vault password that is the same password as your login.
 12. Follow the information in <a href="guides/Consuming_XR_Telemetry.pdf" target="_blank">Consuming XR Telemetry</a>.

## What is going to be installed in the remote server?
 - Latest Docker and Docker-compose 1.15.0
 - Latest Pipeline
 - Influxdb version 1.3
 - Grafana version 4.5.2
 - Kapacitor version 1.3
 - Kafka 1.0.0
 - NTP client
 - Custom utility to manage the environment (telemetry_utility.sh and XR_demo.sh which is optional with lab tag)
 - Exabgp 3.4.18

## Note for Ostinato
Ostinato is not currently included in this installation because the installer for 0.8.1 (required in this demo) are not anymore freely avaialble.
You can still download the debian packages and client for a 2$+ donation from http://ostinato.org/downloads.
 - Installation is tested with ubuntu14.04-ostinato_0.8-1_amd64.deb. 

To install on the server after procuring ubuntu14.04-ostinato_0.8-1_amd64.deb:
 - copy ubuntu14.04-ostinato_0.8-1_amd64.deb on the telemetry server
 - sudo apt-get install xvfb
 - sudo apt-get install gdebi
 - sudo gdebi --option=APT::Get::Assume-Yes="true" -n ubuntu14.04-ostinato_0.8-1_amd64.deb
