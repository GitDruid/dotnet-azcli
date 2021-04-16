#
# .Net 5 on Debian 10 (https://hub.docker.com/_/microsoft-dotnet-sdk).
# Already contains PowerShell 7.1.3 (https://github.com/dotnet/dotnet-docker/blob/ec4af28c9e9a643baff525b68c38c18cd02f2e36/src/sdk/5.0/buster-slim/amd64/Dockerfile).
# Additional info in case of changes in base image (https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7).
#
FROM mcr.microsoft.com/dotnet/sdk:5.0

LABEL maintainer="Alessandro Galasso"

# Install Azure CLI as addressed here: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest

# 1. Get packages needed for the install process
RUN apt-get update \
    && apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg

# 2. Download and install the Microsoft signing key:
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

# 3. Add the Azure CLI software repository
RUN AZ_REPO=$(lsb_release -cs) \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list

# 4. Update repository information and install the azure-cli package
RUN apt-get update \
    && apt-get install azure-cli
