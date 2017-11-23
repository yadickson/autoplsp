all:
	gpg --keyserver hkp://pool.sks-keyservers.net --recv ${MAVEN_GPG_KEY}
	mvn versions:set -DnewVersion=${TRAVIS_TAG}
	mvn clean deploy -P ossrh --settings deploy/settings.xml
