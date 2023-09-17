Let's get started with the lab to secure S3 with IAM.

Instructions

Run the app

* Step 1: Go to the iam-playground directory

```bash
cd /S3-with-IAM
```

* Step 2: Configure your default AWS CLI profile

```bash
aws configure
```

* Step 3: Initialize Terraform
    
```bash
terraform init 
```
* Step 4: Run Terraform script
    
```bash
terraform apply -auto-approve
```

* Note: we shall use it as "s3bucket" environment variable which will be easy to access using the export command. Copy the bucket name from the output and run the below command to set the environment variable.

```bash
export s3bucket="bucketname"
```
    Note: It should look like "export s3bucket=seasides-ivghsdfflqv"

Configure User 1 through AWS CLI

Step 1: To show the access key and secret key for User1

```bash
terraform output User1
```
Step 2: Configure AWS CLI for User 1

```bash
aws configure --profile User1
```
Note: Enter the access key and secret key for User1 as shown in the output of step 1

        You should enter something like this    

        $ aws configure --profile User1
        AWS Access Key ID [****************TASE]: AKIAWRMAXKKJHASDQWE
        AWS Secret Access Key [****************4JqH]: HF6RSqXN+0vNZbI345sdfbxvx6c0yS1qin
        Default region name: `us-west-2` (Please use `us-west-2` region for this lab)
        Default output format: `json`

Configure User 2 through AWS CLI

Step 1: To show the access key and secret key for User2

```bash
terraform output User2
```
Step 2: Configure AWS CLI for User 2

```bash
aws configure --profile User2
```
Note: Configure User 2 profile same as User1 

Configure User 3 through AWS CLI

Step 1: To show the access key and secret key for User3

```bash
terraform output User3
```
Step 2: Configure AWS CLI for User 3

```bash
aws configure --profile User3
```
Note: Configure User 3 profile same as User1

Step 2: Configure AWS CLI for User 4

```bash
aws configure --profile User4
```
Note: Configure User 4 profile same as User1

* <b> Let's evaluate how policy evaluation works for IAM User 1 for S3 bucket and its object.</b>

Step 1: As we saw, User 1 has an IAM policy in iam.tf file which clearly has allow on S3 bucket and its operations on S3bucket. Contradictingly we have a bucket policy in s3.tf which clearly has a complete restriction for User 1 on bucket. Let us check some of S3 cli commands if User 1 can access it

```bash
aws s3 ls s3://$s3bucket --profile User1
```
Here, we get the error saying - An error occurred (AccessDenied) when calling the ListObject operation: Access Denied.

* Let's try if we can download/copy objects from S3 bucket which is restricted in the permission boundary policy for User 1.

```bash
aws s3 cp s3://$s3bucket/ss.mp4 .  --profile user1
```
We can see the error - An error occurred (AccessDenied) when calling the GetObject operation: Access Denied

AWS first evaluates all the bucket policies, checks for a policy which has Deny and applies the same for the attached user and ignores the Allow access. 

* <b> Let's evaluate how policy evaluation works for IAM User 2 for S3 bucket and its object. </b>

Step 1: According to our given usecase, User 2 has permission boundary attached to IAM User which has a Deny effect to access the bucket where as in the S3 bucket policy there is an Allow. Lets try out same S3 cli commands and check if user 2 has access

```bash
aws s3 ls s3://$s3bucket --profile User2
```
We get the error - An error occurred (AccessDenied) when calling the ListObject operation: Access Denied. 

* Let's try if we can retrieve objects from amazon S3 which is not provided in the permission boundary policy for User 2.

```bash
aws s3 cp s3://$s3bucket/ss.mp4 .  --profile user2
```
We can see the error - An error occurred (AccessDenied) when calling the GetObject operation: Access Denied

Eventhough bucket policy allows User 2 to access the bucket as well as IAM policy providing access User 2 is not allowed access because of permission boundary attached to User2 which is a Deny. This tells us permission boundary is evaluated primarily.

* <b> Let's evaluate how policy evaluation works for IAM User 3 for S3 bucket and its object. </b>

Finally, Lets check the User3 accessability on the bucket. Both bucket policy as well as IAM policy provides Allow access on bucket also, there is no sign of permission boundry. Lets check with the same cli commands

```bash
aws s3 ls s3://$s3bucket --profile User3
```
We get the output as expected. We can see that User 3 has access to list the object and the ase.png object in the bucket is seen.

* Let's try if we can download objects from S3 bucket.

```bash
aws s3 cp s3://$s3bucket/ss.mp4 .  --profile user3
```
We can see that the user 3 is successfully able to view and access the file ss.mp4 in the desired directory.

Considering all the three scenarios, it is seen that the bucket policy is evaluated first and then IAM policies attached to respective users. Even if one of the policy has a Deny access to User, User wont be able to perform any action on it as there is a Deny policy on it.


* <b> Let's evaluate how policy evaluation works for IAM User 4 for S3 bucket and its object. </b>

Finally, Lets check the User3 accessability on the bucket. Both bucket policy as well as IAM policy provides Allow access on bucket also, there is no sign of permission boundry. Lets check with the same cli commands

```bash
aws s3 ls s3://$s3bucket --profile User4
```
We get the output as expected. We can see that User 4 has access to list the object and the ase.png object in the bucket is seen.

* Let's try if we can download objects from S3 bucket.

```bash
aws s3 cp s3://$s3bucket/ss.mp4 .  --profile User4
```
We can see that the user 3 is successfully able to view but not access the file ss.mp4 in the desired directory.

Considering all the three scenarios, it is seen that the bucket policy is evaluated first and then IAM policies attached to respective users. Even if one of the policy has a Deny access to User, User wont be able to perform any action on it as there is a Deny policy on it.

Let's clean up all the resources created by Terraform.

* Step 1: Go to the iam-playground directory

```bash
cd /root/iam-playground
```
* Step 2: Destroy the resources created by Terraform
```bash
terraform destroy -auto-approve
```

### Conclusion:

Best Security Practices & why to use IAM with your S3

1. Data Confidentiality and Integrity: IAM policies allow you to control who can read, write, and modify objects in your S3 buckets. By crafting policies based on user roles and responsibilities, you can ensure that sensitive data is only accessible to authorized users

2. Bucket-Level Access: IAM policies can restrict users to specific S3 buckets. This is particularly useful for isolating data and ensuring that users can only access the buckets they are authorized to use.

3. Object-Level Access: You can use IAM policies to grant read or write access to specific objects within a bucket. This can prevent unauthorized users from accessing specific files while still allowing them to work with other files in the same bucket.

4. Shared Buckets: If you have shared buckets across different teams or departments, IAM policies allow you to control access on a per-user basis. Each team can have its own IAM policy to access the shared bucket without compromising security.

5. Temporary Access: IAM policies can provide temporary access to objects. For example, you can grant temporary access to contractors for specific tasks and automatically revoke the access when the task is complete.

6. Helps to organise your bucket access in your organisation according to their privileges required. 
