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

# Adds modules2.0 to available modules
MODULE_BASE="/short/${PROJECT}/${USER}/modules2.0"

MODULEPATH=${MODULE_BASE}/core:$MODULEPATH

if [ -n "${INTEL_FC_VERSION}" -o -n "${INTEL_CC_VERSION}" ]; then
    CONTEXT=compiler/intel
    MODULEPATH=${MODULE_BASE}/${CONTEXT}:$MODULEPATH
fi

if [ -n "${GCC_VERSION}" ]; then
    CONTEXT=compiler/gcc${GCC_VERSION%.*}
    MODULEPATH=${MODULE_BASE}/${CONTEXT}:$MODULEPATH
fi

if [ -n "${INTEL_MPI_VERSION}" ]; then
    CONTEXT=${CONTEXT}/mpi/intel
    MODULEPATH=${MODULE_BASE}/${CONTEXT}:$MODULEPATH
fi

if [ -n "${OPENMPI_VERSION}" ]; then
    CONTEXT=${CONTEXT}/mpi/openmpi${OPEN_MPI_VERSION%.*}
    MODULEPATH=${MODULE_BASE}/${CONTEXT}:$MODULEPATH
fi

/opt/Modules/$MODULE_VERSION/bin/modulecmd bash $*
