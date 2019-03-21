
load ${APP_ROOT}/libs/sequential-helpers.bash



destroy_environment() {

  helm delete --purge $(helm list --tls| grep cloudng-nginx-nodeport-1.1| awk '{print $1}') --tls

  cloudctl catalog delete-helm-chart --name cloudng-nginx-nodeport --repo local-charts

}


@test "Deploy using helm charts : adding cluster repo" {

  run helm repo add testrepo https://${SERVER}:8443/helm-repo/charts --ca-file $HELM_HOME/ca.pem --cert-file $HELM_HOME/cert.pem --key-file $HELM_HOME/key.pem

  # If this test fails we want to skip subsequent tests
  if [[ ${status} -gt 0 ]]; then
    skip_subsequent
  fi

  [[ ${status} -eq 0 ]]

  run helm repo update

  [[ ${status} -eq 0 ]]

}



@test "Deploy using helm charts : load charts" {

  run cloudctl catalog load-helm-chart --archive ${APP_ROOT}/helm/cloudng-nginx-nodeport-1.1.tgz --repo local-charts

  # If this test fails we want to skip subsequent tests
  if [[ ${status} -gt 0 ]]; then
    skip_subsequent
  fi

  [[ ${status} -eq 0 ]]

}



@test "Deploy using helm charts : install release" {

  run helm install testrepo/cloudng-nginx-nodeport --tls

  # If this test fails we want to skip subsequent tests
  if [[ ${status} -gt 0 ]]; then
    skip_subsequent
  fi

  [[ ${status} -eq 0 ]]

}

@test "Deploy using helm charts : release deployed" {

  result=$(helm list --tls| grep cloudng-nginx-nodeport-1.1)

  status=$(echo $result | awk '{print $4}')

  [[ "${status}" == "DEPLOYED" ]]

}

@test "Deploy using helm charts : application working" {

  timeout=120
  sleeptime=5
  function pod_ready() {
    status=$(kubectl get pods | grep myapp-front-deployment | awk '{print $3}')
    if [[ "$status" == "Running" ]]; then
      return 0
    else
      return 1
    fi
  }

  _attempt=1
  while ! pod_ready && [[ $_timeout -gt $(( $_attempt * ${sleeptime} )) ]]; do
    sleep ${sleeptime}
    _attempt=$(($_attempt+1))
  done

  status=$(kubectl get pods | grep myapp-front-deployment | awk '{print $3}')
  [[ "$status" == "Running" ]]
}
