# Introduction to Kapacitor alarms in KPIG
### Kapacitor, Pipeline, Influx, Grafana

This is a cheatsheet summarizing the commands used in the "Introduction to Kapacitor alarms in KPIG" webex recording.

 - Play https://cisco.webex.com/cisco/ldr.php?RCID=8d5866235ea7a6ec5957e269e6a87002 (30 min)
 - Recording password: eSRhDFE6

### Stage the KPIG environment and check its status
Stage the environment as described in the following repositories and ssh to the environment
- https://cto-github.cisco.com/APJ-GSP-ADT/telemetry-staging-ansible
- https://wwwin-github.cisco.com/APJ-GSP-ADT/telemetry-staging-ansible

I am assuming I have already a router streaming to the environment (or you may use the included test server and XRv router,  as explained in the repository README).

Validate that your environment is running: `~/start_stop_reset_ansible.sh` and select option 1

### Let's investigate a measurement with Influxdb CLI before configuring a KPI in Kapacitor
 - `cd environment/`
 - `docker-compose run influxdb-cli`

#### Useful commands:
 - `show databases`
 - `use mdt_db`
 - `show measurements`     ... we are going to work with "Cisco-IOS-XR-wdsysmon-fd-oper:system-monitoring/cpu-utilization"
 - `show tag keys from "Cisco-IOS-XR-wdsysmon-fd-oper:system-monitoring/cpu-utilization"`

 - `show tag values from "Cisco-IOS-XR-wdsysmon-fd-oper:system-monitoring/cpu-utilization" with key = "Producer"`
 - `show tag values from "Cisco-IOS-XR-wdsysmon-fd-oper:system-monitoring/cpu-utilization" with key = "node-name"`
 - `show tag values from "Cisco-IOS-XR-wdsysmon-fd-oper:system-monitoring/cpu-utilization" with key = "process-cpu__process-name"`

 - `show field keys from "Cisco-IOS-XR-wdsysmon-fd-oper:system-monitoring/cpu-utilization"`

 - `select * from "Cisco-IOS-XR-wdsysmon-fd-oper:system-monitoring/cpu-utilization" limit 10`
 - `precision rfc3339`
 
We are interested to the metric with null process-name but be carefull there is more than one ... carefull using '' and no ""
 - `select * from "Cisco-IOS-XR-wdsysmon-fd-oper:system-monitoring/cpu-utilization" where "process-cpu__process-name"='' limit 10`

Before leaving Influxdb-cli, check the Kapacitor subscription status
 - `show subscriptions`

#### Now we understand the data ... we can create an alarm ... time to explore Kapacitor CLI
#### Useful commands:

 - `cd environment/`
 - `docker-compose run kapacitor-cli`

 - Type `kapacitor` for a list of commands supported

Check for the measurement name, database and the retention policy
(mdt_db,test6h,Cisco-IOS-XR-wdsysmon-fd-oper:system-monitoring/cpu-utilization)
 - `kapacitor stats ingress`         

To understand Kapacitor TICK scripting: https://docs.influxdata.com/kapacitor/v0.2/tick/

Explore an example prepared for CPU utilization and included in the environment:
 - `cd ~/ticks`
 - `cat cpu_alert_one_minute.tick`

Adjust with the database name and retention for your environment as shown in "kapacitor stats ingress"

 - `kapacitor list tasks`
 - `kapacitor define cpu_alert_one_minute -type stream -tick ~/ticks/cpu_alert_one_minute.tick -dbrp mdt_db.test6h`
 - `kapacitor list tasks`
 - `kapacitor show cpu_alert_one_minute`
 - `kapacitor enable cpu_alert_one_minute`
 - `kapacitor list tasks`
 - `kapacitor show cpu_alert_one_minute`
 - `kapacitor delete tasks cpu_alert_one_minute`

Note: Remember that if you change the tick you have to reload:

 - `kapacitor define cpu_alert_one_minute -type stream -tick cpu_alert_one_minute.tick -dbrp mdt_db.test6h`
 - `kapacitor reload cpu_alert_one_minute`
 - `kapacitor show cpu_alert_one_minute`

Now we can test this process by increasing the CPU on the router with a sweep ping or by initially using synthetic data injected in Influx

Note: the staging environment includes a basic web application to process POST alarms that you may personalize to drive your tests
 - Launch using `~/environment/web-alarm.py`

### Controlling Kapacitor's alarms by API is more agile
https://www.getpostman.com/collections/13598fd6ddec3edd1275 to download the Postman collection used in this demo 
(ready for the repo's test environment) ... For a different environment, just update the target server IP address.



