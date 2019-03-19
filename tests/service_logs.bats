#!/usr/bin/env bats
load test_helper

setup() {
  dokku "$PLUGIN_COMMAND_PREFIX:create" l
}

teardown() {
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" l
}

@test "($PLUGIN_COMMAND_PREFIX:logs) error when there are no arguments" {
  run dokku "$PLUGIN_COMMAND_PREFIX:logs"
  assert_contains "${lines[*]}" "Please specify a valid name for the service"
}

@test "($PLUGIN_COMMAND_PREFIX:logs) error when service does not exist" {
  run dokku "$PLUGIN_COMMAND_PREFIX:logs" not_existing_service
  assert_contains "${lines[*]}" "service not_existing_service does not exist"
}

@test "($PLUGIN_COMMAND_PREFIX:logs) success when not tailing" {
  run dokku --trace "$PLUGIN_COMMAND_PREFIX:logs" l
  echo "output: $output"
  echo "status: $status"
  echo "docker logs --tail 100 'dokku.memcached.l': $(docker logs --tail 100 "dokku.memcached.l")"
  assert_success
}

# @test "($PLUGIN_COMMAND_PREFIX:logs) success when tailing" {
#   run dokku "$PLUGIN_COMMAND_PREFIX:logs" l -t
#   assert_contains "docker logs --follow testid"
# }
