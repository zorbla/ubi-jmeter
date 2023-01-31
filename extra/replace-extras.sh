#!/bin/bash

JMETER=$1

#
# batik
#
VERSION="1.16"
for NAME in anim awt-util bridge codec constants css dom ext gvt i18n parser script shared-resources svg-dom svggen transcoder util xml ; do
    curl -s -O https://repo1.maven.org/maven2/org/apache/xmlgraphics/batik-${NAME}/${VERSION}/batik-${NAME}-${VERSION}.jar
    curl -s -O https://repo1.maven.org/maven2/org/apache/xmlgraphics/batik-${NAME}/${VERSION}/batik-${NAME}-${VERSION}.jar.sha512
    echo " batik-${NAME}-${VERSION}.jar" >> batik-${NAME}-${VERSION}.jar.sha512
    sha512sum -c batik-${NAME}-${VERSION}.jar.sha512 2>&1
    if [ "$?" != "0" ] ; then
	echo "Checksum error for batik-${NAME}-${VERSION}.jar"
	exit
    fi
    rm -f batik-${NAME}-${VERSION}.jar.sha512
    rm ../apache-jmeter-${JMETER}/lib/batik-${NAME}-*.jar
    cp batik-${NAME}-${VERSION}.jar ../apache-jmeter-${JMETER}/lib/
    # TODO: extract license
    mv ../apache-jmeter-${JMETER}/licenses/batik-${NAME}-*.jar ../apache-jmeter-${JMETER}/licenses/batik-${NAME}-${VERSION}.jar
    cat ../apache-jmeter-${JMETER}/LICENSE | sed s/"batik-${NAME}:.*$"/batik-${NAME}:${VERSION}/ > ../apache-jmeter-${JMETER}/LICENSE.new
    mv ../apache-jmeter-${JMETER}/LICENSE.new ../apache-jmeter-${JMETER}/LICENSE
done

#
# apache commons
#
declare -A ACVERSION
ACVERSION[text]="1.10.0"

curl -s -O https://dlcdn.apache.org/commons/KEYS
gpg -q --import KEYS
rm -f KEYS

for NAME in text ; do
    echo -e "\ncommons-${NAME}-${ACVERSION[${NAME}]}\n"
    curl -s -O https://repo1.maven.org/maven2/org/apache/commons/commons-${NAME}/${ACVERSION[${NAME}]}/commons-${NAME}-${ACVERSION[${NAME}]}.jar
    curl -s -O https://repo1.maven.org/maven2/org/apache/commons/commons-${NAME}/${ACVERSION[${NAME}]}/commons-${NAME}-${ACVERSION[${NAME}]}.jar.asc
    gpg --verify commons-${NAME}-${ACVERSION[${NAME}]}.jar.asc commons-${NAME}-${ACVERSION[${NAME}]}.jar 2>&1
    if [ "$?" != "0" ] ; then
	echo "Checksum error for commons-${NAME}-${ACVERSION[${NAME}]}.jar"
	exit
    fi
    rm -f commons-${NAME}-${ACVERSION[${NAME}]}.jar.asc
    rm ../apache-jmeter-${JMETER}/lib/commons-${NAME}-*.jar
    cp commons-${NAME}-${ACVERSION[${NAME}]}.jar ../apache-jmeter-${JMETER}/lib/
    # TODO: extract license
    mv ../apache-jmeter-${JMETER}/licenses/commons-${NAME}-*.jar ../apache-jmeter-${JMETER}/licenses/commons-${NAME}-${ACVERSION[${NAME}]}.jar
    cat ../apache-jmeter-${JMETER}/LICENSE | sed s/"commons-${NAME}:.*$"/"commons-${NAME}:${ACVERSION[${NAME}]}"/ > ../apache-jmeter-${JMETER}/LICENSE.new
    mv ../apache-jmeter-${JMETER}/LICENSE.new ../apache-jmeter-${JMETER}/LICENSE
done


#
# apache tika
#
declare -A TVERSION
TVERSION[core]="1.28.5"
TVERSION[parsers]="1.28.5"

curl -s -O https://raw.githubusercontent.com/apache/tika/main/KEYS
gpg -q --import KEYS
rm -f KEYS

for NAME in core parsers ; do
    echo -e "\ntika-${NAME}-${TVERSION[${NAME}]}\n"
    curl -s -O https://repo1.maven.org/maven2/org/apache/tika/tika-${NAME}/${TVERSION[${NAME}]}/tika-${NAME}-${TVERSION[${NAME}]}.jar
    curl -s -O https://repo1.maven.org/maven2/org/apache/tika/tika-${NAME}/${TVERSION[${NAME}]}/tika-${NAME}-${TVERSION[${NAME}]}.jar.asc
    gpg --verify tika-${NAME}-${TVERSION[${NAME}]}.jar.asc tika-${NAME}-${TVERSION[${NAME}]}.jar 2>&1
    if [ "$?" != "0" ] ; then
	echo "Checksum error for tika-${NAME}-${TVERSION[${NAME}]}.jar"
	exit
    fi
    rm -f tika-${NAME}-${TVERSION[${NAME}]}.jar.asc
    rm ../apache-jmeter-${JMETER}/lib/tika-${NAME}-*.jar
    cp tika-${NAME}-${TVERSION[${NAME}]}.jar ../apache-jmeter-${JMETER}/lib/
    # TODO: extract license
    mv ../apache-jmeter-${JMETER}/licenses/tika-${NAME}-*.jar ../apache-jmeter-${JMETER}/licenses/tika-${NAME}-${TVERSION[${NAME}]}.jar
    cat ../apache-jmeter-${JMETER}/LICENSE | sed s/"tika-${NAME}:.*$"/"tika-${NAME}:${TVERSION[${NAME}]}"/ > ../apache-jmeter-${JMETER}/LICENSE.new
    mv ../apache-jmeter-${JMETER}/LICENSE.new ../apache-jmeter-${JMETER}/LICENSE
done



#
# ("apache") commons net
#
CVERSION[net]="3.9.0"

#curl -s -O https://dlcdn.apache.org/commons/KEYS
#gpg -q --import KEYS
#rm -f KEYS
for NAME in net ; do
    echo -e "\ncommons-${NAME}-${CVERSION[${NAME}]}\n"
    curl -s -O https://repo1.maven.org/maven2/commons-${NAME}/commons-${NAME}/${CVERSION[${NAME}]}/commons-${NAME}-${CVERSION[${NAME}]}.jar
    curl -s -O https://repo1.maven.org/maven2/commons-${NAME}/commons-${NAME}/${CVERSION[${NAME}]}/commons-${NAME}-${CVERSION[${NAME}]}.jar.asc
    gpg --verify commons-${NAME}-${CVERSION[${NAME}]}.jar.asc commons-${NAME}-${CVERSION[${NAME}]}.jar 2>&1
    if [ "$?" != "0" ] ; then
	echo "Checksum error for commons-${NAME}-${CVERSION}.jar"
	exit
    fi
    rm -f commons-${NAME}-${CVERSION[${NAME}]}.jar.asc
    rm ../apache-jmeter-${JMETER}/lib/commons-${NAME}-*.jar
    cp commons-${NAME}-${CVERSION[${NAME}]}.jar ../apache-jmeter-${JMETER}/lib/
    # TODO: extract license
    mv ../apache-jmeter-${JMETER}/licenses/commons-${NAME}-*.jar ../apache-jmeter-${JMETER}/licenses/commons-${NAME}-${CVERSION[${NAME}]}.jar
    cat ../apache-jmeter-${JMETER}/LICENSE | sed s/"commons-${NAME}:.*$"/"commons-${NAME}:${CVERSION[${NAME}]}"/ > ../apache-jmeter-${JMETER}/LICENSE.new
    mv ../apache-jmeter-${JMETER}/LICENSE.new ../apache-jmeter-${JMETER}/LICENSE
done

#
# jsoup
#
VERSION="1.15.3"

#curl -s -O https://dlcdn.apache.org/commons/KEYS
#gpg -q --import KEYS
#rm -f KEYS

curl -s -O https://repo1.maven.org/maven2/org/jsoup/jsoup/${VERSION}/jsoup-${VERSION}.jar
#curl -s -O https://repo1.maven.org/maven2/org/jsoup/jsoup/${VERSION}/jsoup-${VERSION}.jar.asc
curl -s -O https://repo1.maven.org/maven2/org/jsoup/jsoup/${VERSION}/jsoup-${VERSION}.jar.md5
echo " jsoup-${VERSION}.jar" >> jsoup-${VERSION}.jar.md5
md5sum -c jsoup-${VERSION}.jar.md5 2>&1
#gpg --verify jsoup-${VERSION}.jar.asc jsoup-${VERSION}.jar
if [ "$?" != "0" ] ; then
    echo "Checksum error for jsoup-${VERSION}.jar"
    exit
fi
rm -f jsoup-${VERSION}.jar.md5
rm ../apache-jmeter-${JMETER}/lib/jsoup-*.jar
cp jsoup-${VERSION}.jar ../apache-jmeter-${JMETER}/lib/
# TODO: extract license
mv ../apache-jmeter-${JMETER}/licenses/jsoup-*.jar ../apache-jmeter-${JMETER}/licenses/jsoup-${VERSION}.jar
cat ../apache-jmeter-${JMETER}/LICENSE | sed s/"jsoup:jsoup:.*$"/jsoup:jsoup:${VERSION}/ > ../apache-jmeter-${JMETER}/LICENSE.new
mv ../apache-jmeter-${JMETER}/LICENSE.new ../apache-jmeter-${JMETER}/LICENSE



#
# Jackson
#
VERSION="2.13.5"

curl  -s -O https://raw.githubusercontent.com/FasterXML/jackson/master/KEYS
gpg -q --import KEYS
rm -f KEYS

for NAME in annotations core databind ; do
    curl -s -O https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-${NAME}/${VERSION}/jackson-${NAME}-${VERSION}.jar
    curl -s -O https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-${NAME}/${VERSION}/jackson-${NAME}-${VERSION}.jar.asc
    gpg --verify jackson-${NAME}-${VERSION}.jar.asc jackson-${NAME}-${VERSION}.jar 2>&1
    if [ "$?" != "0" ] ; then
	echo "Checksum error for jackson-${NAME}-${VERSION}.jar"
	exit
    fi
    rm -f jackson-${NAME}-${VERSION}.jar.asc
    rm ../apache-jmeter-${JMETER}/lib/jackson-${NAME}-*.jar
    cp jackson-${NAME}-${VERSION}.jar ../apache-jmeter-${JMETER}/lib/
    # TODO: extract license
    mv ../apache-jmeter-${JMETER}/licenses/jackson-${NAME}-*.jar ../apache-jmeter-${JMETER}/licenses/jackson-${NAME}-${VERSION}.jar
    cat ../apache-jmeter-${JMETER}/LICENSE | sed s/"jackson-${NAME}:.*$"/jackson-${NAME}:${VERSION}/ > ../apache-jmeter-${JMETER}/LICENSE.new
    mv ../apache-jmeter-${JMETER}/LICENSE.new ../apache-jmeter-${JMETER}/LICENSE
done


#
# lets-plot-batik, v3.0.0 matching batik 1.16
#
VERSION="3.0.0"

curl -s -O https://repo1.maven.org/maven2/org/jetbrains/lets-plot/lets-plot-batik/${VERSION}/lets-plot-batik-${VERSION}.jar
curl -s -O https://repo1.maven.org/maven2/org/jetbrains/lets-plot/lets-plot-batik/${VERSION}/lets-plot-batik-${VERSION}.jar.sha512
echo " lets-plot-batik-${VERSION}.jar" >> lets-plot-batik-${VERSION}.jar.sha512
sha512sum -c lets-plot-batik-${VERSION}.jar.sha512 2>&1
if [ "$?" != "0" ] ; then
    echo "Checksum error for lets-plot-batik-${VERSION}.jar"
    exit
fi
rm -f lets-plot-batik-${VERSION}.jar.sha512
rm ../apache-jmeter-${JMETER}/lib/lets-plot-batik-*.jar
cp lets-plot-batik-${VERSION}.jar ../apache-jmeter-${JMETER}/lib/
# TODO: extract license
mv ../apache-jmeter-${JMETER}/licenses/lets-plot-batik-*.jar ../apache-jmeter-${JMETER}/licenses/lets-plot-batik-${VERSION}.jar
cat ../apache-jmeter-${JMETER}/LICENSE | sed s/":lets-plot-batik:.*$"/:lets-plot-batik:${VERSION}/ > ../apache-jmeter-${JMETER}/LICENSE.new
mv ../apache-jmeter-${JMETER}/LICENSE.new ../apache-jmeter-${JMETER}/LICENSE


#
# xstream
#
# Anybody found the KEYS?
#
VERSION=1.4.20
curl -s -O https://repo1.maven.org/maven2/com/thoughtworks/xstream/xstream/${VERSION}/xstream-${VERSION}.jar
curl -s -O https://repo1.maven.org/maven2/com/thoughtworks/xstream/xstream/${VERSION}/xstream-${VERSION}.jar.md5
echo " xstream-${VERSION}.jar" >>  xstream-${VERSION}.jar.md5
md5sum -c xstream-${VERSION}.jar.md5 2>&1
if [ "$?" != "0" ] ; then
    echo "Checksum error for xstream-${VERSION}.jar"
    exit
fi
rm -f xstream-${VERSION}.jar.md5
rm ../apache-jmeter-${JMETER}/lib/xstream-*.jar
cp xstream-${VERSION}.jar ../apache-jmeter-${JMETER}/lib/
# TODO: extract license
mv ../apache-jmeter-${JMETER}/licenses/xstream-*.jar ../apache-jmeter-${JMETER}/licenses/xstream-${VERSION}.jar
cat ../apache-jmeter-${JMETER}/LICENSE | sed s/"xstream:xstream:.*$"/xstream:xstream:${VERSION}/ > ../apache-jmeter-${JMETER}/LICENSE.new
mv ../apache-jmeter-${JMETER}/LICENSE.new ../apache-jmeter-${JMETER}/LICENSE

#
# clean up
#

rm *.jar
