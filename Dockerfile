FROM alpine AS download

WORKDIR /root

# TODO install kubectl from alpine's repository once it is in mainline
RUN apk add --no-cache curl
RUN curl -LO https://dl.k8s.io/release/v1.22.0/bin/linux/amd64/kubectl
RUN chmod 755 kubectl

FROM alpine

ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_DEFAULT_REGION=""
ENV K8S_NAMESPACES="default"

RUN apk add --no-cache aws-cli jq

COPY update_ecr_credentials /usr/bin/update_ecr_credentials
COPY --from=download --chown=root:root /root/kubectl /usr/local/bin/kubectl

ENTRYPOINT ["/usr/bin/update_ecr_credentials"]
