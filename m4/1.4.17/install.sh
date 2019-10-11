#!/bin/bash
#
# INSTALLATION SCRIPT
#
# 
#
# You might want to modify the first line to specify your own install location.

#set -x

export LUSER="root"
export LGROUP="root"

# Dados para a instalacao do software
NAME=m4
NUMBER_VERSION=1.4.17
VERSION=${NAME}-${NUMBER_VERSION}
FILE=${VERSION}.tar.gz
TOP_DIR=/data/apps/${NAME}
PREFIX=${TOP_DIR}/${NUMBER_VERSION}
DOWNLOAD_LINK="http://ftp.gnu.org/gnu/${NAME}/${FILE}"

# Dados para gerar o module file
MODULE_NAME="${NAME}"
MY_MODULE_VERSION="${NUMBER_VERSION}"
MODULE_TAGS=""
MODULE_MSG=""
MODULE_DOWNLOAD="${DOWNLOAD_LINK}"
MODULE_HOME_PAGE=""

# Onde serao armazenados os arquivos da instalacao
SOURCE_DIR=/data/src/${NAME}/${NUMBER_VERSION}

#
# Create SOURCE_DIR directory
#
if ! test -d "${SOURCE_DIR}"
then
    sudo mkdir -p "${SOURCE_DIR}" || exit 1
    sudo chown -R $LUSER:$LGROUP "${SOURCE_DIR}" || exit 1
fi


#
# Create TOP_DIR/NUMBER_VERSION directory
# 
if ! test -d "${TOP_DIR}/${NUMBER_VERSION}"
then
    sudo mkdir -p "${TOP_DIR}/${NUMBER_VERSION}" || exit 1
    sudo chown -R $LUSER:$LGROUP "${TOP_DIR}/${NUMBER_VERSION}" || exit 1
fi

#
# Download
#
cd "${SOURCE_DIR}" || exit 1
if ! test -d "${VERSION}"
then
    if ! test -f "${FILE}"
    then
        wget "${DOWNLOAD_LINK}" || exit 1
    fi
    tar -xvf "${FILE}" || exit 1
fi

#
# Load modules
#
source /etc/profile.d/modules.sh	|| exit 1
module load gmp/5.1.3	|| exit 1
module load mpfr/3.1.3	|| exit 1
module load mpc/1.0.3	|| exit 1
module load isl/0.12.2	|| exit 1
module load cloog/0.18.1	|| exit 1
module load gcc/4.8.3	|| exit 1
module load autoconf/2.68	|| exit 1
module load gawk/4.1.1	|| exit 13

#
# Install
#
cd "${SOURCE_DIR}/${VERSION}" || exit 1
./configure --prefix=${PREFIX} || exit 1
make -j8 || exit 1
#make check || exit 1
sudo make install || exit 1

echo "=============================================="
echo ""
echo ""
echo " INSTALACAO DO ${VERSION} FEITA COM SUCESSO"
echo ""
echo ""
echo "=============================================="

sleep 2

#
# Cria o modulefile
#

# #Criação antiga de modufiles
# SELF_SCRIPT_DIR="$(dirname "$0")" || exit 1 
# #Le o diretorio onde se encontra genmod.sh
# GENMOD_DIR=$1
# if [ -n "${GENMOD_DIR}" ]
# then
# 	echo "GENMOD_DIR: ${GENMOD_DIR}"
# 	$GENMOD_DIR/genmod.sh -o "${SELF_SCRIPT_DIR}" -n "${MODULE_NAME}" -v "${MY_MODULE_VERSION}" -t "${MODULE_TAGS}" -m "${MODULE_MSG}" -d "${MODULE_DOWNLOAD}" -u "${MODULE_HOME_PAGE}"
# fi

#Criação nova de modufiles
/data/svn/softwares/trunk/utils/genmod.sh -n "${MODULE_NAME}" -v "${MY_MODULE_VERSION}"

exit 0
