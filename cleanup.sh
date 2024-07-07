#!/usr/bin/env bash

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

DEFAULT_CLUSTER_NAME=kind

main() {
    args=()

    if [[ -n "${INPUT_CLUSTER_NAME:-}" ]]; then
        args+=(--name "${INPUT_CLUSTER_NAME}")
    else
        args+=(--name "${DEFAULT_CLUSTER_NAME}")
    fi

    sudo kind delete cluster "${args[@]}"

    registry_id=$(docker ps --filter "name=kind-registry" --format "{{.ID}}")
    if [[ -n "$registry_id" ]]; then
      echo "Deleting kind-registry..."
      docker rm --force kind-registry
      docker network rm  kind
    fi
}

main
