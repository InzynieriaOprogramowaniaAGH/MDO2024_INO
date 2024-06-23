FROM jenkins/jenkins:2.452.2-jdk17
USER root

# Instalacja dodatkowych pakietów wymaganych do instalacji docker-compose
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    gnupg \
    sudo

# Pobranie klucza GPG dla Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Dodanie repozytorium Docker do źródeł APT
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list

# Instalacja docker-ce-cli
RUN apt-get update && apt-get install -y docker-ce-cli

# Instalacja docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Przywrócenie użytkownika jenkins jako domyślnego użytkownika
USER jenkins

# Instalacja pluginów Jenkinsa
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
