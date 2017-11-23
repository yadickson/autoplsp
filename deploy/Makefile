deploy:
	gpg --keyserver hkp://pool.sks-keyservers.net --recv ${MAVEN_GPG_KEY}
	mvn versions:set -DnewVersion=${TRAVIS_TAG}
	mvn deploy -P release --settings deploy/settings.xml
