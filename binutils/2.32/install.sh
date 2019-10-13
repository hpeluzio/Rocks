#!/bin/bash

export LUSER="root"
export LGROUP="root"

###############################################################
# Dados para a instalacao do software
NAME=binutils
VERSION=2.32
FILE=binutils-2.32.tar.gz #NOME DO ARQUIVO QUE SERÁ BAIXADO
EXTRACT_FOLDER=binutils-2.32 #PASTA CRIADA QUANDO O ARQUIVO É EXTRAIDO
DOWNLOAD_LINK="http://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.gz"

###############################################################
DIR_INSTALL=/data/apps/${NAME}/${VERSION} 
SOURCE_DIR=/data/src/${NAME}/${VERSION}

###############################################################
# Create SOURCE_DIR directory
if ! test -d "DIR_INSTALL"
then
    mkdir -p "${SOURCE_DIR}" || exit 1
    chown -R $LUSER:$LGROUP "${SOURCE_DIR}" || exit 1
fi

###############################################################
# Create DIR_INSTALL directory
if ! test -d "${DIR_INSTALL}"
then
    mkdir -p "${DIR_INSTALL}" || exit 1
    chown -R $LUSER:$LGROUP "${DIR_INSTALL}" || exit 1
fi

###############################################################
# Download
cd "${SOURCE_DIR}" || exit 1
if ! test -d "${FILE}" #Verificando se o arquivo já foi baixado
then
    if ! test -f "${FILE}"
    then
        wget "${DOWNLOAD_LINK}" || exit 1
    fi
    #Descompatando Arquivo
    #unzip ${FILE}   || exit 1      #Descompactador zip files
    tar -xvf "${FILE}" || exit 1   #Descompactador tar.gz files
fi

###############################################################
# Load modules
source /etc/profile.d/modules.sh	|| exit 1
module load autoconf/2.69	|| exit 1
module load automake/1.15	|| exit 1
module load m4/1.4.17	|| exit 1
module load libtool/2.4.6	|| exit 1
module load gmp/5.1.3	|| exit 1
module load mpfr/3.1.3	|| exit 1
module load mpc/1.0.3	|| exit 1
module load isl/0.12.2	|| exit 1
module load cloog/0.18.1	|| exit 1
module load gawk/4.1.1	|| exit 1
module load m4/1.4.17	|| exit 1
module load gcc/4.8.3	|| exit 1

###############################################################
# Install
cd "${SOURCE_DIR}/${EXTRACT_FOLDER}"    || exit 1

if ! test -d "${SOURCE_DIR}/${EXTRACT_FOLDER}/build"
then
    mkdir -p "${SOURCE_DIR}/${EXTRACT_FOLDER}/build" || exit 1
    chown -R $LUSER:$LGROUP "${SOURCE_DIR}/${EXTRACT_FOLDER}/build" || exit 1
fi

cd ${SOURCE_DIR}/${EXTRACT_FOLDER}/build

../configure --prefix=${DIR_INSTALL}       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib         || exit 1

make tooldir=${DIR_INSTALL}             || exit 1
make tooldir=${DIR_INSTALL} install     || exit 1
#./configure --prefix=${DIR_INSTALL}     || exit 1
#make -j8                                || exit 1
#make install                            || exit 1

###############################################################
echo "=============================================="
echo ""
echo " INSTALACAO DO ${VERSION} FEITA COM SUCESSO"
echo ""
echo "=============================================="

sleep 2

###############################################################
#Criação modulefile 
/data/svn/softwares/trunk/utils/genmod.sh -n "${NAME}" -v "${VERSION}"

exit 0
