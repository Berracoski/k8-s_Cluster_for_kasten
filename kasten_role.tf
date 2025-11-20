resource "aws_iam_role" "kasten_role" {
  name = "kasten-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.eks.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kasten-io:kasten-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "kasten_policy" {
  name        = "kasten-policy"
  description = "Policy with EC2 and S3 permissions for Kasten role"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:CopySnapshot",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeSnapshotAttribute",
          "ec2:ModifySnapshotAttribute",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeRegions",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumeAttribute",
          "ec2:DescribeVolumesModifications",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeVolumes"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "ec2:DeleteSnapshot",
        Resource = "*",
        Condition = {
          StringLike = {
            "ec2:ResourceTag/name" = "kasten__snapshot*"
          }
        }
      },
      {
        Effect = "Allow",
        Action = "ec2:DeleteSnapshot",
        Resource = "*",
        Condition = {
          StringLike = {
            "ec2:ResourceTag/Name" = "Kasten: Snapshot*"
          }
        }
      },
      {
        Effect = "Allow",
        Action = [
          "s3:CreateBucket",
          "s3:PutObject",
          "s3:GetObject",
          "s3:PutBucketPolicy",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:DeleteBucketPolicy",
          "s3:GetBucketLocation",
          "s3:GetBucketPolicy"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kasten_attachment" {
  role       = aws_iam_role.kasten_role.name
  policy_arn = aws_iam_policy.kasten_policy.arn
}
