
# prereqs
# Username/password X 2

function setup() {

    python onboard.py

}

function teardown() {
  python kill-the-thing.py
  # Delete Portfolio
  # Delete ORG

}

@test "Team admin can add user" {

  # Must be executed as team admin
  # cloudctl iam user foobar

  # cloudctl iam team get (validate that the user exists)
  # [[ ]]
}

@test "Cloud admin add helm chart" {

  # cloudctl catalog load-chart

  # cloudctl catalog charts
  # [[ ]]
}




@test "Team admin push image to namespace" {
  # docker login && docker push

  # kubectl get images -n <namespace>

  #[[ ]]
}

@test "Docker image not accessible in different namespace" {
  # kubectl create -f

  # kubectl get pod -l foobar | grep ImagePullBackoff

  # [[ ]]
}

@test "Can push helm chart" {
  # helm package
  # cloudctl catalog foobar
  # [[ ]]
}

@test "Team Operator Can deploy helm release from catalog" {
    # helm repo add
    # helm d
    # [[ ]]
}

@test "Team Operator " {


}



@test "Configure the connectivity between two pods (Network Policy)"




@test "Deploy a nodeport svc" {

  # deploy pod with svc
  [[ $? -eq 0 ]]

  # nodeport=$(kubectl get svc -l foo=bar -o jsonpath={foobar})
  # curl nodeport


  [[ ]]

}



@test "Deploy an ingress svc" {

  # deploy pod with svc
  [[ $? -eq 0 ]]

  # curl url


  [[ ]]

}
