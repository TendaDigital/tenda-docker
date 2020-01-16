#!/bin/sh

# Fail on errors
set -e

# Helper to make sure an env is set
function requires_env() {
eval value='$'$1 && if [ -z $value ]; then echo "$1 env is required but its missing" && exit 1; fi
}

# Install utilities
apk add -U openssl curl tar gzip bash ca-certificates git jq
curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
curl -L -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk
apk add glibc-2.28-r0.apk
rm glibc-2.28-r0.apk

# Install Kubectl (Kubernetes tool)
requires_env $KUBERNETES_VERSION
curl -L -o /usr/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl"
chmod +x /usr/bin/kubectl
kubectl version --client
apk add -U openssl curl tar gzip bash ca-certificates git
curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
curl -L -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk
apk add glibc-2.28-r0.apk
rm glibc-2.28-r0.apk

# Install Kustomize (Kubernetes tool)
requires_env $KUSTOMIZE_VERSION
curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/tags/v${KUSTOMIZE_VERSION} |\
grep browser_download |\
grep linux |\
cut -d '"' -f 4 |\
xargs curl -L -o /usr/bin/kustomize
chmod +x /usr/bin/kustomize
kustomize version

# Install skaffold
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
chmod +x skaffold
mv skaffold /usr/local/bin

# Install gcloud
export GCLOUD_SDK_URL=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz
apk add --no-cache --update python
apk add curl openssl
cd /opt
wget -q -O - $GCLOUD_SDK_URL | tar zxf -
/bin/sh -l -c "echo Y | /opt/google-cloud-sdk/install.sh && exit"
/bin/sh -l -c "echo Y | /opt/google-cloud-sdk/bin/gcloud components install alpha && exit"
rm -rf /opt/google-cloud-sdk/.install/.backup
cd -
ln -s /opt/google-cloud-sdk/bin/gcloud /usr/bin/gcloud
