#!/bin/bash
set -x

# File where data is stored.
DATA_FILE="/home/sheetal/.ssh/config"

# Check if the provided options are correct.
while getopts ":an:h:u:p:i:ldr:UcP:" opt; do
	case $opt in
		a) action="add";;
		r) action="rm";;  # Changed to lowercase for consistency
	        U) action="update";;
	        c) action="connect";;
		n) server_name="$OPTARG";;
		h) host_ip="$OPTARG";;
		u) username="$OPTARG";;
		p) port="$OPTARG";;
		i) IdentityFile="$OPTARG";;
		P) new_port="$OPTARG";;
		l) list=true ;;
		d) list_all=true ;;
	
		:) echo "Option -$OPTARG requires an argument"; exit 1;;
	esac
done

# Function to add SSH connection.
add() {
	grep -q "^$server_name " "$DATA_FILE"
	if [ $? -eq 0 ]; then
		echo "Connection exists"
	else
		echo "$server_name $username $host_ip $port $IdentityFile" >> "$DATA_FILE"
		echo "Added: $server_name $username $host_ip $port $IdentityFile to $DATA_FILE"
	fi
}

# Function to list connections.

list_connections() {
    if [ -s "$DATA_FILE" ]; then
        echo "Server Names:"
        awk '{print $1}' "$DATA_FILE"
    else
        echo "No data found in $DATA_FILE."
    fi
}

# Function to list connections with details.
list_detailed_connections() {
       if [ -s "$DATA_FILE" ]; then
        while read -r line; do
            server_name=$(echo "$line" | awk '{print $1}')
            username=$(echo "$line" | awk '{print $2}')
            host_ip=$(echo "$line" | awk '{print $3}')
            port=$(echo "$line" | awk '{print $4}')
            IdentityFile=$(echo "$line" | awk '{print $5}')

            echo "$server_name: $IdentityFile $port $username@$host_ip"
         
        done < "$DATA_FILE"

       else 
        echo "No data found in $DATA_FILE."
    fi
}

# To update a connection.

update_connection() {

        	if [ -n "$server_name" ]; then
		 sed -i "/$server_name/s/\<$port\>/$new_port/g" "$DATA_FILE"
		echo "Updated"
	else
		echo "No connection found for $server_name."

	
	fi

	        if [ "$username" != " " ]; then
	         existing_username= 'cat $DATA_FILE | grep "$server_name"' | awk '{print $NF}'

		 sed -i -e 's/'$existing_username'/'$username'/g' ./connection
	else
		exit
	fi
        
	        if [ "$host_ip" != " " ]; then
		  existing_host_ip='cat $DATA_FILE' | awk '{print $NF}' | awk -F'@' '{print $2}'
		  sed -i -e 's/'$existing_host_ip'/'$host_ip'/g' ./DATA_FILE
		  sed '/'$server_name'/d' 

	else
		exit
	fi
}


# Function to delete a connection.
rm_connection() {
	grep -q "^$server_name " "$DATA_FILE"
	if [ $? -eq 0 ]; then
		sed -i "/^$server_name /d" "$DATA_FILE"
		echo "$server_name removed"
	else
		echo "No connection found for $server_name"
	fi
}

# To connect to server.
connect_to_server() {
                     
	ssh $server_name
}

# Call the appropriate function based on the action
if [ "$action" == "add" ]; then
	add
elif [ "$action" == "rm" ]; then
	rm_connection
elif [ "$list" == "true" ]; then
	list_connections
elif [ "$list_all" == "true" ]; then
	list_detailed_connections
elif [ "$action" == "update" ]; then
	update_connection
elif [ "$action" == "connect" ]; then
	connect_to_server
else
	echo "No valid action specified. Use -a to add or -r to remove."
fi

