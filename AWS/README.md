## Terraform AWS Deployment
Bootstrap AWS Access

```
adminGroupName='tfadmins'
userName='terraform'
aws iam create-group --group-name $adminGroupName
aws iam attach-group-policy --group-name $adminGroupName --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam list-attached-group-policies --group-name $adminGroupName
aws iam create-user --user-name $userName
aws iam add-user-to-group --group-name $adminGroupName --user-name $userName
$accessKey = $(aws iam create-access-key --user-name $userName | ConvertFrom-Json)
export AWS_ACCESS_KEY_ID = $accessKey.AccessKey.AccessKeyId
export AWS_SECRET_ACCESS_KEY = $accessKey.AccessKey.SecretAccessKey
export AWS_DEFAULT_REGION = 'us-east-1'
aws configure
```

### EXAMPLE -1 
Fetching details using `data`

### EXAMPLE -2
Create a bucket and dynamo DB for backend

### EXAMPLE -3
Looping - Using Count Parameter
