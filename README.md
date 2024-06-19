# Boundary Enterprise Docker

## Quick Start

```shell
# setup boundary controller and worker
export BOUNDARY_LICENSE=<your boundary enterprise license>

make all

# setup boundary target
make tf-apply

# grab the auth method id and target id from the output

# authenticate to boundary
export BOUNDARY_ADDR=http://localhost:9200
boundary authenticate password -auth-method-id=<auth_method_id>

# connect to the target
boundary connect ssh -target-id=<target_id> -- -l <username>
```

## Notes


## Resources
- [Boundary Enterprise Docker](https://hub.docker.com/r/hashicorp/boundary-enterprise)
- [Boundary Reference Architecture](https://github.com/hashicorp/boundary-reference-architecture/blob/main/deployment/docker/compose/boundary.hcl)
- [How to SSH into Docker containers](https://circleci.com/blog/ssh-into-docker-container/)