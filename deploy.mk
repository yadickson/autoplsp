all:
	curl -s https://raw.githubusercontent.com/yadickson/private-key.gpg/1.0.0/private-key.gpg | gpg --import
	mvn versions:set -DnewVersion=${TRAVIS_TAG}
	mvn clean deploy -Dmaven.test.skip=true -P release --settings deploy.xml
