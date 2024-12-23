#!/usr/bin/env bash

set -e

# Set BIN_ROOT, the location of the `bin` directory
readonly BIN_ROOT=$(cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P)

# Set APP_ROOT, the location of the main application directory
readonly APP_ROOT=$(cd $BIN_ROOT/../ && pwd -P)

# Main functionality of the script
main() {
  echo "Initializing application..."

  (
    # Make sure script is running from the main application directory
    cd $APP_ROOT

    # Build docker images
    echo "Building docker images..."
    docker compose build

    # Install dependencies
    echo "Installing dependencies..."
    docker compose run --rm war-game composer install

    # Start docker containers
    echo "Starting containers..."
    docker compose up -d
  )

  echo "Application initialized successfully!"
}

# Function that outputs usage information
usage() {
  cat <<EOF

Usage: bash $BIN_ROOT/$(basename $0) <options>

Script used to initialize this application

Options:
  -h, --help              Print this message and quit
EOF
}

# Parse input options
while getopts ":h-:" opt; do
  case "$opt" in
    h) usage && exit 0;;
    -)
      case "${OPTARG}" in
        help) usage && exit 0;;
        *) echo "Invalid option: --$OPTARG." && usage && exit 1;;
      esac
    ;;
    \?) echo "Invalid option: -$OPTARG." && usage && exit 1;;
    :) echo >&2 "Option -$OPTARG requires an argument." && exit 1;;
  esac
done

# Execute main functionality
main
