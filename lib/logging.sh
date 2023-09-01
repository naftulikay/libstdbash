#!/usr/bin/env bash

if [ ! -z "${_INCLUDE_LOGGING:-}" ]; then
    return 0
fi

_SELF_GIT_ROOT="$(git rev-parse --show-toplevel)"

# import
source "${_SELF_GIT_ROOT}/lib/term.sh"

function .log() {
    local level
    level="${1:-DEBUG}" && shift

    local level_format
    level_format=""

    case "$level" in
        "TRACE")
        level_format="$(.fgc -b white)"
        ;;
        "DEBUG")
        level_format="$(.fgc -b green)"
        ;;
        "INFO")
        level_format="$(.fgc -b cyan)"
        ;;
        "WARN")
        level_format="$(.fgc -b yellow)"
        ;;
        "ERROR")
        level_format="$(.fgc -b red)"
        ;;
    esac

    local message
    message="$*"

    if [ -z "$message" ]; then
        message="(no message supplied)"
    fi

    echo "$(.fgc white)$(date +%Y-%m-%dT%H:%M:%S)$(.fgr) ${level_format}[$(printf "%-5s" "$level")]$(.fgr) $message$(.fgr)" >&2
}

function .trace() { .log TRACE "$@" ; }
function .debug() { .log DEBUG "$@" ; }
function .info()  { .log INFO  "$@" ; }
function .warn()  { .log WARN  "$@" ; }
function .error() { .log ERROR "$@" ; }

function .fatal() {
    .error "$@"
    exit 1
}

_INCLUDE_LOGGING=true