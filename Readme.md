# OpenDDS docker workspace with Travis CI build artifact

This is used specifically for downloading the artifacts built from https://travis-ci.org/huangminghuang/OpenDDS and replicating the Travis worker environment for runing OpenDDS tests.

It only supports the cmake branch for the repo https://github.com/huangminghuang/OpenDDS.git.


###Usage

A build artifact is identified by ${TRAVIS\_BRANCH}-${MAXTRIX\_NAME}-${TRAVIS\_BUILD\_NUMBER}. The following exmaple download the artifacts built from build #109.12 (i.e. cmake branch, Release, 109) and then run bash in docker container.

```bash
docker pull huangminghuang/opendds-travis-build
docker run -it huangminghuang/opendds-travis-build cmake-Release-109
```