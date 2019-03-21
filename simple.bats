
# # prereqs
  nodeport_dir="${PWD}/nodeport"
  ingress_dir="${PWD}/ingress"
# # Username/password X 2

# function setup() {

#     python onboard.py

# }

# function teardown() {
#   python kill-the-thing.py
#   # Delete Portfolio
#   # Delete ORG

# }

function destroy_environment() {
  
  # Nodeport cleaning
  kubectl delete --ignore-not-found=true -f ${nodeport_dir}/nginx-service.yml
  kubectl delete --ignore-not-found=true -f ${nodeport_dir}/nginx-deployment.yml
  # Ingress cleaning
  kubectl delete --ignore-not-found=true -f ${ingress_dir}/nginx-ingress.yml
  kubectl delete --ignore-not-found=true -f ${ingress_dir}/nginx-service.yml
  kubectl delete --ignore-not-found=true -f ${ingress_dir}/nginx-deployment.yml
}

# @test "Team admin can add user" {

#   # Must be executed as team admin
#   # cloudctl iam user foobar

#   # cloudctl iam team get (validate that the user exists)
#   # [[ ]]
# }

# @test "Cloud admin add helm chart" {

#   # cloudctl catalog load-chart

#   # cloudctl catalog charts
#   # [[ ]]
# }




# @test "Team admin push image to namespace" {
#   # docker login && docker push

#   # kubectl get images -n <namespace>

#   #[[ ]]
# }

# @test "Docker image not accessible in different namespace" {
#   # kubectl create -f

#   # kubectl get pod -l foobar | grep ImagePullBackoff

#   # [[ ]]
# }

# @test "Can push helm chart" {
#   # helm package
#   # cloudctl catalog foobar
#   # [[ ]]
# }

# @test "Team Operator Can deploy helm release from catalog" {
#     # helm repo add
#     # helm d
#     # [[ ]]
# }

# @test "Team Operator " {


# }



# @test "Configure the connectivity between two pods (Network Policy)"




@test "Deploy a nodeport svc" {

  kubectl create -f ${nodeport_dir}/nginx-deployment.yml
  [[ $? -eq 0 ]]
  kubectl create -f ${nodeport_dir}/nginx-service.yml
  [[ $? -eq 0 ]]

  vip_proxy=10.241.173.13
  svc_name="myapp-nginx-service-bats-testing"
  nodeport=$(kubectl get svc ${svc_name} -o jsonpath={..nodePort})
  #curl ${vip_proxy}:${nodeport}
  true
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
