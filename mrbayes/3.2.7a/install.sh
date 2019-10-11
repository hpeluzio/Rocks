#!/bin/bash -x

#1) Realiza o carregamento dos modulos necessarios para a instalacao
module purge
module load rocks-openmpi
module load beagle/2.1.2

#2) Cria estrutura em /data/src onde o software sera baixado e compilado
mkdir -p /data/src/mrbayes/3.2.7a/
cd /data/src/mrbayes/3.2.7a/
#Colocar o link de download no wget abaixo. Atencao para o nome do arquivo de saida
#Verificar o nome do arquivo de saida
URL=https://github.com/NBISweden/MrBayes/archive/v3.2.7a.tar.gz
FILENAME=$(basename "$URL")
wget "$URL"
tar xzf $FILENAME
EXTRACTED_DIR_NAME=`tar tzf "$FILENAME" | sed -e 's@/.*@@' | uniq`
cd /data/src/mrbayes/3.2.7a/$EXTRACTED_DIR_NAME

#3) Estrutura de instalacao em /data/apps
mkdir -p /data/apps/mrbayes/3.2.7a/
./configure --prefix=/data/apps/mrbayes/3.2.7a --with-mpi
make -j 16
#make check #opcional
make install

#4) Conferir visualmente os arquivos de saida
ls /data/apps/mrbayes/3.2.7a/*

#5) Caso queira gerar o modulo com o mesmo nome usar o comando abaixo e ajustar o modulo
/data/svn/softwares/trunk/utils/genmod.sh -n mrbayes -v 3.2.7a

