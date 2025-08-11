# undetected-chromedriver-lambda
A minimal example of using [undetected-chromedriver](https://github.com/ultrafunkamsterdam/undetected-chromedriver) on AWS Lambda, based on [docker-selenium-lambda](https://github.com/umihico/docker-selenium-lambda)

## Quick start guide
These instructions are based on AWS provided instructions found [here](https://docs.aws.amazon.com/lambda/latest/dg/python-image.html#python-image-instructions)

To deploy this on AWS you will need an ECR repository, you can run the following command to create it

```bash
aws ecr create-repository --repository-name undetected-chromedriver-lambda  --image-scanning-configuration scanOnPush=true --image-tag-mutability MUTABLE
```

Next you will need login credentials to use with docker for your region and aws_account_id e.g us-east-1 and 100000000000, be sure to replace these with your own

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 100000000000.dkr.ecr.us-east-1.amazonaws.com
```

Next get the image

```bash
docker pull filipmania/undetected-chromedriver-lambda:latest
```

or

```bash
docker build --platform linux/amd64 -t filipmania/undetected-chromedriver-lambda:latest .
```

and tag it

```bash
docker tag filipmania/undetected-chromedriver-lambda:latest 100000000000.dkr.ecr.us-east-1.amazonaws.com/undetected-chromedriver-lambda:latest
```

Now you are ready to push it

```bash
docker push 100000000000.dkr.ecr.us-east-1.amazonaws.com/undetected-chromedriver-lambda:latest
```

After this you can create a Lambda function using the image url which is `100000000000.dkr.ecr.us-east-1.amazonaws.com/undetected-chromedriver-lambda:latest` (you'll need to set the Lambda timeout to more than the default 3 seconds)

## Advanced usage

To get more than a minimal example, change the code, rebuild the image, and then run the container

### Dynamic url

Change [this line](https://github.com/filipopo/undetected-chromedriver-lambda/blob/fa605abf8ef13151d89c4c049dc745f4f0670814/main.py#L29) to `chrome.get(event.get('url'))`, prepare the container

```bash
docker build --platform linux/amd64 -t filipmania/undetected-chromedriver-lambda:latest .
docker run -p 9000:8080 filipmania/undetected-chromedriver-lambda:latest
```

Then invoke the url set by [amazon/aws-lambda-python](https://hub.docker.com/r/amazon/aws-lambda-python#usage), any JSON in -d is passed to the function's event

```bash
curl 'http://localhost:9000/2015-03-31/functions/function/invocations' -d '{"url": "https://example.com"}'
```

You can also have a fallback like `chrome.get(event.get('url', 'https://example.com'))`, in which case you can invoke the url like this

```bash
curl 'http://localhost:9000/2015-03-31/functions/function/invocations' -d '{}'
```

### Local execution

Add the following to the end of main.py

```python
if __name__ == '__main__' and os.getenv('AWS_LAMBDA_FUNCTION_NAME') is None:
    print(handler())
```

Now you can run the function outside of Lambda

```bash
docker build --platform linux/amd64 -t filipmania/undetected-chromedriver-lambda:latest .
docker run --entrypoint python filipmania/undetected-chromedriver-lambda:latest main.py
```

You can add a dynamic url to this setup with something like

```python
event = {'url': sys.argv[1]} if len(sys.argv) > 1 else {}
```

## Thanks to

https://github.com/umihico/docker-selenium-lambda

https://github.com/ultrafunkamsterdam/undetected-chromedriver

Unknown [ghost](https://github.com/ghost) from issue [2](https://github.com/filipopo/undetected-chromedriver-lambda/issues/2)
