#!/bin/bash

set -x

# To register a service.

register_service() {
     script_path="$1"
     service_alias="$2"
    if is_registered "$service_alias"; then
        echo "Error: Service alias '$service_alias' already exists."
        exit 1
    fi
    echo "$service_alias:$script_path" >> "$SERVICE_REGISTRY"
    echo "Service '$service_alias'has been registered successfully."
}


# Start a registered service

start_service() {
     service_alias="$1"
    if ! is_registered "$service_alias"; then
        echo "Error: Service alias '$service_alias' not found."
       exit 1
    fi
    script_path=$(awk -F: -v alias="$service_alias" '$1 == alias {print $2}' "$SERVICE_REGISTRY")
    nohup "$script_path" >/dev/null 2>&1 &  # Run in background as a daemon
    echo "Service '$service_alias' started."
}


# Check service status

service_status() {
     service_alias="$1"
    if ! is_registered "$service_alias"; then
        echo "Error: Service alias '$service_alias' not found."
        exit 1
    fi
     pid=$(pgrep -f "$(awk -F: -v alias="$service_alias" '$1 == alias {print $2}' "$SERVICE_REGISTRY")")
    if [[ -z "$pid" ]]; then
        echo "Service '$service_alias' is not running."
    else
        echo "Service '$service_alias' is running (PID: $pid)."
    fi
}


# Stop a running service

stop_service() {
    service_alias="$1"
    if ! is_registered "$service_alias"; then
        echo "Error: Service alias '$service_alias' not found."
        exit 1
    fi
    pid=$(pgrep -f "$(awk -F: -v alias="$service_alias" '$1 == alias {print $2}' "$SERVICE_REGISTRY")")
    if [[ -z "$pid" ]]; then
        echo "Service '$service_alias' is not running."
    else
        kill "$pid"
        echo "Service '$service_alias' stopped."
    fi
}


# Change the priority of a running service

change_priority() {
     service_alias="$1"
     new_priority="$2"
    if ! is_registered "$service_alias"; then
        echo "Error: Service alias '$service_alias' not found."
        exit 1
    fi
    local pid=$(pgrep -f "$(awk -F: -v alias="$service_alias" '$1 == alias {print $2}' "$SERVICE_REGISTRY")")
    if [[ -z "$pid" ]]; then
        echo "Service '$service_alias' is not running."
        exit 1
    fi
        case "$new_priority" in
            low) sudo renice 10 -p "$pid";;
            med) sudo renice 0 -p "$pid";;
            high) sudo renice -10 -p "$pid";;
            *) echo "Error: Invalid priority. Use low, med, or high.";;
        esac
        echo "Priority of service '$service_alias' changed to $new_priority."
}


# List all registered services

list_services() {
    echo "Registered services:"
    awk -F: '{print $1}' "$SERVICE_REGISTRY"
}


# Show details of processes with optional alias filtering

show_top() {
    service_alias="$1"
    if [[ -n "$service_alias" ]]; then
        if ! is_registered "$service_alias"; then
            echo "Error: Service alias '$service_alias' not found."
            exit 1
        fi
        script_path=$(awk -F: -v alias="$service_alias" '$1 == alias {print $2}' "$SERVICE_REGISTRY")
       else
        echo "Error: Please specify a service alias."
        exit 1
    fi

# Get PID, state, and priority of the service
    pid=$(pgrep -f "$script_path")
    if [[ -z "$pid" ]]; then
        echo "$service_alias, N/A, Stopped, N/A, $script_path"
        exit 0
    fi

# Get priority and state using 'ps' and 'nice'
     priority=$(ps -o nice= -p "$pid")
     state=$(ps -o stat= -p "$pid")
    
# Output the result
    echo "$service_alias, $pid, $state, $priority, $script_path"
}

# Parse options and arguments
while getopts "o:s:a:p:" opt; do
    case $opt in
        o) operation="$OPTARG" ;;
        s) script_path="$OPTARG" ;;
        a) service_alias="$OPTARG" ;;
        p) priority="$OPTARG" ;;
        *) echo "Invalid option"; exit 1 ;;
    esac
done


# Main function to execute commands based on operation
main() {
    case "$operation" in
        register) register_service "$script_path" "$service_alias" ;;
        start) start_service "$service_alias" ;;
        status) service_status "$service_alias" ;;
        kill) stop_service "$service_alias" ;;
        priority) change_priority "$service_alias" "$priority" ;;
        list) list_services ;;
        top) show_top "$service_alias" ;;
        *) echo "Invalid command"; exit 1 ;;
    esac
}
