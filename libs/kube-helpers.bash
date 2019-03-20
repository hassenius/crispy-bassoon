function auth_and_create_context() {

  # Local variables
  username=$1
  password=$2
  context_name=$3

  # Now get authentication token
  token=$(curl -s -k -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "grant_type=password&username=${username}&password=${password}&scope=openid" https://${SERVER}:8443/idprovider/v1/auth/identitytoken --insecure | jq .id_token | awk  -F '"' '{print $2}')

  # Create or update our kubeconfig
  kube="kubectl --kubeconfig=${BATS_TMPDIR}/kubeconfig"
  $kube config set-cluster ${context_name} --server=https://$server:${KUBE_APISERVER_PORT} --insecure-skip-tls-verify=true
  $kube config set-context ${context_name} --cluster=${context_name}
  $kube config set-credentials $username --token=$token
  $kube config set-context ${context_name} --user=${username} --namespace=${NAMESPACE}
  $kube config use-context ${context_name}
}

export -f auth_and_create_context
