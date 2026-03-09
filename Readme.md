# terraform-modules

## Ajustar versiones en fichero:
```
terragrunt.hcl
```


## Rename dirs:

```./<environment>/<region>/<module>```

- Example: ```./testing/eu-west-1/vpc/```


## Step 1:

- Configure: ```./config.yaml```

## Step 2:


- ```./terragrunt init```

## Step 3:

- Configure: ```./testing/eu-west-1/vpc/terraform.tfvars```

- cd ```./testing/eu-west-1/vpc```
- ```terragrunt init```
- ```terragrunt plan```
- ```terragrunt apply```

## Step 4:

- Configure: ```./testing/eu-west-1/iam/terraform.tfvars```

- cd ```./testing/eu-west-1/iam```
- ```terragrunt init```
- ```terragrunt plan```
- ```terragrunt apply```

## Step 5:

- Configure: ```./testing/eu-west-1/eks/terraform.tfvars```

- cd ```./testing/eu-west-1/eks```
- ```terragrunt init```
- ```terragrunt plan```
- ```terragrunt apply```

## Step 6:

- Configure: ```./testing/eu-west-1/k8s/terraform.tfvars```

- cd ```./testing/eu-west-1/k8s```
- ```terragrunt init```
- ```terragrunt plan```
- ```terragrunt apply```

## Step 7:

- Configure: ```./testing/eu-west-1/ecr/terraform.tfvars```

- cd ```./testing/eu-west-1/ecr```
- ```terragrunt init```
- ```terragrunt plan```
- ```terragrunt apply```

