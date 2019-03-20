#!/usr/bin/env bash

# Get the working directory
APP_ROOT="$(dirname "$($(type -p greadlink readlink | head -1) -f  "$BASH_SOURCE")")"


# Ensure we have the prereq settings
[[ -z ${org_mngr_user} ]] && read -p -t 60 "Org manager user: " org_mngr_user
[[ -z ${org_mngr_pass} ]] && read -s -t 60 -p "Org manager password: " org_mngr_pass
echo "\n "
[[ -z ${team_op_user} ]] && read -p -t 60 "Team operator user: " team_op_user
[[ -z ${team_op_pass} ]] && read -s -t 60 -p "Team operator password: " team_op_pass
echo "\n "
[[ -z ${portfolio_name} ]] && read -t 60 -p "Portfolio_name: " portfolio_name

if [[ -z ${org_mngr_user} || -z ${org_mngr_pass} || -z ${team_op_user} || -z ${team_op_pass} | ${portfolio_name} ]]; then
  echo "Missing username password input"
  exit 0
fi
echo "${org_mngr_user} ${org_mngr_pass} ${team_op_user} ${team_op_pass} ${portfolio_name}"

export org_mngr_user
export org_mngr_pass
export portfolio_name


bats endtoend.bats
