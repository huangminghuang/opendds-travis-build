#!/usr/bin/env bash

me=`realpath "$0"`

set -e

artifact_name=$1

if [ -z "$artifact_name" ]; then
  echo artifact name not specified
  exit 1
fi

mkdir -p $HOME/tmp
cd $HOME/tmp

curl http://com.ociweb.opendds.s3-website-us-east-1.amazonaws.com/artifacts/${artifact_name}.tar.gz | tar zx

OPENDDS_SOURCE_DIR=`grep CMAKE_HOME_DIRECTORY build/CMakeCache.txt | sed 's/.*=//'`
ACE_TAO_SOURCE_DIR=`grep ACE_TAO_SOURCE_DIR build/CMakeCache.txt | sed 's/.*=//'`
OpenDDS_BINARY_DIR=`grep OpenDDS_BINARY_DIR build/CMakeCache.txt | sed 's/.*=//'`

git clone `cat $HOME/tmp/build/OpenDDS.clone_loc` $OPENDDS_SOURCE_DIR
git clone --recursive --depth=100 `cat $HOME/tmp/build/ACE_TAO.clone_loc` $ACE_TAO_SOURCE_DIR

mv $HOME/tmp/build $OPENDDS_SOURCE_DIR

git --git-dir=$OPENDDS_SOURCE_DIR/.git checkout --quiet `cat $OpenDDS_BINARY_DIR/OpenDDS.commit`
git --git-dir=$ACE_TAO_SOURCE_DIR/.git checkout --quiet `cat $OpenDDS_BINARY_DIR/ACE_TAO.commit`

# avoid environment setup for subsequent restarting the container
cat <<EOF > "${me}"
#!/usr/bin/env bash
cd $OpenDDS_BINARY_DIR
bash
EOF

cd $OpenDDS_BINARY_DIR
bash

