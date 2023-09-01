#!/usr/bin/env bash

if [ ! -z "${_INCLUDE_TERM}" ]; then
    return 0
fi

# begin inclusions
_SELF_GIT_ROOT="$(git rev-parse --show-toplevel)"

function .is-tty() {
    local kind
    kind="${1:-stderr}"

    local term_fd
    term_fd="2"

    case "$kind" in
        0|stdin)
            term_fd=0
            ;;
        1|stdout)
            term_fd=1
            ;;
        2|stderr)
            term_fd=2
            ;;
    esac

    if [ -t "${term_fd}" ]; then
        return 0
    else
        return 1
    fi
}

# Black       0;30     Dark Gray     1;30
# Blue        0;34     Light Blue    1;34
# Green       0;32     Light Green   1;32
# Cyan        0;36     Light Cyan    1;36
# Red         0;31     Light Red     1;31
# Purple      0;35     Light Purple  1;35
# Brown       0;33     Yellow        1;33
# Light Gray  0;37     White         1;37

function .lsc() {
  (
    set -e

    function .usage() {
      echo "usage: .lsc [-h|--help]" >&2
      echo "Lists available colors." >&2
      return 1
    }

    while [[ $# -gt 0 ]]; do
      arg="$1"
      case $arg in
        -h|--help|*)
          .usage
          return 1
          ;;
      esac
    done

    for color in black blue green cyan red purple yellow white ; do
      echo $color
    done
  )
}

function .fgc() {
  (
    set -e

    function .usage() {
      echo "usage: .fgc [-h|--help] [-b|--bold|--bright] {black|blue|green|cyan|red|purple|yellow|white}" >&2
      echo "Sets foreground text color and weight." >&2
      return 1
    }

    if ! .is-tty ; then
        return 0
    fi

    local bold="0"

    while [[ $# -gt 0 ]]; do
      arg="$1"
      case $arg in
        -h|--help)
          .usage
          return 1
          ;;
        -b|--bold|--bright)
          bold="1"
          shift
          ;;
        black|blue|green|cyan|red|purple|yellow|white)
          color="$1"
          shift
          ;;
        *)
          echo "ERROR: unknown argument $1" >&2
          .usage
          shift
          ;;
      esac
    done

    test -z "$color" && .usage

    case $color in
      black)
        echo -ne "\033[${bold};30m"
        ;;
      blue)
        echo -ne "\033[${bold};34m"
        ;;
      green)
        echo -ne "\033[${bold};32m"
        ;;
      cyan)
        echo -ne "\033[${bold};36m"
        ;;
      red)
        echo -ne "\033[${bold};31m"
        ;;
      purple)
        echo -ne "\033[${bold};35m"
        ;;
      yellow)
        echo -ne "\033[${bold};33m"
        ;;
      white)
        echo -ne "\033[${bold};37m"
        ;;
    esac
  )
}

function .fgr() {
  (
    set -e

    function .usage() {
      echo "usage: .fgr [-h|--help]" >&2
      echo "Resets the foreground text color." >&2
      return 1
    }

    if ! .is-tty ; then
        return 0
    fi

    while [[ $# -gt 0 ]]; do
      arg="$0"
      case $arg in
        -h|--help|*)
          .usage
          return 1
          ;;
      esac
    done

    echo -ne "\033[0m"
  )
}

alias .bgr=".fgr"

function .bgc() {
  (
    set -e

    function .usage() {
      echo "usage: .bgc [-h|--help] [-b|--bold|--bright] {black|blue|green|cyan|red|purple|yellow|white}" >&2
      echo "Sets background color and weight." >&2
      return 1
    }

    if ! .is-tty ; then
        return 0
    fi

    local bold="0"

    while [[ $# -gt 0 ]]; do
      arg="$1"
      case $arg in
        -h|--help)
          .usage
          return 1
          ;;
        -b|--bold|--bright)
          bold="1"
          shift
          ;;
        black|blue|green|cyan|red|purple|yellow|white)
          color="$1"
          shift
          ;;
        *)
          echo "ERROR: unknown argument $1" >&2
          .usage
          return 1
          ;;
      esac
    done

    test -z "$color" && .usage

    case $color in
      black)
        echo -ne "\033[0;$(test $bold -eq 0 && echo 40 || echo 100)m"
        ;;
      red)
        echo -ne "\033[0;$(test $bold -eq 0 && echo 41 || echo 101)m"
        ;;
      green)
        echo -ne "\033[0;$(test $bold -eq 0 && echo 42 || echo 102)m"
        ;;
      yellow)
        echo -ne "\033[0;$(test $bold -eq 0 && echo 43 || echo 103)m"
        ;;
      blue)
        echo -ne "\033[0;$(test $bold -eq 0 && echo 44 || echo 104)m"
        ;;
      purple)
        echo -ne "\033[0;$(test $bold -eq 0 && echo 45 || echo 105)m"
        ;;
      cyan)
        echo -ne "\033[0;$(test $bold -eq 0 && echo 46 || echo 106)m"
        ;;
      white)
        echo -ne "\033[0;$(test $bold -eq 0 && echo 47 || echo 107)m"
        ;;
    esac
  )
}

function .color-test() {
  alias .bgr=".fgr"

  for color in $(.lsc) ; do
    .fgc $color
    echo "[$(printf '%6s' $color)] Normal$(.fgr)"
    .fgc -b $color
    echo "[$(printf '%6s' $color)] Bright$(.fgr)"
    .fgr
    .bgc $color
    echo "[$(printf '%6s' $color)] Normal$(.fgr)"
    .bgc -b $color
    echo "[$(printf '%6s' $color)] Bright$(.fgr)"
    .fgr
  done
}

# end of inclusions
_INCLUDE_TERM=true