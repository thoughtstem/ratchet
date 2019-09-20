#Exit if commands fail.  Fail fast!
set -e

echo "**************************"
echo "INSTALLING RACKET CHIPMUNK"
echo "**************************"
raco pkg install --deps search-auto --no-setup https://github.com/thoughtstem/racket-chipmunk.git#$TRAVIS_BRANCH
raco setup --no-docs --fail-fast racket-chipmunk 

echo "**************************"
echo "INSTALLING RATCHET"
echo "**************************"
raco pkg install --deps search-auto --no-setup https://github.com/thoughtstem/ratchet.git#$TRAVIS_BRANCH
raco setup --no-docs --fail-fast ratchet


echo "**************************"
echo "cd $TRAVIS_BUILD_DIR"
echo "**************************"
cd $TRAVIS_BUILD_DIR

echo "**************************"
echo "CLONING TS-Kata-Collections"
echo "**************************"
git clone -b $TRAVIS_BRANCH https://github.com/thoughtstem/TS-Kata-Collections.git

echo "**************************"
echo "CLONING TS-Languages"
echo "**************************"
git clone -b $TRAVIS_BRANCH https://github.com/thoughtstem/TS-Languages.git

echo "**************************"
echo "INSTALLING ts-kata-util"
echo "**************************"
cd $TRAVIS_BUILD_DIR/TS-Kata-Collections/ts-kata-util && raco pkg install --deps search-auto --no-setup   
raco setup --no-docs --fail-fast ts-kata-util

echo "**************************"
echo "INSTALLING GAME-ENGINE-*"
echo "**************************"
sudo apt-get update
sudo apt-get install libportaudio2
raco pkg install --deps search-auto --no-setup https://github.com/thoughtstem/game-engine.git#$TRAVIS_BRANCH
raco setup --no-docs --fail-fast game-engine
raco pkg install --deps search-auto --no-setup https://github.com/thoughtstem/game-engine-rpg.git#$TRAVIS_BRANCH
raco setup --no-docs --fail-fast game-engine-rpg
raco pkg install --deps search-auto --no-setup https://github.com/thoughtstem/game-engine-demos.git?path=game-engine-demos-common#$TRAVIS_BRANCH
raco setup --no-docs --fail-fast game-engine-demos-common

echo "**************************"
echo "INSTALLING TS-Languages"
echo "**************************"
cd $TRAVIS_BUILD_DIR/TS-Languages && raco install-all-here --no-docs

echo "**************************"
echo "TESTING TS-Languages"
echo "**************************"
cd $TRAVIS_BUILD_DIR/TS-Languages && raco test-all-here 

echo "**************************"
echo "INSTALLING TS-Kata-Collections"
echo "**************************"
cd $TRAVIS_BUILD_DIR/TS-Kata-Collections && raco install-all-here

