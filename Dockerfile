FROM node:latest

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git

RUN adduser --disabled-password --gecos '' democracyos && \
    adduser democracyos sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN cd /opt && \
    git clone https://github.com/DemocracyOS/app.git && \
    chown -R democracyos ./app && \
    cd app && \
    git checkout 1.0.0 && \
    su democracyos -s /bin/bash -c 'make build'

EXPOSE 3000
ENV MONGO_URL mongodb://mongo/DemocracyOS-dev
ENV NODE_PATH /opt/app
WORKDIR /opt/app

ENTRYPOINT ["su","democracyos","-s","/bin/bash","-c","make run"]


# To launch:
# docker run -it \
#     --link dos-mongo:mongo \
#     -v /host/path/to/democracyos/app:/opt/app \
#     -p 3000:3000 \
#     --name dos-app_0 \
#     dos-app

