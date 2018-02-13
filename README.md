# Consuming Cisco XR Model Driven Streaming Telemetry

##### Version 2.0
##### Released January 2, 2018
##### Author: Marco Umer, Gaurav Pande
##### Contact: Please use the Issues page to ask questions or open bugs and feature requests.

## Description

This project provides an all in one solution to experiment with Cisco XR Model Driven Telemetry (XRv router and server, as explained in Cisco dCloud TBA link) or an Ansible playbook supporting the installation of a ready to use environment which includes Pipeline, Influx, Grafana, Kapacitor, Apache Kafka and utilities for your lab or customer facilities.
The installation procedure has been validated on Ubuntu Trusty Tahr (14.4) because using init and APT but if there is interest, newer Ubuntu versions and Centos/Redhat will be considered.

This has been used to stage the Cisco dCloud demo (TBA link as demo pass quality control) and you can use the step by step <a href="https://cisco.box.com/v/consuming-XR-telemetry-lab" target="_blank">lab documentatio</a>n, to familiarize with an array of use cases.



## How do I use this project?
 - Create an all in one (XRv and server) environment using a pre-staged Vagrant server image (<a href="guides/all_one_image.md" target="_blank">link</a>).
   - Easier option (suggested starting point if testing on Windows)
   - Perfect for live demonstration.
   - Start in few minutes and doesn’t require Internet connectivity (after downloading images).
   - Can follow the dCloud lab documentation in my own local environment.
   - Requires Git and Vagrant (at least version 2.0.0) on your system
   - Assumes that you have already a Vagrant XRv image (tested with 6.1.4) or follow procedure from <a href="https://xrdocs.github.io/application-hosting/tutorials/iosxr-vagrant-quickstart" target="_blank">xrdocs link</a>

 - Create an all in one (XRv and server) environment but staging the server using Ansible from scratch (<a href="guides/all_one_ansible.md" target="_blank">link</a>).
   - Maximum flexibility - change software version and components.
   - Can still follow the dCloud lab documentation in my own local environment.
   - Requires Git, Vagrant (at least version 2.0.0) and Ansible (tested with 2.2 and 2.4) on your system
   - Assumes that you have already a Vagrant XRv image (tested with 6.1.4) or follow procedure from <a href="https://xrdocs.github.io/application-hosting/tutorials/iosxr-vagrant-quickstart" target="_blank">xrdocs link</a>
   
 - Use this project to stage a POC server and you will stream from your own network environment (<a href="guides/server_ansible.md" target="_blank">link</a>).
   - Requires Git and Ansible (tested with 2.2 and 2.4) on your system

## What is going to be installed in the remote server?
 - Latest Docker and Docker-compose 1.15.0
 - Latest Pipeline
 - Influxdb version 1.3
 - Grafana version 4.5.2
 - Kapacitor version 1.3
 - Kafka 1.0.0
 - Custom utility to manage the environment (telemetry_utility.sh and XR_demo.sh which is optional with lab tag)
 - NTP client
 - Ostinato 0.8.1 (optional lab tag)
 - Exabgp 3.4.18 (optional lab tag)

## Attributions

This project come about as an effort to provide a learning environment for consuming model driven streaming telemetry using open-source software. From the initial steps using [Pipeline]( https://github.com/cisco/bigmuddy-network-telemetry-pipeline) and [Bigmuddy collector stacks]( https://github.com/cisco/bigmuddy-network-telemetry-stacks), this project is the result of many personal lessons learned from automation and virtualization examples documented on the web and from the telemetry tutorials of Shelly Cadora in [xrdoc.github.io](https://xrdocs.github.io/telemetry/tutorials).  
This project is an integration of many open-source projects and it would not have been possible without the contributions from [Influxdata](https://www.influxdata.com), [Grafana Labs](https://grafana.com), [Vagrant]( https://www.vagrantup.com), [VirtualBox]( https://www.virtualbox.org/), [Ansible]( https://www.ansible.com), [Docker](https://www.docker.com), [Ostinato]( https://ostinato.org), [Kafka]( https://kafka.apache.org), [ExaBGP](https://github.com/Exa-Networks/exabgp) and [kafka-doker repository]( https://github.com/wurstmeister/kafka-docker).
 
## License

MIT © [Cisco Innovation Edge](https://github.com/cisco-ie/telemetry-staging-ansible) 
