#!/bin/sh

# Fail on errors
set -e

# Helper to make sure an env is set
function requires_env() {
eval value='$'$1 && if [ -z $value ]; then echo "$1 env is required but its missing" && exit 1; fi
}

echo "Install utilities"
apk add -U openssl curl tar gzip bash ca-certificates git jq python3
curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
curl -L -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk
apk add glibc-2.28-r0.apk
rm glibc-2.28-r0.apk

echo "Install Kubectl (Kubernetes tool)"
requires_env $KUBERNETES_VERSION
curl -L -o /usr/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl"
chmod +x /usr/bin/kubectl
kubectl version --client
apk add -U openssl curl tar gzip bash ca-certificates git
curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
curl -L -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk
apk add glibc-2.28-r0.apk
rm glibc-2.28-r0.apk

echo "Install Kustomize (Kubernetes tool)"
requires_env $KUSTOMIZE_VERSION
wget "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"
chmod +x install_kustomize.sh
./install_kustomize.sh $KUSTOMIZE_VERSION /usr/bin
rm install_kustomize.sh
kustomize version

echo "Install skaffold"
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
chmod +x skaffold
mv skaffold /usr/local/bin

echo "Install gcloud"
export GCLOUD_SDK_URL=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz

cd /opt
wget -q -O - $GCLOUD_SDK_URL | tar zxf -
/bin/sh -l -c "echo Y | /opt/google-cloud-sdk/install.sh && exit"
/bin/sh -l -c "echo Y | /opt/google-cloud-sdk/bin/gcloud components install alpha && exit"
rm -rf /opt/google-cloud-sdk/.install/.backup
cd -
ln -s /opt/google-cloud-sdk/bin/gcloud /usr/bin/gcloud

echo "Install nvm"

apk add --no-cache libstdc++
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
echo 'source $HOME/.profile;' >> $HOME/.bashrc
echo 'export NVM_DIR="$HOME/.nvm";' >> $HOME/.profile
echo "[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh" >> $HOME/.profile
echo 'export NVM_NODEJS_ORG_MIRROR=https://unofficial-builds.nodejs.org/download/release;' >> $HOME/.profile
echo 'nvm_get_arch() { nvm_echo "x64-musl"; }' >> $HOME/.profile

source $HOME/.profile