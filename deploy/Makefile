all:
	gpg --import deploy/private-key.gpg
	mvn versions:set -DnewVersion=${TRAVIS_TAG}
	mvn clean deploy -Dmaven.test.skip=true -P release --settings deploy/settings.xml
