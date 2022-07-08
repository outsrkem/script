#!/bin/bash

config=`cat ./env`
templ=`cat ./deploy-myapp.yaml`
printf "$config\ncat << EOF\n$templ\nEOF" | bash > ./aaaaaaaaaaa.yml
