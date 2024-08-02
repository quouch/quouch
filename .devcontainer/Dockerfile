FROM mcr.microsoft.com/devcontainers/universal:2-linux

# Install Rails
RUN /usr/local/rvm/bin/rvm fix-permissions
RUN /usr/local/rvm/bin/rvm install 3.1.2
RUN /usr/local/rvm/bin/rvm use 3.1.2 --default
#RUN su vscode -c "gem install rails webdrivers"
#RUN su vscode -c "/usr/local/rvm/bin/rvm fix-permissions"
#RUN su vscode -c "/usr/local/rvm/bin/rvm install 3.1.2 && /usr/local/rvm/bin/rvm use 3.1.2 --default"

# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service
# The value is a comma-separated list of allowed domains 
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.preview.app.github.dev,.app.github.dev"
ENV RAILS_ENV="development"

# Install PostgreSQL client
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends postgresql-client

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install additional gems.
# RUN su vscode -c "gem install <your-gem-names-here>"

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
