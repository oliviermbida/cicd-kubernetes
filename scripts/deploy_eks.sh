#!/bin/bash
REGION="us-east-1"
# You must change the VPC S3 Bucket endpoint to your chosen S3 bucket
# It is currently set to ${TMP_BUCKET}
BUCKET=""
STACKNAME=""
#EXIT=0
#cfn-lint eks.yaml  

if [ "${BUCKET}" == "" ] ; then
    TMP_BUCKET="eks-tmp-$(LC_CTYPE=C tr -dc 'a-z0-9' </dev/urandom | fold -w 16 | head -n 1)"
    aws s3 mb s3://${TMP_BUCKET} --region ${REGION} 
    cat <<EOF > ./policy.json
{
   "Statement": [
      {
         "Effect": "Allow",
         "Principal": {"Service": "cloudformation.amazonaws.com"},
         "Action": ["s3:GetObject", "s3:ListBucket"],
         "Resource": ["arn:aws:s3:::${TMP_BUCKET}", "arn:aws:s3:::${TMP_BUCKET}/*"]
      }
   ]
}
EOF
    aws s3api put-bucket-policy --bucket ${TMP_BUCKET} --policy file://./policy.json --region ${REGION} || EXIT=$?
    BUCKET=${TMP_BUCKET}
fi
aws cloudformation package --template-file ./cluster.yaml \
  --s3-bucket ${BUCKET} \
  --output-template-file ./cluster-packaged.yaml
# wait
while [ ! -f "./cluster-packaged.yaml" ] ; do
  echo "..."
done     
aws cloudformation deploy --template-file ./cluster-packaged.yaml --stack-name ${STACKNAME} --parameter-overrides S3BucketName=${TMP_BUCKET} --region ${REGION} --capabilities CAPABILITY_NAMED_IAM 

