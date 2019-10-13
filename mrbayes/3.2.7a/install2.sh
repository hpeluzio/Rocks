#!/bin/bash

export LUSER="root"
export LGROUP="root"

###############################################################
# Dados para a instalacao do software
NAME=mrbayes
VERSION=3.2.7a
FILE=v3.2.7a.tar.gz #NOME DO ARQUIVO QUE SERÁ BAIXADO
EXTRACT_FOLDER=MrBayes-3.2.7a #PASTA CRIADA QUANDO O ARQUIVO É EXTRAIDO
DOWNLOAD_LINK="http://github.com/NBISweden/MrBayes/archive/v3.2.7a.tar.gz"

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
cd "${SOURCE_DIR}/${EXTRACT_FOLDER}" || exit 1
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
module load rocks-openmpi 	|| exit 1
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
module load binutils/2.32	|| exit 1
module load m4/1.4.17	|| exit 1
module load gcc/4.8.3	|| exit 1
module load binutils/2.32	|| exit 1
module load beagle/2.1.2	|| exit 1

###############################################################
# Install
cd "${SOURCE_DIR}/${EXTRACT_FOLDER}"    || exit 1
./configure --prefix=${DIR_INSTALL} --with-mpi
make -j8
#make check #opcional
make install

###############################################################
echo "===================================================="
echo ""
echo " INSTALACAO DO ${NAME}-${VERSION} FEITA COM SUCESSO"
echo ""
echo "===================================================="

sleep 2

###############################################################
#Criação modulefile 
/data/svn/softwares/trunk/utils/genmod.sh -n "${NAME}" -v "${VERSION}"


#Conferir visualmente os arquivos
ls /data/apps/mrbayes/3.2.7a/*
