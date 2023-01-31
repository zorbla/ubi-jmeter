# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile

MAINTAINER r@zorbla.de

ARG UBI_VERSION="8"

# unfortunately, the openjdk-xx-runtime:latest image cannot be used because:
# 1) I want to update but the image has no dnf
# 2) Some goofy permissions (did not elaborate on that)
#
# therefore, I'm using the plain UBI and install java myself
#
FROM ubi${UBI_VERSION}:latest

ARG JDK_VERSION="17"
ARG JMETER_VERSION="5.5"

ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_CUSTOM_PLUGINS_FOLDER /plugins
ENV JMETER_BIN	${JMETER_HOME}/bin

# Update system and install jdk & unzip & jmeter
ARG TZ="Europe/Berlin"
ENV TZ ${TZ}
RUN mkdir -p /opt && dnf -y update && dnf -y install java-${JDK_VERSION}-openjdk-headless

#
# ATTENTION: Before building, make sure jmeter is there
#
COPY apache-jmeter-${JMETER_VERSION}/ /opt/apache-jmeter-${JMETER_VERSION}/

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

COPY entrypoint.sh /
WORKDIR	/tmp

ENTRYPOINT ["/entrypoint.sh"]
