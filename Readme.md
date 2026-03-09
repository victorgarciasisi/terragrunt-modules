# terraform-modules

## Ajustar versiones (terraform) en fichero:
```
terragrunt.hcl
```


## Rename dirs:

```./<environment>/<region>/```

- Example: ```./aws-eks/eu-west-1/```


## Step 1:

- cd ```./aws-eks/eu-west-1/vpc```
- Configure: ```./config.yaml```

## Step 2:


- ```./terragrunt init```

## Step 3:

- Configure: ```./aws-eks/eu-west-1/vpc/terraform.tfvars```

- cd ```./aws-eks/eu-west-1/vpc```
- ```terragrunt init```
- ```terragrunt plan```
- ```terragrunt apply```

## Step 4:

- Configure: ```./aws-eks/eu-west-1/iam/terraform.tfvars```

- cd ```./aws-eks/eu-west-1/iam```
- ```terragrunt init```
- ```terragrunt plan```
- ```terragrunt apply```

## Step 5:

- Configure: ```./aws-eks/eu-west-1/eks/terraform.tfvars```

- cd ```./aws-eks/eu-west-1/eks```
- ```terragrunt init```
- ```terragrunt plan```
- ```terragrunt apply```

## Step 6:

- Configure: ```./aws-eks/eu-west-1/k8s/terraform.tfvars```

- cd ```./aws-eks/eu-west-1/k8s```
- ```terragrunt init```
- ```terragrunt plan```
- ```terragrunt apply```

## Step 7:

- Configure: ```./aws-eks/eu-west-1/ecr/terraform.tfvars```

- cd ```./aws-eks/eu-west-1/ecr```
- ```terragrunt init```
- ```terragrunt plan```
- ```terragrunt apply```

