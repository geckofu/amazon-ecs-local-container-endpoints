FROM amazonlinux:2 as certs
FROM amazon/amazon-ecs-local-container-endpoints as origin

# Set base image to golang:latest so that we can install oidc2aws
FROM golang:latest
# Add certificates to this scratch image so that we can make calls to the AWS APIs
COPY --from=certs /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem

# Copy binary from the origin image
COPY --from=origin /local-container-endpoints /

RUN go get -u -v github.com/theplant/oidc2aws

EXPOSE 80

ENV HOME /home

CMD ["/local-container-endpoints"]
