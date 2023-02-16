#!/usr/bin/env bash
set -e

export toolName='simnibs'
export toolVersion='4.0.0' 
# Don't forget to update version change in README.md!!!!!

if [ "$1" != "" ]; then
    echo "Entering Debug mode"
    export debug=$1
fi

source ../main_setup.sh

neurodocker generate ${neurodocker_buildMode} \
   --base-image ubuntu:22.04 \
   --pkg-manager apt \
   --env DEBIAN_FRONTEND=noninteractive \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir ${mountPointList}" \
   --install curl ca-certificates python3-pyqt5 python3-opencv \
   --run="curl -L --retry 5 https://github.com/simnibs/simnibs/releases/download/v${toolVersion}/simnibs_installer_linux.tar.gz | tar -xz -C /opt/ \
     &&	/opt/simnibs_installer/install -s" \
   --copy README.md /README.md \
  > ${toolName}_${toolVersion}.Dockerfile

if [ "$1" != "" ]; then
   ./../main_build.sh
fi
