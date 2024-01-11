# undetected-chromedriver-lambda
A minimal working example of using undetected-chromedriver on AWS Lambda

This repo will attempt to use the latest versions of undetected-chromedriver and it's based on https://github.com/umihico/docker-selenium-lambda
## Quick start guide
These instructions are based on AWS provided instructions found here: https://docs.aws.amazon.com/lambda/latest/dg/python-image.html#python-image-instructions

To deploy this on AWS you will need an ECR repository, you can run the following command to create it
```
aws ecr create-repository --repository-name undetected-chromedriver-lambda  --image-scanning-configuration scanOnPush=true --image-tag-mutability MUTABLE
```
Next you will need login credentials to use with docker for your region and aws_account_id e.g us-east-1 and 100000000000, be sure to replace these with your own
```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 100000000000.dkr.ecr.us-east-1.amazonaws.com
```
Next get the image
```
docker pull filipmania/undetected-chromedriver-lambda:latest
```
or
```
docker build --platform linux/amd64 -t filipmania/undetected-chromedriver-lambda:latest .
```
and tag it
```
dock tag filipmania/undetected-chromedriver-lambda:latest 100000000000.dkr.ecr.us-east-1.amazonaws.com/undetected-chromedriver-lambda:latest
```
Now you are ready to push it
```
docker push 100000000000.dkr.ecr.us-east-1.amazonaws.com/undetected-chromedriver-lambda:latest
```
After this you can create a Lambda function using the image url which is `100000000000.dkr.ecr.us-east-1.amazonaws.com/undetected-chromedriver-lambda:latest` (you'll need to set the Lambda timeout to more than the default 3 seconds)

You may of course run and interactively test the container yourself before tagging and pushing:
```
docker run filipmania/undetected-chromedriver-lambda:latest
docker exec -it (CONTAINER ID) /bin/sh
```

## Thanks to

https://github.com/umihico/docker-selenium-lambda

and

https://github.com/ultrafunkamsterdam/undetected-chromedriver
