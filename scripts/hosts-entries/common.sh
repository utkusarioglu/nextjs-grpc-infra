source .repo.config

HOSTS_FILE=/etc/hosts
HOSTS_FILE_BACKUP=/etc/hosts-backup
HOSTS_FILE_TEMP=/etc/hosts-temp
# HOSTS_GATEWAY_PHRASE="host-gateway"


HOSTS="
local.dev.k3d.nextjs-grpc.projects.utkusarioglu.com
nextjs-grpc.utkusarioglu.com
grafana.nextjs-grpc.utkusarioglu.com
jaeger.nextjs-grpc.utkusarioglu.com
prometheus.nextjs-grpc.utkusarioglu.com
vault.nextjs-grpc.utkusarioglu.com
kubernetes-dashboard.nextjs-grpc.utkusarioglu.com
registry.nextjs-grpc.utkusarioglu.com
"

function get_host_ip {
  host_ip=$(cat $HOSTS_FILE | grep $HOSTS_GATEWAY_PHRASE | awk '{print $1}')
  exit_code=$?
  if [ "$exit_code" != "0" ]; then
    exit $exit_code
  fi
  if [ -z "$host_ip" ]; then
    exit 1
  fi
  echo $host_ip
}

function remove_hosts_entries {
  cp $HOSTS_FILE $HOSTS_FILE_BACKUP
  sed "/$HOSTS_ENTRIES_START_PHRASE/,/$HOSTS_ENTRIES_END_PHRASE/d" $HOSTS_FILE > $HOSTS_FILE_TEMP
  cp $HOSTS_FILE_TEMP $HOSTS_FILE
}

function write_hosts_entries {
  host_ip=$1
  if [ -z "$host_ip" ]; then
    exit 1
  fi
  echo $HOSTS_ENTRIES_START_PHRASE >> $HOSTS_FILE
  for host in $HOSTS; do
    echo "$host_ip $host" >> $HOSTS_FILE
  done
  echo $HOSTS_ENTRIES_END_PHRASE >> $HOSTS_FILE
}

function display_hosts_file {
  echo "Hosts file:"
  cat $HOSTS_FILE
}
