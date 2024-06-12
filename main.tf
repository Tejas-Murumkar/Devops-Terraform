provider "aws" {
	region = "us-east-1"
	profile = "Devops_Rushi"
}
# create a iam user and group 
resource "aws_iam_user""First"{
	name = "Raj"
}

resource "aws_iam_user""Second"{
	name = "Rohan"
}

resource "aws_iam_user""Third"{
	name = "Nipun"
}

resource "aws_iam_user""fourth"{
	name = "Ali"
}

resource "aws_iam_group""friends"{
	name = "College"
}

resource "aws_iam_user_group_membership""memberadd1"{
	user = aws_iam_user.First.name
	
	groups = [
		aws_iam_group.friends.name
	]
}

resource "aws_iam_user_group_membership""memberadd2"{
	user = aws_iam_user.Second.name

	groups = [
		aws_iam_group.friends.name
	]

}

# create a s3 bucket with private ACL

resource "aws_s3_bucket" "bucket1" {
  bucket = "cap-buck-bucket"
}

resource "aws_s3_bucket_ownership_controls" "owner" {
  bucket = aws_s3_bucket.bucket1.id
  rule {
	object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
	bucket = aws_s3_bucket.bucket1.id
	acl = "private"
   depends_on = [ aws_s3_bucket_ownership_controls.owner ]
}

# Create S3 bucket with public-read ACL 
resource "aws_s3_bucket" "bucket2" {
  bucket = "cap-buck-bucket-1"
}

resource "aws_s3_bucket_ownership_controls" "owner2" {
  bucket = aws_s3_bucket.bucket2.id
  rule {
	object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.bucket2.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false

}

resource "aws_s3_bucket_acl" "name" {
	depends_on = [ aws_s3_bucket_ownership_controls.owner2, aws_s3_bucket_public_access_block.public ]
	bucket = aws_s3_bucket.bucket2.id
	acl = "public-read"
}
