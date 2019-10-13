#!/bin/bash

export LUSER="henriq"
export LGROUP="henriq"

###############################################################
# Dados para a instalacao do software
NAME=beagle
VERSION=2.1.2
FILE=master #NOME DO ARQUIVO QUE SERÁ BAIXADO
EXTRACT_FOLDER=beagle-lib-master #PASTA CRIADA QUANDO O ARQUIVO É EXTRAIDO
DOWNLOAD_LINK="http://codeload.github.com/beagle-dev/beagle-lib/zip/master"

###############################################################
DIR_INSTALL=/home/henriq/Documentos/TESTE/apps/${NAME}/${VERSION} 
SOURCE_DIR=/home/henriq/Documentos/TESTE/src/${NAME}/${VERSION}

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
    unzip ${FILE}   || exit 1
    #tar -xvf "${FILE}" || exit 1
fi

# ###############################################################
# # Load modules
# source /etc/profile.d/modules.sh	|| exit 1
# module load autoconf/2.69	|| exit 1
# module load automake/1.15	|| exit 1
# module load m4/1.4.17	|| exit 1
# module load libtool/2.4.6	|| exit 1
# module load gmp/5.1.3	|| exit 1
# module load mpfr/3.1.3	|| exit 1
# module load mpc/1.0.3	|| exit 1
# module load isl/0.12.2	|| exit 1
# module load cloog/0.18.1	|| exit 1
# module load gawk/4.1.1	|| exit 1
# module load m4/1.4.17	|| exit 1
# module load gcc/4.8.3	|| exit 1

# ###############################################################
# # Install
cd "${SOURCE_DIR}/${EXTRACT_FOLDER}" || exit 1

# libtoolize -fi   || exit 1
# aclocal  || exit 1
# autoheader  || exit 1
pwd
./autogen.sh  || exit 1

# ./configure --prefix=${DIR_INSTALL} || exit 1
# make -j8 || exit 1
# make install || exit 1

###############################################################
echo "=============================================="
echo ""
echo " INSTALACAO DO ${VERSION} FEITA COM SUCESSO"
echo ""
echo "=============================================="

sleep 2

# ###############################################################
# #Criação modulefile 
# /data/svn/softwares/trunk/utils/genmod.sh -n "${NAME}" -v "${VERSION}"

exit 0
