
load ${APP_ROOT}/libs/sequential-helpers.bash



destroy_environment() {

  helm delete $(helm list --tls| grep cloudng-nginx-nodeport-1.1| awk '{print $1}') --tls

  cloudctl catalog delete-helm-chart --name cloudng-nginx-nodeport --repo local-charts

}


@test "Deploy using helm charts : adding cluster repo" {

  helm repo add testrepo https://${SERVER}:8443/helm-repo/charts --ca-file $HELM_HOME/ca.pem --cert-file $HELM_HOME/cert.pem --key-file $HELM_HOME/key.pem
  retval=$?

  # If this test fails we want to skip subsequent tests
  if [[ ${retval} -gt 0 ]]; then
    skip_subsequent
  fi

  [[ ${retval} -eq 0 ]]

  helm repo update

  [[ $? -eq 0 ]]

}



@test "Deploy using helm charts : load charts" {

  cloudctl catalog load-helm-chart --archive cloudng-nginx-nodeport-1.1.tgz --repo local-charts
  retval=$?

  # If this test fails we want to skip subsequent tests
  if [[ ${retval} -gt 0 ]]; then
    skip_subsequent
  fi

  [[ ${retval} -eq 0 ]]

}



@test "Deploy using helm charts : install release" {

  helm install testrepo/cloudng-nginx-nodeport --tls
  retval=$?

  # If this test fails we want to skip subsequent tests
  if [[ ${retval} -gt 0 ]]; then
    skip_subsequent
  fi

  [[ ${retval} -eq 0 ]]

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
