#!/bin/bash
git clone git@github.com:idbi/id-pos.git

git clone git@github.com:idbi/id-backend.git
cd id-backend
git pull
git checkout production81
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1uWv1IxXni2khq-pCy6s8VXefb7meZAqs' -O 'vendor.zip'
unzip vendor.zip
cd ..

git clone git@github.com:idbi/id-laradock.git
cd id-laradock 
git pull
git checkout lite
cd ..

