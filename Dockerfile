FROM umihico/aws-lambda-selenium-python:latest

RUN dnf install -y --nodocs --setopt=install_weak_deps=0 git && \
    pip install --no-cache-dir --upgrade git+https://www.github.com/filipopo/undetected-chromedriver@master && \
    dnf clean all && rm -rf /var/cache/dnf/*

COPY main.py ./

CMD [ "main.handler" ]
