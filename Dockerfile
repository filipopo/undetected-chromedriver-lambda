FROM umihico/aws-lambda-selenium-python:latest

RUN yum install -y git && pip install git+https://www.github.com/filipopo/undetected-chromedriver@master
COPY main.py ./
CMD [ "main.handler" ]
