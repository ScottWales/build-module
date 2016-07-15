#!/bin/bash
#  Copyright 2016 ARC Centre of Excellence for Climate Systems Science
#
#  \author  Scott Wales <scott.wales@unimelb.edu.au>
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

set -eux

function create_module {
    MODULEFILE="${MODULE_BASE}/${CONTEXT}/${NAME}/${VERSION}"

    if [ ! -f "${MODULEFILE}" ]; then
        if [ ! -d "$(dirname "${MODULEFILE}")" ]; then
            mkdir -p "$(dirname "${MODULEFILE}")"
        fi

    cat > "${MODULEFILE}" << EOF
#%Module1.0
# vim: filetype=tcl
set name         "${NAME}"
set version      "${VERSION}"
set source       "${SOURCE}"
set prefix       "${INSTALLDIR}"
set description  "${DESCRIPTION}"
set website      "${WEBSITE}"

set installed_by "$(getent passwd $USER | cut -d ":" -f 5)"
set install_date "$(date --rfc-3339=date)"

# Set paths
source ${MODULE_BASE}/include/common
EOF

    if [ ${#USE_DEPENDS[@]} -gt 0 ]; then
        for module in ${USE_DEPENDS[@]}; do
            echo "dependency ${module}" >> "${MODULEFILE}"
        done
    fi

    fi
}

# Base directory for applications
APP_BASE="/short/${PROJECT}/${USER}/apps"

# Base directory for modules
MODULE_BASE="/short/${PROJECT}/${USER}/modules2.0"

module purge

# Check modules aren't being loaded in .bashrc
if [ -n "$(bash -c 'echo $LOADEDMODULES')" ]; then
    echo "ERROR: Unable to remove modules"    
    echo "       Please make sure modules aren't loaded in ~/.bashrc"
    echo
    bash -c 'module list -l'
    exit 1
fi

CONFIGFILE="$(readlink -f $1)"
if [ ! -f "${CONFIGFILE}" ]; then
    echo "ERROR: Config '${CONFIGFILE}' not found"
    exit 1
fi

INSTALL_VERSION=$(basename "${CONFIGFILE}")
NAME=$(basename $(dirname "${CONFIGFILE}"))

INSTALLDIR="${APP_BASE}/${NAME}/${INSTALL_VERSION}"
if [ -d "${INSTALLDIR}" ]; then
    echo "ERROR: ${NAME}/${INSTALL_VERSION} already installed"
fi

source "${CONFIGFILE}"

# Create a temporary directory for the build
#BUILDDIR=$(mktemp --directory)
BUILDDIR=/short/w35/saw562/tmp/tmp.n2TLmWS1jz
pushd "${BUILDDIR}"

for module in ${BUILD_DEPENDS[@]}; do
    module load "${module}"
done

echo "Downloading ${NAME}/${INSTALL_VERSION}"
#download

echo "Building ${NAME}/${INSTALL_VERSION}"
#build

echo "Testing ${NAME}/${INSTALL_VERSION}"
#check

echo "Installing ${NAME}/${INSTALL_VERSION}"
#install

echo "Creating module "${CONTEXT}/${NAME}/${VERSION}
create_module

popd
#rm -r "${BUILDDIR}"
echo ${BUILDDIR}

