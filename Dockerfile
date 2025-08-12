FROM amazon/aws-lambda-python:latest-x86_64 AS build

RUN sh -c "$(curl -fs https://raw.githubusercontent.com/umihico/docker-selenium-lambda/main/Dockerfile | sed -n '2,6{s/RUN //;p}')"

FROM amazon/aws-lambda-python:latest-x86_64

RUN dnf install -y --nodocs --setopt=install_weak_deps=0 git \
    atk cups-libs gtk3 libXcomposite alsa-lib \
    libXcursor libXdamage libXext libXi libXrandr libXScrnSaver \
    libXtst pango at-spi2-atk libXt xorg-x11-server-Xvfb \
    xorg-x11-xauth dbus-glib dbus-glib-devel nss mesa-libgbm && \
    dnf clean all && rm -rf /var/cache/dnf/* && \
    pip install --no-cache-dir -U selenium git+https://www.github.com/filipopo/undetected-chromedriver@master

COPY --from=build /opt/chrome-linux64 /opt/chrome
COPY --from=build /opt/chromedriver-linux64 /opt/
COPY main.py .

CMD [ "main.handler" ]
