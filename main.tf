resource "random_string" "random_name" {
  length  = 10
  special = false
  upper   = false
}

resource "aws_iam_user" "user_one" {
  name = "seasides-user1"
}


resource "aws_iam_user_login_profile" "user_one" {
  user                    = aws_iam_user.user_one.name
  password_reset_required = true
}

resource "aws_iam_policy" "policy_user_1" {
  name   = "seasides-user1-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.ases3.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "policy_user_1" {
  user       = aws_iam_user.user_one.name
  policy_arn = aws_iam_policy.policy_user_1.arn
}

resource "aws_iam_user" "user_two" {
  name                 = "seasides-user2"
  permissions_boundary = aws_iam_policy.boundary_policy.arn

}

resource "aws_iam_policy" "policy_user_2" {
  name   = "seasides-user2-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.ases3.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "policy_user_2" {
  user       = aws_iam_user.user_two.name
  policy_arn = aws_iam_policy.policy_user_2.arn
}


resource "aws_iam_user_login_profile" "user_two" {
  user                    = aws_iam_user.user_two.name
  password_reset_required = true
}


resource "aws_iam_policy" "boundary_policy" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Deny",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user" "user_three" {
  name = "seasides-user3"
}

resource "aws_iam_user_login_profile" "user_three" {
  user                    = aws_iam_user.user_three.name
  password_reset_required = true
}

resource "aws_iam_policy" "policy_user_3" {
  name   = "seasides-user3-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.ases3.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "policy_user_3" {
  user       = aws_iam_user.user_three.name
  policy_arn = aws_iam_policy.policy_user_3.arn
}

resource "aws_iam_access_key" "create_user_access_key1" {
  user = aws_iam_user.user_one.name
}

resource "aws_iam_access_key" "create_user_access_key2" {
  user = aws_iam_user.user_two.name
}

resource "aws_iam_access_key" "create_user_access_key3" {
  user = aws_iam_user.user_three.name
}
