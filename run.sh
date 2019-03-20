#!/usr/bin/env bash

[[ -z ${org_mngr_user} ]] && read -p "Org manager user: " org_mngr_user
[[ -z ${org_mngr_pass} ]] && read -s -t 60 -p "Org manager password: " org_mngr_pass
echo "\n "
[[ -z ${team_op_user} ]] && read -p "Team operator user: " team_op_user
[[ -z ${team_op_pass} ]] && read -s -t 60 -p "Team operator password: " team_op_pass
echo "\n "


if [[ -z ${org_mngr_user} || -z ${org_mngr_pass} || -z ${team_op_user} || -z ${team_op_pass} ]]; then
  echo "Missing username password input"
  exit 0
fi
echo "${org_mngr_user} ${org_mngr_pass} ${team_op_user} ${team_op_pass}"
