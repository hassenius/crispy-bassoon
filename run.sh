#!/usr/bin/env bash

[[ -z ${team_admin_user} ]] && read -p "Team admin user: " team_admin_user
[[ -z ${team_admin_pass} ]] && read -s -t 60 -p "Team admin passwor: " team_admin_pass
echo "\n "
[[ -z ${team_op_user} ]] && read -p "Team operator user: " team_op_user
[[ -z ${team_op_pass} ]] && read -s -t 60 -p "Team operator password: " team_op_pass
echo "\n "


if [[ -z ${team_admin_user} || -z ${team_admin_pass} || -z ${team_op_user} || -z ${team_op_pass} ]]; then
  echo "Missing username password input"
  exit 0
fi
echo "${team_admin_user} ${team_admin_pass} ${team_op_user} ${team_op_pass}"
