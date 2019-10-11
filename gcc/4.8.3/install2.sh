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
NAME=gcc
NUMBER_VERSION=4.8.3
VERSION=${NAME}-${NUMBER_VERSION}
FILE=${VERSION}.tar.bz2
TOP_DIR=/data/apps/${NAME}
PREFIX=${TOP_DIR}/${NUMBER_VERSION}
DOWNLOAD_LINK="http://www.netgull.com/gcc/releases/${VERSION}/${FILE}"

# Onde serao armazenados os arquivos da instalacao
SOURCE_DIR=/data/src

# Facilita carregar arquivo de configuracao para outras instacoes
THIS_SCRIPT_DIR="$(dirname "$0")" || exit 1

# Dados para gerar o module file
MODULE_NAME="${NAME}"
MY_MODULE_VERSION="${NUMBER_VERSION}"
MODULE_TAGS=""
MODULE_MSG=""
MODULE_DOWNLOAD="${DOWNLOAD_LINK}"
MODULE_HOME_PAGE=""

#
# Create TOP_DIR directory
#
if ! test -d "${TOP_DIR}"
then
    sudo mkdir "${TOP_DIR}" || exit 1
    sudo chown -R $LUSER:$LGROUP "${TOP_DIR}" || exit 1
fi

#
# Create TOP_DIR/NUMBER_VERSION directory
# 
cd "${TOP_DIR}" || exit 1
if ! test -d "${TOP_DIR}/${NUMBER_VERSION}"
then
    sudo mkdir "${TOP_DIR}/${NUMBER_VERSION}" || exit 1
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
        wget "${DOWNLOAD_LINK}" --no-check-certificate || exit 1
    fi
    tar -xvf "${FILE}" || exit 1
fi

#
# Load modules
#
source  /etc/profile.d/modules.sh	|| exit 1
module load gmp/5.1.3
module load mpfr/3.1.3
module load mpc/1.0.3
module load isl/0.12.2
module load cloog/0.18.1
#gmp/5.1.3 mpfr/3.1.3 mpc/1.0.3 cloog/0.18.1 [ isl/0.12.2 ou isl/0.15  ou  isl/0.16.1 ] 
GMP_PREFIX=/data/apps/gmp/5.1.3
MPFR_PREFIX=/data/apps/mpfr/3.1.3
MPC_PREFIX=/data/apps/mpc/1.0.3
ISL_PREFIX=/data/apps/isl/0.12.2
CLOOG_PREFIX=/data/apps/cloog/0.18.1
#
# Install
#
cd "${SOURCE_DIR}/${VERSION}" || exit 1
./configure --prefix=${PREFIX} --enable-host-shared --disable-bootstrap --enable-libgomp --enable-lto --enable-threads=posix --enable-tls --enable-checking=release --enable-languages=c,c++,objc,obj-c++,fortran --with-gmp=${GMP_PREFIX} --with-mpfr=${MPFR_PREFIX} --with-mpc=${MPC_PREFIX} --with-cloog=${CLOOG_PREFIX} --with-isl=${ISL_PREFIX} --disable-isl-version-check

make -j4 || exit 1
#make check || exit 1
make install || exit 1

echo "=============================================="
echo ""
echo ""
echo " INSTALACAO DO ${VERSION} FEITA COM SUCESSO"
echo ""
echo ""
echo "=============================================="

sleep 1

#
# Cria o modulefile
#
SELF_SCRIPT_DIR="$(dirname "$0")" || exit 1 
#Le o diretorio onde se encontra genmod.sh
GENMOD_DIR=$1
if [ -n "${GENMOD_DIR}" ]
then
	echo "GENMOD_DIR: ${GENMOD_DIR}"
	$GENMOD_DIR/genmod.sh -o "${SELF_SCRIPT_DIR}" -n "${MODULE_NAME}" -v "${MY_MODULE_VERSION}" -t "${MODULE_TAGS}" -m "${MODULE_MSG}" -d "${MODULE_DOWNLOAD}" -u "${MODULE_HOME_PAGE}"
fi

exit 0
