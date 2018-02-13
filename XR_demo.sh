ansible_env_path=~/environment/ansible
#router_IP="192.168.10.4"

PS3='Please enter your choice: '
echo
options=("Retrieve current XR telemetry configurtion" "Remove XR telemetry configuration" "Configure example Sensor-Group" "Configure example Destination-Group" "Configure example Subscription" "Apply MDT template for Dial-out, TCP and GPBkv" "Apply MDT template for Dial-out, gRPC without TLS and GPBkv" "Apply MDT template for Dial-in, gRPC without TLS and GPBkv" "Add and remove Dial-In from Pipeline"  "Exit")
select opt in "${options[@]}"
do
    case $opt in
     "Verify Timing")
         echo
         echo -e "\e[1m!!! Checking timing syncronization !!!\e[0m"
         echo
         ansible-playbook $ansible_env_path/timing.yml -i $ansible_env_path/ansible_hosts 
	 #break
         ;;

     "Retrieve current XR telemetry configurtion")
         echo
         ansible-playbook $ansible_env_path/router_command.yml -i $ansible_env_path/ansible_hosts --extra-var 'command="show running-config telemetry model-driven"' 
         echo
         ;;


     "Remove XR telemetry configuration")
         echo
         echo -e "\e[1m!!! Removing all MDT configurations !!!\e[0m"
         echo
#         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         ansible-playbook $ansible_env_path/router_template.yml -i $ansible_env_path/ansible_hosts --extra-var "template=XR_conf/clean_telemetry.cfg match=line" 
         echo
         ;; 

     "Configure example Sensor-Group")
	 echo
         echo -e "\e[1m!!! Configuring example of Sensor-Group !!!\e[0m"
         echo
#         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
 	 ansible-playbook $ansible_env_path/router_template.yml -i $ansible_env_path/ansible_hosts --extra-var "template=XR_conf/sensor-group.cfg match=line" 
	 echo
         ;; 

     "Configure example Destination-Group")
         echo
         echo -e "\e[1m!!! Configuring example of destination-group !!!\e[0m"
         echo
#         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         ansible-playbook $ansible_env_path/router_template.yml -i $ansible_env_path/ansible_hosts --extra-var "template=XR_conf/destination-group.cfg match=line"
         echo
         #break
         ;;

     "Configure example Subscription")
         echo
         echo -e "\e[1m!!! Configuring exmaple of subscription !!!\e[0m"
         echo
#         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         ansible-playbook $ansible_env_path/router_template.yml -i $ansible_env_path/ansible_hosts --extra-var "template=XR_conf/subscription.cfg match=line" 
         echo
         #break
         ;;

     "Apply MDT template for Dial-out, TCP and GPBkv")
         echo
         echo -e "\e[1m!!! Configuring MDT template for Dial-out, TCP and GPBkv !!!\e[0m"
         echo -e "\e[1m!!! Remove other MDT configurations  !!!\e[0m"
         echo
	 # read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         ansible-playbook $ansible_env_path/router_template.yml -i $ansible_env_path/ansible_hosts --extra-var "template=XR_conf/MDT_TCP_GPBkv.cfg match=none"
         echo
         ;;

     "Apply MDT template for Dial-out, gRPC without TLS and GPBkv")
         echo
         echo -e "\e[1m!!! Configuring MDT template for Dial-out, gRPC without TLS and GPBkv !!!\e[0m"
         echo -e "\e[1m!!! Remove other MDT configurations  !!!\e[0m"
         echo
         # read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         ansible-playbook $ansible_env_path/router_template.yml -i $ansible_env_path/ansible_hosts --extra-var "template=XR_conf/MDT_GRPC_BPBkv_OUT.cfg match=none"
         echo
         ;;

     "Apply MDT template for Dial-in, gRPC without TLS and GPBkv")
         echo
         echo -e "\e[1m!!! Configuring MDT template for Dial-in, gRPC without TLS and GPBkv !!!\e[0m"
         echo -e "\e[1m!!! Remove other MDT configurations  !!!\e[0m"
         echo
         # read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         ansible-playbook $ansible_env_path/router_template.yml -i $ansible_env_path/ansible_hosts --extra-var "template=XR_conf/MDT_GRPC_BPBkv_IN.cfg  match=none"
         echo
         ;;

     "Add and remove Dial-In from Pipeline")
         if grep -q "gRPCDialin" environment/pipeline.conf; then
         echo
         echo -e "\e[1m!!! Ready to REMOVE Dial-out from pipeline end RE-START the service !!!\e[0m"
         echo
         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         echo
         ansible-playbook $ansible_env_path/stop_dialIN.yml -i $ansible_env_path/ansible_hosts  --ask-vault-pass
       else
         echo
         echo -e "\e[1m!!! Ready to ADD Dial-out to Pipeline for Dial-in end RE-START the service !!!\e[0m"
         echo
         read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
         echo
         ansible-playbook $ansible_env_path/start_dialIN.yml -i $ansible_env_path/ansible_hosts  --ask-vault-pass
       fi
        ;;

     "Exit")
        echo "BYE"
        break
        ;;
     *) echo invalid option;;
    esac
done     
