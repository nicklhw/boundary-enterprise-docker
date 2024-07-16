# Boundary Enterprise Docker

## Quick Start

```shell
# 1. setup your SSH public key for the ssh-target
cp ~/.ssh/id_rsa.pub ./docker-compose/ssh-target

# 2. setup boundary controller and worker
export BOUNDARY_LICENSE=<your boundary enterprise license>

make all

# 3. grab boundary worker auth token from terraform/boundary/worker/data and set it in terraform.auto.tfvars

# 4. setup boundary
make tf-apply

# 5. grab the auth method id and target id from the output

# 6. authenticate to boundary
export BOUNDARY_ADDR=http://localhost:9200
boundary authenticate password -auth-method-id=<auth_method_id>

# 7. connect to the target
boundary connect ssh -target-id=<target_id>
```

## Notes


## Resources
- [Boundary Enterprise Docker](https://hub.docker.com/r/hashicorp/boundary-enterprise)
- [Boundary Reference Architecture](https://github.com/hashicorp/boundary-reference-architecture/blob/main/deployment/docker/compose/boundary.hcl)
- [How to SSH into Docker containers](https://circleci.com/blog/ssh-into-docker-container/)
- [Automating Docker with Ansible](https://medium.com/@nr817174/automating-docker-with-ansible-a-step-by-step-guide-159a69597644)