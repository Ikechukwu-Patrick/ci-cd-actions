#!/bin/bash
set -e

SERVICE_NAME="app"
MEMORY_LIMIT_MB=128
SCALE_UP_THRESHOLD=128
SCALE_DOWN_THRESHOLD=100
MAX_REPLICAS=5
MIN_REPLICAS=1

export COMPOSE_HTTP_TIMEOUT=300

cd "$(dirname "$0")" || exit 1

scaling_in_progress=false

get_memory_usage() {
  CONTAINER_ID=$(docker-compose ps -q $SERVICE_NAME)

  if [[ -z "$CONTAINER_ID" ]]; then
    echo "[$(date)] Warning: No active container found for $SERVICE_NAME. Setting memory usage to 0."
    echo 0
    return
  fi

  memory=$(docker stats --no-stream --format "{{.MemUsage}}" "$CONTAINER_ID" 2>/dev/null | awk -F '[ /]+' '{gsub(/[a-zA-Z]/, "", $1); print $1}' | tr -d '\n')
  if [[ -z "$memory" ]]; then
    echo "[$(date)] Error retrieving memory usage for container $CONTAINER_ID. Skipping this check."
    echo 0
  else
    echo "$memory"
  fi
}

get_current_scale() {
  docker-compose ps -q $SERVICE_NAME | wc -l
}

container_exists() {
  docker ps -a --format "{{.ID}}" | grep -q "$1"
}

scale_service() {
  current_scale=$(get_current_scale)
  new_scale=$((current_scale + 1))

  if [ "$current_scale" -lt "$MAX_REPLICAS" ]; then
    echo "[$(date)] Scaling service $SERVICE_NAME to $new_scale replicas"
    if docker-compose up --scale "$SERVICE_NAME=$new_scale" -d; then
      scaling_in_progress=true
    else
      echo "[$(date)] Failed to scale service $SERVICE_NAME to $new_scale replicas"
    fi
  else
    echo "[$(date)] Max replicas reached ($MAX_REPLICAS). Cannot scale further."
  fi
}

scale_down_service() {
  current_scale=$(get_current_scale)
  new_scale=$((current_scale - 1))

  if [ "$current_scale" -gt "$MIN_REPLICAS" ]; then
    echo "[$(date)] Scaling service $SERVICE_NAME down to $new_scale replicas"
    if docker-compose up --scale "$SERVICE_NAME=$new_scale" -d; then
      container_id=$(docker-compose ps -q $SERVICE_NAME | tail -n 1)

      if container_exists "$container_id"; then
        docker rm -f "$container_id" || echo "[$(date)] Failed to remove container $container_id. It may have been removed already."
      else
        echo "[$(date)] Container $container_id does not exist, skipping removal."
      fi
    else
      echo "[$(date)] Failed to scale service $SERVICE_NAME down to $new_scale replicas"
    fi
  else
    echo "[$(date)] Only one replica running. Cannot scale down further."
  fi
}

send_requests() {
  URL="http://localhost:8080/fibonacci/90000"
  COUNT=90000

  echo "[$(date)] Sending $COUNT concurrent requests to $URL..."

  for i in $(seq 1 $COUNT); do
    curl -s "$URL" &
  done

  wait
  echo "[$(date)] All requests sent."
}

trap "echo 'Stopping script...'; exit" SIGINT SIGTERM

while true; do
  memory_usage=$(get_memory_usage | sed 's/[^0-9.]//g' | awk '{print int($1)}')

  if [[ ! "$memory_usage" =~ ^[0-9]+$ ]]; then
    echo "[$(date)] Invalid memory usage: $memory_usage. Skipping this check."
    continue
  fi

  current_scale=$(get_current_scale)

  echo "[$(date)] Current memory usage: $memory_usage MB. Current replicas: $current_scale"

  if [ "$memory_usage" -ge "$MEMORY_LIMIT_MB" ] && [ "$scaling_in_progress" = false ]; then
    echo "[$(date)] Memory limit ($MEMORY_LIMIT_MB MB) reached. Scaling service..."
    scale_service

  elif [ "$memory_usage" -lt "$SCALE_DOWN_THRESHOLD" ] && [ "$current_scale" -gt "$MIN_REPLICAS" ]; then
    echo "[$(date)] Memory usage ($memory_usage MB) is below threshold for scaling down. Scaling down service..."
    scale_down_service

  else
    echo "[$(date)] Memory usage is under control ($memory_usage MB)."
  fi

  if [ "$scaling_in_progress" = true ]; then
    echo "[$(date)] Waiting for the service to stabilize after scaling..."
    sleep 60
    scaling_in_progress=false
  else
    sleep 30
  fi
done
