#!/bin/bash

# Function to get memory usage of the application containers
get_memory_usage() {
    # Sum memory usage of all application containers
    total_memory=0
    for container in $(docker ps --filter "name=newuser-app" --format "{{.Names}}"); do
        memory_usage=$(docker stats --no-stream --format "{{.MemUsage}}" "$container" | awk '{print $1}')

        case $memory_usage in
            *GiB) memory_usage=$(echo "${memory_usage%GiB} * 1024" | bc) ;;
            *MiB) memory_usage="${memory_usage%MiB}" ;;
            *KiB) memory_usage=$(echo "${memory_usage%KiB} / 1024" | bc) ;;
            *) memory_usage=0 ;;
        esac

        total_memory=$(echo "$total_memory + $memory_usage" | bc)
    done

    echo "$total_memory"
}

scale_app() {
    echo "Scaling application..."
    prev=0
    curr=1
    replicas=0
    min_replicas=4
    max_replicas=8

    while true; do
        memory_usage=$(get_memory_usage)

        echo "Current Total Memory Usage: ${memory_usage}MB"

        if (( $(echo "$memory_usage >= 128" | bc -l) )); then
            # Calculate the next Fibonacci number
            echo "Memory usage has reached 128 MB, scaling up..."

            # Check the current number of replicas
            current_replicas=$(docker ps --filter "name=newuser-app-1" --format "{{.Names}}" | wc -l)

            # Scale up only if current replicas are less than max_replicas
            if (( current_replicas < max_replicas )); then
                new_replicas=$((prev + curr))
                if (( new_replicas > max_replicas )); then
                    new_replicas=$max_replicas
                fi
                echo "Scaling to $new_replicas replicas."
                docker-compose up --scale app="$new_replicas" -d

                # Update Fibonacci numbers
                temp=$curr
                curr=$((prev + curr))
                prev=$temp
            else
                echo "Maximum replicas reached. No scaling up."
            fi
        else
            echo "Memory usage is below 128 MB. No scaling action taken."
        fi

        # Ensure minimum replicas
        if (( current_replicas < min_replicas )); then
            echo "Scaling up to minimum replicas: $min_replicas"
            docker-compose up --scale app="$min_replicas" -d
        fi

        sleep 10
    done
}

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <max_replicas> <monitoring_time_in_seconds>"
    exit 1
fi

max_replicas=$1
monitor_time=$2

scale_app "$max_replicas"
