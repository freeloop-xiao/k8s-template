#!/bin/bash


sed -i "s#'com.ab:ab-web-starter:0.0.1-SNAPSHOT'#fileTree(dir: 'lib',includes: ['*.jar'])#g" build.gradle


#    implementation fileTree(dir: 'lib',includes: ['*.jar'])
sed -i "s#123#456#g" test.sh

