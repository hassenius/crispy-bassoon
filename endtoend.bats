
load ${APP_ROOT}/libs/sequential-helpers.bash
load ${APP_ROOT}/libs/kube-helpers.bash

function create_environment() {
  # Create portfolio expects environment variables to be available
  python ${APP_ROOT}/libs/setup.py
  ret_val=$?

  # If we succeeded in creating the portfolio, we can setup kubectl
  if [[ $ret_val -eq 0 ]]; then
    auth_and_create_context ${org_mngr_user} ${org_mngr_pass} orgmanager
    auth_and_create_context ${team_op_user} ${team_op_pass} teamoperator
  fi

  return $ret_val
}


function destroy_environment() {
  # Delete portfolio expects the environment variables
  python ${APP_ROOT}/libs/kill-the-thing.py
  return 0
}

@test "mocktest" {
  kube="kubectl --kubeconfig=${BATS_TMPDIR}/kubeconfig --context=orgmanager"
  $kube get pods

  kubectl get pods

  [[ 1 -eq 1 ]]
}
