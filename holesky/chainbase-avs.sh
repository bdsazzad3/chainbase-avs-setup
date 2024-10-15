#!/bin/sh
# path: chainbase-avs.sh

. ./.env

register_chainbase_avs() {
  echo "Registering Chainbase AVS, ECDSA key path: $NODE_ECDSA_KEY_FILE_PATH ,BLS key path: $NODE_BLS_KEY_FILE_PATH"
  docker run --env-file .env \
    --rm \
    --volume "${NODE_ECDSA_KEY_FILE_PATH}":"/app/node.ecdsa.key.json" \
    --volume "${NODE_BLS_KEY_FILE_PATH}":"/app/node.bls.key.json" \
    --volume "./node.yaml":"/app/node.yaml" \
    "repository.chainbase.com/network/chainbase-cli:v0.2.0-test-21" \
    --config /app/node.yaml "register-operator-with-avs"
}

deregister_chainbase_avs() {
  echo "Deregistering Chainbase AVS, ECDSA key path: $NODE_ECDSA_KEY_FILE_PATH ,BLS key path: $NODE_BLS_KEY_FILE_PATH"
  docker run --env-file .env \
    --rm \
    --volume "${NODE_ECDSA_KEY_FILE_PATH}":"/app/node.ecdsa.key.json" \
    --volume "${NODE_BLS_KEY_FILE_PATH}":"/app/node.bls.key.json" \
    --volume "./node.yaml":"/app/node.yaml" \
    "repository.chainbase.com/network/chainbase-cli:v0.2.0-test-21" \
    --config /app/node.yaml "deregister-operator-with-avs"
}

run_manuscript_node() {
  echo "Running Chainbase AVS"
  docker compose up -d
}

runall_manuscript_node() {
  echo "Running Chainbase AVS"
  docker compose --profile grafana up -d
}

stop_manuscript_node() {
  echo "Stopped Chainbase AVS"
  docker compose down
}

test_manuscript_node() {
  echo "Testing manuscript node"
  docker run --env-file .env \
    --rm \
    --volume "${NODE_ECDSA_KEY_FILE_PATH}":"/app/node.ecdsa.key.json" \
    --volume "${NODE_BLS_KEY_FILE_PATH}":"/app/node.bls.key.json" \
    --volume "./node.yaml":"/app/node.yaml" \
    --volume "/var/run/docker.sock:/var/run/docker.sock"\
    --network "holesky_avs_network" \
    "repository.chainbase.com/network/chainbase-cli:v0.2.0-test-21" \
    --config /app/node.yaml "test-manuscript-node-task"
}

update_node_socket() {
  echo "Updating manuscript node socket"
  docker run --env-file .env \
    --rm \
    --volume "${NODE_ECDSA_KEY_FILE_PATH}":"/app/node.ecdsa.key.json" \
    --volume "${NODE_BLS_KEY_FILE_PATH}":"/app/node.bls.key.json" \
    --volume "./node.yaml":"/app/node.yaml" \
    "repository.chainbase.com/network/chainbase-cli:v0.2.0-test-21" \
    --config /app/node.yaml "update-operator-socket"
}

print_help() {
  echo "Usage: $0 {register|run|stop|help}"
  echo "Commands:"
  echo "  register      Register the Chainbase AVS"
  echo "  deregister    Deregister the Chainbase AVS"
  echo "  run           Run Chainbase AVS manuscript node"
  echo "  runall        Run Chainbase AVS manuscript node include grafana"
  echo "  stop          Stop Chainbase AVS manuscript node"
  echo "  test          Run test task on Chainbase AVS manuscript node"
  echo "  update        Update manuscript node socket on chain"
  echo "  help          Display this help message"
}

case "$1" in
  register)
    register_chainbase_avs
    ;;
  deregister)
    deregister_chainbase_avs
    ;;
  run)
    run_manuscript_node
    ;;
  run)
    runall_manuscript_node
    ;;
  stop)
    stop_manuscript_node
    ;;
  test)
    test_manuscript_node
    ;;
  update)
    update_node_socket
    ;;
  help)
    print_help
    ;;
  *)
    echo "Invalid command"
    print_help
    ;;
esac
