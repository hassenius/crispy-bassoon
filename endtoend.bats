
load ${APP_ROOT}/libs/sequential-helpers.bash
load ${APP_ROOT}/libs/kube-helpers.bash

# Global vars
export nodeport_dir="${APP_ROOT}/nodeport"
export ingress_dir="${APP_ROOT}/ingress"

function create_environment() {
  # Create portfolio expects environment variables to be available
  python ${APP_ROOT}/libs/setup.py
  ret_val=$?

  # If we succeeded in creating the portfolio, we can setup kubectl
  if [[ $ret_val -eq 0 ]]; then
    auth_and_create_context "${org_mngr_user}" "${org_mngr_pass}" orgmanager
    auth_and_create_context "${team_op_user}" "${team_op_pass}" teamoperator
  fi

  return $ret_val
}


function destroy_environment() {
  # Nodeport cleaning
  kubectl -n ${NAMESPACE} delete --ignore-not-found=true -f ${nodeport_dir}/nginx-service.yml
  kubectl -n ${NAMESPACE} delete --ignore-not-found=true -f ${nodeport_dir}/nginx-deployment.yml
  # Ingress cleaning
  kubectl -n ${NAMESPACE} delete --ignore-not-found=true -f ${ingress_dir}/nginx-ingress.yml
  kubectl -n ${NAMESPACE} delete --ignore-not-found=true -f ${ingress_dir}/nginx-service.yml
  kubectl -n ${NAMESPACE} delete --ignore-not-found=true -f ${ingress_dir}/nginx-deployment.yml

  # Delete portfolio expects the environment variables
  python ${APP_ROOT}/libs/kill-the-thing.py

  return 0
}

##### Start test definitions #########
@test "Namespace has been created" {
  kube="kubectl --kubeconfig=${BATS_TMPDIR}/kubeconfig --context=orgmanager"
  $kube get ns | grep ${NAMESPACE}

  [[ $? -eq 0 ]]
}

@test "Team admin cant list pods in kube-system" {
  kube="kubectl --kubeconfig=${BATS_TMPDIR}/kubeconfig --context=teamoperator"
  run $kube get pods -n kube-system

  [[ ${lines[1]} =~ "Forbidden" ]]
}

@test "Deploy a nodeport svc" {

  skip "Nodeport can't be tested outside l1c network"
  kubectl -n ${NAMESPACE} create -f ${nodeport_dir}/nginx-deployment.yml
  [[ $? -eq 0 ]]
  kubectl -n ${NAMESPACE} create -f ${nodeport_dir}/nginx-service.yml
  [[ $? -eq 0 ]]

  vip_proxy=10.241.173.13
  svc_name="myapp-nginx-service-bats-testing"
  nodeport=$(kubectl get svc ${svc_name} -o jsonpath={..nodePort})
  curl ${vip_proxy}:${nodeport}

  [[ $? -eq 0 ]]

  kubectl -n ${NAMESPACE} delete --ignore-not-found=true -f ${nodeport_dir}/nginx-service.yml
  kubectl -n ${NAMESPACE} delete --ignore-not-found=true -f ${nodeport_dir}/nginx-deployment.yml
}



@test "Deploy an ingress svc" {

  skip "Vip unreachable"
  kubectl -n ${NAMESPACE} create -f ${ingress_dir}/nginx-deployment.yml
  [[ $? -eq 0 ]]
  kubectl -n ${NAMESPACE} create -f ${ingress_dir}/nginx-service.yml
  [[ $? -eq 0 ]]
  kubectl -n ${NAMESPACE} create -f ${ingress_dir}/nginx-ingress.yml
  [[ $? -eq 0 ]]

  ingress_URL="nginx-test-bats.ngh02.staging.echonet"

  curl ${ingress_URL}
  [[ $? -eq 0 ]]

  kubectl -n ${NAMESPACE} delete --ignore-not-found=true -f ${ingress_dir}/nginx-ingress.yml
  kubectl -n ${NAMESPACE} delete --ignore-not-found=true -f ${ingress_dir}/nginx-service.yml
  kubectl -n ${NAMESPACE} delete --ignore-not-found=true -f ${ingress_dir}/nginx-deployment.yml
}
