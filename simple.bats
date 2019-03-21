
load ${APP_ROOT}/libs/sequential-helpers.bash

# # prereqs
export nodeport_dir="${APP_ROOT}/nodeport"
export ingress_dir="${APP_ROOT}/ingress"

function destroy_environment() {

  # Nodeport cleaning
  kubectl delete --ignore-not-found=true -f ${nodeport_dir}/nginx-service.yml
  kubectl delete --ignore-not-found=true -f ${nodeport_dir}/nginx-deployment.yml
  # Ingress cleaning
  kubectl delete --ignore-not-found=true -f ${ingress_dir}/nginx-ingress.yml
  kubectl delete --ignore-not-found=true -f ${ingress_dir}/nginx-service.yml
  kubectl delete --ignore-not-found=true -f ${ingress_dir}/nginx-deployment.yml
}

@test "Deploy a nodeport svc" {

  skip "Nodeport can't be tested outside l1c network"
  kubectl create -f ${nodeport_dir}/nginx-deployment.yml
  [[ $? -eq 0 ]]
  kubectl create -f ${nodeport_dir}/nginx-service.yml
  [[ $? -eq 0 ]]

  vip_proxy=10.241.173.13
  svc_name="myapp-nginx-service-bats-testing"
  nodeport=$(kubectl get svc ${svc_name} -o jsonpath={..nodePort})
  curl ${vip_proxy}:${nodeport}

  [[ $? -eq 0 ]]

  kubectl delete --ignore-not-found=true -f ${nodeport_dir}/nginx-service.yml
  kubectl delete --ignore-not-found=true -f ${nodeport_dir}/nginx-deployment.yml
}



@test "Deploy an ingress svc" {

  kubectl create -f ${ingress_dir}/nginx-deployment.yml
  [[ $? -eq 0 ]]
  kubectl create -f ${ingress_dir}/nginx-service.yml
  [[ $? -eq 0 ]]
  kubectl create -f ${ingress_dir}/nginx-ingress.yml
  [[ $? -eq 0 ]]

  ingress_URL="nginx-test-bats.ngh02.staging.echonet"

  curl ${ingress_URL}
  [[ $? -eq 0 ]]

  kubectl delete --ignore-not-found=true -f ${ingress_dir}/nginx-ingress.yml
  kubectl delete --ignore-not-found=true -f ${ingress_dir}/nginx-service.yml
  kubectl delete --ignore-not-found=true -f ${ingress_dir}/nginx-deployment.yml
}
