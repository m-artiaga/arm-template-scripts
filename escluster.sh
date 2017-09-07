#!/bin/bash

# script parameters
readonly ARGS="$@"

function main()
{
    # execute vm command
    vms $1 $2

    # excecute disk command
    disks $1 $2

    # execute availability-set command
    availabilitySet $1 $2

    # execute nic command
    nics $1 $2

    # execute load balancer command
    load_balancer $1 $2
    
    # execute ip command
    public_ips $1 $2

    # execute nic command
    security_groups $1 $2

}

function vms()
{
    local CLUSTER_NAME=$1
    local ACTION=$2
    
    echo "### executing vm ${ACTION} command in cluster ${CLUSTER_NAME}"
    declare -a VMS=`az vm list --resource-group eastus2-pstelasticsearch-sandbox-rg -o json --query "[].name" | grep ${CLUSTER_NAME} | awk '{ gsub(/[,"]/,"",$1); print $1 }'`
    for VM in ${VMS}
    do
        case ${ACTION} in
            show)
                echo "found vm ${VM}"
                ;;
            stop)
                echo "stopping vm ${VM}"
                az vm stop --name ${VM} -g eastus2-pstelasticsearch-sandbox-rg
                ;;
            start)
                echo "starting vm ${VM}"
                az vm start --name ${VM} -g eastus2-pstelasticsearch-sandbox-rg
                ;;
            delete)
                echo "deleting vm ${VM}"
                az vm delete --name ${VM} -g eastus2-pstelasticsearch-sandbox-rg --yes
                ;;                
        esac
    done
}

function disks()
{
    local CLUSTER_NAME=$1
    local ACTION=$2
    
    echo "### executing disk ${ACTION} command in cluster ${CLUSTER_NAME}"
    declare -a DISKS=`az disk list --resource-group eastus2-pstelasticsearch-sandbox-rg -o json --query "[].name" | grep ${CLUSTER_NAME} | awk '{ gsub(/[,"]/,"",$1); print $1 }'`
    for DISK in ${DISKS}
    do
        case ${ACTION} in
            show)
                echo "found disk ${DISK}"
                ;;
            delete)
                echo "deleting disk ${DISK}"
                az disk delete --name ${DISK} -g eastus2-pstelasticsearch-sandbox-rg --yes --no-wait
                ;;
        esac
    done
}

function availabilitySet()
{
    local CLUSTER_NAME=$1
    local ACTION=$2
    
    echo "### executing availability-set ${ACTION} command in cluster ${CLUSTER_NAME}"
    declare -a A_SETS=`az vm availability-set list --resource-group eastus2-pstelasticsearch-sandbox-rg -o json --query "[].name" | grep ${CLUSTER_NAME} | awk '{ gsub(/[,"]/,"",$1); print $1 }'`
    for A_SET in ${A_SETS}
    do
        case ${ACTION} in
            show)
                echo "found availability-set ${A_SET}"
                ;;
            delete)
                echo "deleting availability-set ${A_SET}"
                az vm availability-set delete --name ${A_SET} -g eastus2-pstelasticsearch-sandbox-rg --no-wait
                ;;
        esac
    done
}

function nics()
{
    local CLUSTER_NAME=$1
    local ACTION=$2
    
    echo "### executing nic ${ACTION} command in cluster ${CLUSTER_NAME}"
    declare -a NICS=`az network nic list --resource-group eastus2-pstelasticsearch-sandbox-rg -o json --query "[].name" | grep ${CLUSTER_NAME} | awk '{ gsub(/[,"]/,"",$1); print $1 }'`
    for NIC in ${NICS}
    do
        case ${ACTION} in
            show)
                echo "found nic ${NIC}"
                ;;
            delete)
                echo "deleting nic ${NIC}"
                az network nic delete --name ${NIC} -g eastus2-pstelasticsearch-sandbox-rg
                ;;
        esac
    done
}

function security_groups()
{
    local CLUSTER_NAME=$1
    local ACTION=$2
    
    echo "### executing nsg ${ACTION} command in cluster ${CLUSTER_NAME}"
    declare -a NSGS=`az network nsg list --resource-group eastus2-pstelasticsearch-sandbox-rg -o json --query "[].name" | grep ${CLUSTER_NAME} | awk '{ gsub(/[,"]/,"",$1); print $1 }'`
    for NSG in ${NSGS}
    do
        case ${ACTION} in
            show)
                echo "found nsg ${NSG}"
                ;;
            delete)
                echo "deleting nsg ${NSG}"
                az network nsg delete --name ${NSG} -g eastus2-pstelasticsearch-sandbox-rg --no-wait
                ;;
        esac
    done
}

function public_ips()
{
    local CLUSTER_NAME=$1
    local ACTION=$2
    
    echo "### executing public ip ${ACTION} command in cluster ${CLUSTER_NAME}"
    declare -a IPS=`az network public-ip list --resource-group eastus2-pstelasticsearch-sandbox-rg -o json --query "[].name" | grep ${CLUSTER_NAME} | awk '{ gsub(/[,"]/,"",$1); print $1 }'`
    for IP in ${IPS}
    do
        case ${ACTION} in
            show)
                echo "found public ip ${IP}"
                ;;
            delete)
                echo "deleting public ip ${IP}"
                az network public-ip delete --name ${IP} -g eastus2-pstelasticsearch-sandbox-rg
                ;;
        esac
    done
}

function load_balancer()
{
    local CLUSTER_NAME=$1
    local ACTION=$2
    
    echo "### executing load balancer ${ACTION} command in cluster ${CLUSTER_NAME}"
    declare -a LBS=`az network lb list --resource-group eastus2-pstelasticsearch-sandbox-rg -o json --query "[].name" | grep ${CLUSTER_NAME} | awk '{ gsub(/[,"]/,"",$1); print $1 }'`
    for LB in ${LBS}
    do
        case ${ACTION} in
            show)
                echo "found load balancer ${LB}"
                ;;
            delete)
                echo "deleting load balancer ${LB}"
                az network lb delete --name ${LB} -g eastus2-pstelasticsearch-sandbox-rg
                ;;
        esac
    done
}


# Calling main function
main $ARGS