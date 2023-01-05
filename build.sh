#!/bin/bash

UBI_VERSION=${UBI_VERSION:-"8"}
JDK_VERSION=${JDK_VERSION:-"17"}
JMETER_VERSION=${JMETER_VERSION:-"5.5"}
IMAGE_TIMEZONE=${IMAGE_TIMEZONE:-"Europe/Berlin"}

JMETER_URL=https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
JMETER_SUM_URL=https://www.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz.sha512

if [ "$1" != "" ] ; then
    ECHO=":"
else
    ECHO="echo"
fi

${ECHO} "********************************************************************"
${ECHO} "* Building docker image for Apache JMeter ${JMETER_VERSION}"
${ECHO} "*   based on"
${ECHO} "* Red Hat ${UBI_VERSION} Universal Base Image (UBI)"
${ECHO} "*   with"
${ECHO} "* OpenJDK ${JDK_VERSION} installed."
${ECHO} "********************************************************************"

${ECHO} -e "\nfetching jmeter..."
curl -s -L ${JMETER_URL} -o  /tmp/apache-jmeter-${JMETER_VERSION}.tgz
curl -s -L ${JMETER_SUM_URL} -o  /tmp/apache-jmeter-${JMETER_VERSION}.tgz.sha512
cd /tmp
SHARESULT=`sha512sum -c apache-jmeter-${JMETER_VERSION}.tgz.sha512`
if [ "$?" != "0" ] ; then
    exit 1
fi
${ECHO} ${SHARESULT}
cd - > /dev/null
tar -xzf /tmp/apache-jmeter-${JMETER_VERSION}.tgz


# Example build line
NOW=`date +%Y%m%d%H%M%S`
${ECHO} -e "\nbuilding image ${UBI_VERSION}-${JMETER_VERSION}-${NOW} ..."

podman build \
       --build-arg UBI_VERSION=${UBI_VERSION} \
       --build-arg JDK_VERSION=${JDK_VERSION} \
       --build-arg JMETER_VERSION=${JMETER_VERSION} \
       --build-arg TZ=${IMAGE_TIMEZONE} \
       -t "zorbla/ubi-jmeter:${UBI_VERSION}-${JMETER_VERSION}-${NOW}" . > podman-${UBI_VERSION}-${JMETER_VERSION}-${NOW}.log
RESULT=$?
HASH=`tail -1 podman-${UBI_VERSION}-${JMETER_VERSION}-${NOW}.log`
PREVHASH=`cat ${UBI_VERSION}-${JMETER_VERSION}-latest.hash 2>&1`

if [ "${RESULT}" != "0" ] ; then
    ${ECHO} "Error on podman build for image ${UBI_VERSION}-${JMETER_VERSION}-${NOW}"
    exit 1
else
    rm podman-${UBI_VERSION}-${JMETER_VERSION}-${NOW}.log
fi


if [ "${HASH}" == "${PREVHASH}" ] ; then
    ${ECHO} "image has not changed"
    ${ECHO} "removing current tag"
    RMRESULT=`podman image rm zorbla/ubi-jmeter:${UBI_VERSION}-${JMETER_VERSION}-${NOW}`
    ${ECHO} ${RMRESULT}
else
    ${ECHO} "image has changed"
    ${ECHO} "creating PUSH script..."
    echo "podman login -u zorbla -p dckr_pat_n2oFP4DHi20DwfrSmRtTun-A-GQ https://docker.io" > push-${NOW}.sh
    echo "podman push zorbla/ubi-jmeter:${UBI_VERSION}-${JMETER_VERSION}-${NOW}" >> push-${NOW}.sh
    echo "podman tag  zorbla/ubi-jmeter:${UBI_VERSION}-${JMETER_VERSION}-${NOW} zorbla/ubi-jmeter:${UBI_VERSION}-${JMETER_VERSION}" >> push-${NOW}.sh
    echo "podman push zorbla/ubi-jmeter:${UBI_VERSION}-${JMETER_VERSION}" >> push-${NOW}.sh
    echo "podman tag  zorbla/ubi-jmeter:${UBI_VERSION}-${JMETER_VERSION}-${NOW} zorbla/ubi-jmeter:${UBI_VERSION}-${JMETER_VERSION}-latest" >> push-${NOW}.sh
    echo "podman push zorbla/ubi-jmeter:${UBI_VERSION}-${JMETER_VERSION}-latest" >> push-${NOW}.sh
    echo "echo ${HASH} > ${UBI_VERSION}-${JMETER_VERSION}-latest.hash"  >> push-${NOW}.sh

    ${ECHO} -e "\n=> push-${NOW}.sh"
    chmod a+x push-${NOW}.sh
    ${ECHO} "pushing..."
    . ./push-${NOW}.sh
    if [ "$?" == "0" ] ; then
	rm ./push-${NOW}.sh
    fi
fi


