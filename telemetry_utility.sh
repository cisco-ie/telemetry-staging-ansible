ansible_env_path=~/environment/ansible


PS3='Please enter your choice: '
echo
options=("Verify Environment" "Destroy & Clean Environment" "Start/Stop Pipeline" "Re-start Pipeline" "Start/Stop Influx, Grafana & Kapacitor" "Start/Stop Kafka" "Toggle Pipeline dump logging" "Truncate Pipeline dump logging" "Exit")
select opt in "${options[@]}"
do
    case $opt in
     "Verify Environment")
         echo
         echo -e "\e[1m!!! Currently checking for Pipeline, Grafana and Influxdb !!!\e[0m"
         echo


         result=`pgrep -c pipeline`

         if [ $result -eq "1" ] ; then
           echo -e "Checking Pipeline ... \033[32mrunning\e[0m"
           echo
         elif [ $result -eq "0" ] ; then
           echo -e "Checking Pipeline ... \033[31mdown\e[0m"
           echo
         else
           echo "Too many instance of Pipeline are running - PID number `pgrep pipeline`" 
           echo "You may want to stop and restart the environment"
           echo
         fi

             if grep -q "\[TCPDialout\]" environment/pipeline.conf; then
                echo -e "   Input Stage: TCP Dial-Out"
             fi
             if grep -q "\[gRPCDialout\]" environment/pipeline.conf; then
                echo -e "   Input Stage: gRPC Dial-Out"
             fi
             if grep -q "\[gRPCDialin\]" environment/pipeline.conf; then
                echo -e "   Input Stage: gRPC Dial-In"
             fi
             if grep -q "\[inspector\]" environment/pipeline.conf; then
                echo -e "   Output Stage: TAP dump.txt"
             fi
             if grep -q "\[kafka\]" environment/pipeline.conf; then
                echo -e "   Output Stage: Apache Kafka"
             fi
             if grep -q "\[influx\]" environment/pipeline.conf; then
                echo -e "   Output Stage: Influx TSDB" 
             fi

         result=`docker ps --filter "name=grafana" --filter "status=running" | sed -n '1!p' | wc -l`

         if [ $result -eq "1" ] ; then
           echo
           echo -e "Checking Grafana ... \033[32mrunning\e[0m"
           echo 
         elif [ $result -eq "0" ] ; then 
	   echo
           echo -e "Checking Grafana ... \033[31mdown\e[0m"
           echo
        fi 

         # using _ in name=influxdb_ to discriminated from influx-cli
         result=`docker ps --filter "name=influxdb_" --filter "status=running" | sed -n '1!p' | wc -l`

         if [ $result -eq "1" ] ; then
           echo -e "Checking Influxdb ... \033[32mrunning\e[0m"
           code=$(curl -sl -I localhost:8086/ping | grep HTTP/1.1 | awk '{print $2}')
           if [ $code -eq "204" ] ; then
	     echo
	     echo -e "   Pinging Influxdb API ... \033[32m OK ($code)\e[0m"
           else
	     echo
	     echo -e "   Pinging Influxdb API ... \033[31m$code\e[0m"
           fi
           echo   
         elif [ $result -eq "0" ] ; then 
           echo -e "Checking Influxdb ... \033[31mdown\e[0m"
           echo
        fi

         result=`docker ps --filter "name=kapacitor" --filter "status=running" | sed -n '1!p' | wc -l`
         if [ $result -eq "1" ] ; then
           echo -e "Checking Kapacitor ... \033[32mrunning\e[0m"
           code=$(curl -sl -I localhost:9092/kapacitor/v1/ping | grep HTTP/1.1 | awk '{print $2}')
           if [ $code -eq "204" ] ; then
	     echo
             echo -e "   Pinging Kapacitor API ... \033[32m OK ($code)\e[0m"
           else
	     echo
             echo -e "   Pinging Kapacitor API ... \033[31m$code\e[0m"
           fi
           echo 
         elif [ $result -eq "0" ] ; then
           echo -e "Checking Kapacitor ... \033[31mdown\e[0m"
           echo
        fi

         result=`docker ps --filter "name=kafkadocker_kafka" --filter "status=running" | sed -n '1!p' | wc -l`
         if [ $result -gt "0" ] ; then
           echo -e "Checking Kafka ... \033[32mrunning\e[0m"
           port=$(nc -z 127.0.0.1 9093 -v 2>&1)  #2>&1 required to redirect 2(error) to 1(normal output)

           if [[ $port == *"succeeded"* ]]; then
	     echo
             echo -e "   Testing Kafka Broker TCP 9093 port ... \033[32m succeeded ! \e[0m"
	     echo
           else
             echo
             echo -e "   Testing Kafka Kafka Broker TCP 9093 port ... \033[31mfailed: Connection refused\e[0m"
	     echo
           fi
           #echo 
         elif [ $result -eq "0" ] ; then
           echo -e "Checking Kafka ... \033[31mdown\e[0m"
           echo
        fi

         result=`docker ps --filter "name=zookeeper" --filter "status=running" | sed -n '1!p' | wc -l`
         if [ $result -gt "0" ] ; then
           echo -e "Checking Zookeeper ... \033[32mrunning\e[0m"
           port=$(nc -z 127.0.0.1 2181 -v 2>&1)  #2>&1 required to redirect 2(error) to 1(normal output)

           if [[ $port == *"succeeded"* ]]; then
             echo -e " - Testing Zookeeper TCP 2181 port ... \033[32m succeeded ! \e[0m"
             echo
           else
             echo -e " - Testing Zookeeper TCP 2181 port ... \033[31mfailed: Connection refused\e[0m"
             echo
           fi
           #echo 
         elif [ $result -eq "0" ] ; then
           echo -e "Checking Zookeeper ... \033[31mdown\e[0m"
           echo
        fi

         ;;

     "Destroy & Clean Environment")
	 echo
         echo -e "\e[1m!!! Ready to shutdown Pipeline, destroy all Docker containers and clean timeseries, dumps and log !!!\e[0m"
         echo
         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
 	 ansible-playbook $ansible_env_path/clean.yml -i $ansible_env_path/ansible_hosts  --ask-vault-pass
	 echo
         ;; 

     "Start/Stop Pipeline")
	if pgrep pipeline &>/dev/null; then
	   echo
           echo -e "\e[1m!!! Ready to STOP Pipeline !!!\e[0m"
           echo
           read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
           echo
           ansible-playbook $ansible_env_path/stop_pipeline.yml -i $ansible_env_path/ansible_hosts  --ask-vault-pass
	else
           echo
           echo -e "\e[1m!!! Ready to START Pipeline !!!\e[0m"
           echo
           read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
           echo
           ansible-playbook $ansible_env_path/start_pipeline.yml -i $ansible_env_path/ansible_hosts  --ask-vault-pass
	fi
        ;;

     "Re-start Pipeline")
         echo
         echo -e "\e[1m!!! Ready to RE-START Pipeline !!!\e[0m"
         echo
         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'

         result=`pgrep -c pipeline`
         if [ $result -eq "1" ] ; then
           echo
	   sudo service pipeline restart 
           echo
         elif [ $result -eq "0" ] ; then
           echo -e "Checking Pipeline ... \033[31mis currently downn\e[0m"
           echo
         fi
	;;

     "Start/Stop Influx, Grafana & Kapacitor")
       # using _ in name=influxdb_ to discriminated from influx-cli_
       result=`docker ps --filter "name=influxdb_" --filter "status=running" | sed -n '1!p' | wc -l`

       if [ $result -eq "0" ] ; then
	 echo
         echo -e "\e[1m!!! Ready to START InfluxDB, Kapacitor and Grafana !!!\e[0m"
         echo
         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
	 echo
         ansible-playbook $ansible_env_path/start_influx_grafana_kapacitor.yml -i $ansible_env_path/ansible_hosts  --ask-vault-pass
       else	 
         echo
         echo -e "\e[1m!!! Ready to STOP InfluxDB, Kapacitor and Grafana !!!\e[0m"
         echo
         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         echo
         ansible-playbook $ansible_env_path/stop_influx_grafana_kapacitor.yml -i $ansible_env_path/ansible_hosts  --ask-vault-pass
       fi
       ;;

     "Start/Stop Kafka")
       result=`docker ps --filter "name=kafkadocker_kafka" --filter "status=running" | sed -n '1!p' | wc -l`

       if [ $result -eq "0" ] ; then
         echo
         echo -e "\e[1m!!! Ready to START Apache Kafka !!!\e[0m"
         echo
         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         echo
         ansible-playbook $ansible_env_path/start_kafka.yml -i $ansible_env_path/ansible_hosts  --ask-vault-pass
       else
         echo
         echo -e "\e[1m!!! Ready to STOP Apche Kafka !!!\e[0m"
         echo
         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         echo
         ansible-playbook $ansible_env_path/stop_kafka.yml -i $ansible_env_path/ansible_hosts  --ask-vault-pass
       fi
       ;;

     "Stop Environment")
         echo
         echo -e "\e[1m!!! Ready to stop Pipeline, InfluxDB, Kapacitor and Grafana  !!!\e[0m"
         echo " Note: this will not clean your environmet ... use Clean-up for that"
         echo
         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         echo
         ansible-playbook $ansible_env_path/stop.yml -i $ansible_env_path/ansible_hosts  --ask-vault-pass
         #break
         ;;

     "Toggle Pipeline dump logging")
         if grep -q "\[inspector\]" environment/pipeline.conf; then
         echo
         echo -e "\e[1m!!! Ready to DISABLE Pipeline dump logging !!!\e[0m"
         echo
         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         echo
         ansible-playbook $ansible_env_path/stop_dump.yml -i $ansible_env_path/ansible_hosts  --ask-vault-pass
       else
         echo
         echo -e "\e[1m!!! Ready to ENABLE Pipeline dump logging !!!\e[0m"
         echo
         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         echo
         ansible-playbook $ansible_env_path/start_dump.yml -i $ansible_env_path/ansible_hosts  --ask-vault-pass
       fi
        ;;

     "Truncate Pipeline dump logging")
        echo
	if [ -f ~/log/dump.txt ]; then
	  echo
          truncate -s 0 ~/log/dump.txt
          echo -e "Truncating dump.txt ... \033[32mdone\e[0m"
	  echo
	else
          echo
          truncate -s 0 ~/log/dump.txt
          echo -e "Truncating dump.txt ... \033[31mfile doesn't exist\e[0m"
          echo
	fi
        ;;


     "Exit")
        echo "BYE"
        break
        ;;
     *) echo invalid option;;
    esac
done     
