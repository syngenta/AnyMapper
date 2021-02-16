#!/bin/sh

set_version() {
  # Geting version from tag
  version=`git describe --abbrev=0 --tags`
  # Change version in podspec
  sed -i ".bak" "s/  s.version          = .*/  s.version          = '"$version"'/" AnyMapper.podspec
}

reset_podspec() {
  # Back to primary
  git checkout AnyMapper.podspec
}

if [ "$1" == "lint" ]; then
  set_version
  pod lib lint
  reset_podspec
elif [ "$1" == "push" ]; then
  set_version
  pod trunk push AnyMapper.podspec
  reset_podspec
else
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  NC='\033[0m' # No Color
  echo "${YELLOW}repo.sh script${NC}"
  echo "${GREEN}lint${NC} — run pod lib lint (./repo.sh lint)"
  echo "${GREEN}push${NC} — push pod to cocoapods (./repo.sh push)"
fi
