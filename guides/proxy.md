# Deploying behind a proxy

If your environment doesn't support transparent proxy but it requires a proxy configuration, following these configurations have been successfully tested on Ubuntu Trusty.
TBA: newer version of Ubuntu and Centos 7 will be tested.

### Configure the proxy in /etc/environment 
Add the following three lines in /etc/environment with your specific proxy information

 - export http_proxy=http://proxy-ams-1.cisco.com:8080
 - export https_proxy=http://proxy-ams-1.cisco.com:8080
 - export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

### Update sudo configuration with visudo
Using `sudo visudo` update the environment default to support proxies for sudo account that is used when installing packages.
 - Comment `Defaults env_reset`
 - Add `Defaults env_keep += "http_proxy https_proxy no_proxy"`

### Notes - NO ACTION required
#### docker-compose.yml is already configured to use proxy

Containers are not able to use host environmental variables and must be explicitly configured.
Grafana requires a proxy to download a plugin and must be configured to avoid proxy when accessing InfluxDB.

The last three lines have been added to docker-compose.yml to support proxies in Grafana

  grafana:
    restart: always
    image: grafana/grafana:4.2.0
    environment:
     - "GF_INSTALL_PLUGINS=jdbranham-diagram-panel"
     - "GF_SECURITY_ADMIN_PASSWORD=admin"
     - "http_proxy=${http_proxy}"
     - "https_proxy=${https_proxy}"
     - "no_proxy=environment_influxdb_1,${no_proxy}"


#### Docker's proxies are configured by the Ansible's playbook

Docker is not using the environment variables when downloading the container images. Proxies must be configured in /etc/default/docker because I wasn't able to pass the host environment proxy variables.
Missing this configuration will log  "Error response from daemon: Get https://registry-1.docker.io/v2/: net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)"

These three lines will be added in /etc/default/docker with the specific proxy read from the environment variable with get_facts

export http_proxy="http://proxy-ams-1.cisco.com:8080"
export https_proxy="http://proxy-ams-1.cisco.com:8080"
export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

