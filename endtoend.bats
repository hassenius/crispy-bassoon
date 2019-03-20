
load ./libs/sequential-helpers.bash

function create_environment() {
  # Create portfolio expects environment variables to be available
  python ${APP_ROOT}/libs/setup.py
  return $?
}

function destroy_environment() {
  # Delete portfolio expects the environment variables
  # 1.
  # 2.
  # 3.
  #python libs/delete_portfolio.py
  return 0
}

@test "mocktest" {
  [[ 1 -eq 1 ]]
}
