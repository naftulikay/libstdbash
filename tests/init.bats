#!/usr/bin/env bats

@test "dummy" {
  run true
  test "$status" -eq 0
}
