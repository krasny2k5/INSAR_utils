#!/bin/bash

# Seleccionador de hojas de la peninsula

PWD=$(pwd)
MDT=25

# crear directorios para cada isla
# dejamos la península en un directorio a parte:

islas_dir=$PWD/islas
#baleares
baleares_dir=$PWD/islas/baleares
menorca_dir=$PWD/islas/baleares/menorca
mallorca_dir=$PWD/islas/baleares/palma_mallorca
formentera_dir=$PWD/islas/baleares/formentera
alboran_dir=$PWD/islas/alboran
canarias_dir=$PWD/islas/canarias
palma_dir=$PWD/islas/canarias/la_palma
hierro_dir=$PWD/islas/canarias/hierro
gomera_dir=$PWD/islas/canarias/gomera
tenerife_dir=$PWD/islas/canarias/tenerife
gran_canaria_dir=$PWD/islas/canarias/gran_canaria
lanzarote_dir=$PWD/islas/canarias/lanzarote
fuerteventura_dir=$PWD/islas/canarias/fuerteventura
columbretes_dir=$PWD/islas/columbretes

# Baleares
menorca="0618 0619 0646 0647 0673"
mallorca="0643 0644 0645 0670 0671 0672 0697 0698 0699 0700 0722B 0723 0724 0725 0748 0749 0774"
formentera="0772 0773 0798 0799 0824 0825 0849 0850"

# Canarias
palma="1083 1085 1087"
hierro="1105-1108"
gomera="1095"
tenerife="1088 1089 1091 1092 1096 1097 1102"
gran_canaria="1098 1103 1104 1106 1107"
lanzarote="1079 1080 1081 1082 1084"
fuerteventura="1086 1090 1093 1094 1100 1099"

# Otras
columbretes="0642"
alboran="1078B"

# creamos el subdirectorio islas
mkdir $islas_dir

# BALEARES:
echo "BALEARES ISLANDS"
mkdir $baleares_dir

# Menorca
echo "PROCESSING MENORCA ISLAND"    
mkdir $menorca_dir
for i in $menorca;
do
    # check if sheet exists and mv to destination folder:
    if [ -f $PWD/MDT$MDT-$i.zip ] || [ -f $PWD/MDT$MDT-$i-LIDAR.zip ]
    then
        mv MDT$MDT-$i[.-]*zip $menorca_dir
    else
        echo "file MDT$MDT-$i not found!"
    fi
done

# Mallorca
echo "PROCESSING MALLORCA ISLAND"
mkdir $mallorca_dir
for i in $mallorca;
do
    # check if sheet exists and mv to destination folder:
    if [ -f $PWD/MDT$MDT-$i.zip ] || [ -f $PWD/MDT$MDT-$i-LIDAR.zip ]
    then
        mv MDT$MDT-$i[.-]*zip $mallorca_dir
    else
        echo "file MDT$MDT-$i not found!"
    fi
done

# Formentera
echo "PROCESSING FORMENTERA ISLAND"
mkdir $formentera_dir
for i in $formentera;
do
    # check if sheet exists and mv to destination folder:
    if [ -f $PWD/MDT$MDT-$i.zip ] || [ -f $PWD/MDT$MDT-$i-LIDAR.zip ]
    then
        mv MDT$MDT-$i[.-]*zip $formentera_dir
    else
        echo "file MDT$MDT-$i not found!"
    fi
done

#CANARIAS
echo "CANARY ISLANDS"
mkdir $canarias_dir

# LA PALMA
echo "PROCESSING LA PALMA ISLAND"
mkdir $palma_dir
for i in $palma;
do
    # check if sheet exists and mv to destination folder:
    if [ -f $PWD/MDT$MDT-$i.zip ] || [ -f $PWD/MDT$MDT-$i-LIDAR.zip ]
    then
        mv MDT$MDT-$i[.-]*zip $palma_dir
    else
        echo "file MDT$MDT-$i not found!"
    fi
done

# EL HIERRO
echo "PROCESSING EL HIERRO ISLAND"
mkdir $hierro_dir
for i in $hierro;
do
    # check if sheet exists and mv to destination folder:
    if [ -f $PWD/MDT$MDT-$i.zip ] || [ -f $PWD/MDT$MDT-$i-LIDAR.zip ]
    then
        mv MDT$MDT-$i[.-]*zip $hierro_dir
    else
        echo "file MDT$MDT-$i not found!"
    fi
done

# LA GOMERA
echo "PROCESSING LA GOMERA ISLAND"
mkdir $gomera_dir
for i in $gomera;
do
    # check if sheet exists and mv to destination folder:
    if [ -f $PWD/MDT$MDT-$i.zip ] || [ -f $PWD/MDT$MDT-$i-LIDAR.zip ]
    then
        mv MDT$MDT-$i[.-]*zip $gomera_dir
    else
        echo "file MDT$MDT-$i not found!"
    fi
done

# Tenerife
echo "PROCESSING TENERIFE ISLAND"
mkdir $tenerife_dir
for i in $tenerife;
do
    # check if sheet exists and mv to destination folder:
    if [ -f $PWD/MDT$MDT-$i.zip ] || [ -f $PWD/MDT$MDT-$i-LIDAR.zip ]
    then
        mv MDT$MDT-$i[.-]*zip $tenerife_dir
    else
        echo "file MDT$MDT-$i not found!"
    fi
done


# LAS PALMAS DE GRAN CANARIA
echo "PROCESSING LAS PALMAS DE GRAN CANARIA ISLAND"
mkdir $gran_canaria_dir
for i in $gran_canaria;
do
    # check if sheet exists and mv to destination folder:
    if [ -f $PWD/MDT$MDT-$i.zip ] || [ -f $PWD/MDT$MDT-$i-LIDAR.zip ]
    then
        mv MDT$MDT-$i[.-]*zip $gran_canaria_dir
    else
        echo "file MDT$MDT-$i not found!"
    fi
done

# LANZAROTE
echo "PROCESSING LANZAROTE ISLAND"
mkdir $lanzarote_dir
for i in $lanzarote;
do
    # check if sheet exists and mv to destination folder:
    if [ -f $PWD/MDT$MDT-$i.zip ] || [ -f $PWD/MDT$MDT-$i-LIDAR.zip ]
    then
        mv MDT$MDT-$i[.-]*zip $lanzarote_dir
    else
        echo "file MDT$MDT-$i not found!"
    fi
done

# FUERTEVENTURA
echo "PROCESSING FUERTEVENTURA ISLAND"
mkdir $fuerteventura_dir
for i in $fuerteventura;
do
    # check if sheet exists and mv to destination folder:
    if [ -f $PWD/MDT$MDT-$i.zip ] || [ -f $PWD/MDT$MDT-$i-LIDAR.zip ]
    then
        mv MDT$MDT-$i[.-]*zip $fuerteventura_dir
    else
        echo "file MDT$MDT-$i not found!"
    fi
done

# ALBORAN
echo "PROCESSING ALBORAN ISLAND"
mkdir $alboran_dir
for i in $alboran;
do
    # check if sheet exists and mv to destination folder:
    if [ -f $PWD/MDT$MDT-$i.zip ] || [ -f $PWD/MDT$MDT-$i-LIDAR.zip ]
    then
        mv MDT$MDT-$i[.-]*zip $alboran_dir
    else
        echo "file MDT$MDT-$i not found!"
    fi
done

# COLUMBRETES
echo "PROCESSING COLUMBRETES ISLAND"
mkdir $columbretes_dir
for i in $columbretes;
do
    # check if sheet exists and mv to destination folder:
    if [ -f $PWD/MDT$MDT-$i.zip ] || [ -f $PWD/MDT$MDT-$i-LIDAR.zip ]
    then
        mv MDT$MDT-$i[.-]*zip $columbretes_dir
    else
        echo "file MDT$MDT-$i not found!"
    fi
done
