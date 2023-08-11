variable "aws_region" {
  default = "us-west-2"
}


output "s3bucketname" {
  value = {
    BucketName = aws_s3_bucket.SeaSidesbucket.bucket
    arn        = aws_s3_bucket.SeaSidesbucket.arn
  }
}

output "User1" {
  value = {
    UserName  = aws_iam_user.user_one.name,
    AccessKey = aws_iam_access_key.create_user_access_key1.id
    SecretKey = aws_iam_access_key.create_user_access_key1.secret
    arn       = aws_iam_user.user_one.arn
  }
  sensitive = true
}

output "User2" {
  value = {
    UserName  = aws_iam_user.user_two.name,
    AccessKey = aws_iam_access_key.create_user_access_key2.id
    SecretKey = aws_iam_access_key.create_user_access_key2.secret
    arn       = aws_iam_user.user_two.arn

  }
  sensitive = true
}

output "User3" {
  value = {
    UserName  = aws_iam_user.user_three.name,
    AccessKey = aws_iam_access_key.create_user_access_key3.id
    SecretKey = aws_iam_access_key.create_user_access_key3.secret
    arn       = aws_iam_user.user_three.arn

  }
  sensitive = true
}

output "User4" {
  value = {
    UserName  = aws_iam_user.user_four.name,
    AccessKey = aws_iam_access_key.create_user_access_key4.id
    SecretKey = aws_iam_access_key.create_user_access_key4.secret
    arn       = aws_iam_user.user_four.arn

  }
  sensitive = true
}
