FROM mcr.microsoft.com/vscode/devcontainers/universal:linux

USER codespace

# Install .NET Core SDK
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/3.1.404/dotnet-sdk-3.1.404-linux-x64.tar.gz

RUN sudo curl -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet.tar.gz \
    && sudo tar -zxf dotnet.tar.gz -C /home/codespace/.dotnet --skip-old-files \
    && sudo rm dotnet.tar.gz

RUN echo "deb http://security.debian.org/debian-security jessie/updates main" | sudo tee -a /etc/apt/sources.list \
    && sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9D6D8F6BC857C906 \
    && sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50 \
    && sudo apt-get update -y \
    && sudo apt-get install -y --no-install-recommends libssl1.0.0
    
# Enable detection of running in a container
ENV DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps perfomance
    NUGET_XMLDOC_MODE=skip

# Workaround for https://github.com/Microsoft/DockerTools/issues/87. This instructs NuGet to use 4.5 behavior in which
# all errors when attempting to restore a project are ignored and treated as warnings instead. This allows the VS
# tooling to use -nowarn:MSB3202 to ignore issues with the .dcproj project
ENV RestoreUseSkipNonexistentTargets false

# Docker-in-docker setup
COPY .codespaces/docker-in-docker-debian.sh /tmp/library-scripts/
RUN apt-get update \
    # Use Docker script from script library to set things up
    && /bin/bash /tmp/library-scripts/docker-in-docker-debian.sh \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

VOLUME [ "/var/lib/docker" ]

# Setting the ENTRYPOINT to docker-init.sh will start up the Docker Engine 
# inside the container "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]