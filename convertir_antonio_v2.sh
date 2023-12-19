#/bin/bash
#EPSG:4326 LATLONG
#EPSG:32628 UTM 28N # CANARIAS
#EPSG:32633 UTM 33N # NAPOLES
#EPSG:32630 UTM 30N # IBERIA

NAME=$1
OUTPUT=antonio_APS
INPUT=timeseries_ERA5_ramp_demErr.h5 # timeseries_ERA5_ramp_demErr.h5 timeseries_ramp_demErr.h5
CLIP=false
CLIP_FILE=/home/jescayo/lapalma_clipper2.kml
EXCLUDE_DATES=true
TEMP_FILTER=5
FILTER=true

# Checks for file input and dataset name #
if [ -z $NAME ]; then echo "DEBE DAR UN NOMBRE DE SALIDA PARA EL DATASET"; exit; fi
if [ ! -f $INPUT ]; then echo "No existe el fichero de resultados, compruebalo"; exit; fi

rm -rf $OUTPUT &> /dev/null
mkdir $OUTPUT

if $FILTER; then
spatial_filter.py -f lowpass_avg -p 5 -o timeseries_lowpass.h5 $INPUT
temporal_filter.py -t $TEMP_FILTER -o timeseries_lowpass_spatial.h5 timeseries_lowpass.h5
save_qgis.py timeseries_lowpass_spatial.h5 -g inputs/geometryRadar.h5 -o $OUTPUT/$NAME'_filt.shp'
fi
save_qgis.py $INPUT -g inputs/geometryRadar.h5 -o $OUTPUT/$NAME.shp
if $CLIP; then
echo "Clipping the SHP files"
ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:32628 -f CSV $OUTPUT/$NAME.csv $OUTPUT/$NAME.shp -lco GEOMETRY=AS_XYZ -clipsrc $CLIP_FILE
if $FILTER; then
ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:32628 -f CSV $OUTPUT/$NAME'_filt.csv' $OUTPUT/$NAME'_filt.shp' -lco GEOMETRY=AS_XYZ -clipsrc $CLIP_FILE
fi
else
echo "Using full region (NO CLIP)"
ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:32628 -f CSV $OUTPUT/$NAME.csv $OUTPUT/$NAME.shp -lco GEOMETRY=AS_XYZ
if $FILTER; then
ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:32628 -f CSV $OUTPUT/$NAME'_filt.csv' $OUTPUT/$NAME'_filt.shp' -lco GEOMETRY=AS_XYZ
fi
fi

NUMERO_COLUMNAS=$(awk -F',' 'NR==1{print NF}' $OUTPUT/$NAME.csv)
cp exclude_date.txt $OUTPUT/

mkdir $OUTPUT/nofilt
for i in $(seq 11 $NUMERO_COLUMNAS);
do
awk -F"," '{print $1,$2,$5,$"'"$i"'"}' $OUTPUT/$NAME.csv > $OUTPUT/nofilt/$i
FECHA=$(awk  'NR==1 {print $4}' $OUTPUT/nofilt/$i)
mv $OUTPUT/nofilt/$i $OUTPUT/nofilt/$FECHA
done
#Remove	decimals over 2	in coordinates
for i in $OUTPUT/nofilt/D*; do awk 'NR>1 {printf "%0.1f %0.1f %0.1f %0.2f\n",$1,$2,$3,$4}' $i > temp; mv temp $i; done


if $FILTER; then
mkdir $OUTPUT/filt
for i in $(seq 11 $NUMERO_COLUMNAS);
do
awk -F"," '{print $1,$2,$5,$"'"$i"'"}' $OUTPUT/$NAME'_filt.csv' > $OUTPUT/filt/$i
FECHA=$(awk  'NR==1 {print $4}' $OUTPUT/filt/$i)
mv $OUTPUT/filt/$i $OUTPUT/filt/$FECHA
done
fi
#Remove decimals over 2 in coordinates
for i in $OUTPUT/filt/D*; do awk 'NR>1 {printf "%0.1f %0.1f %0.1f %0.2f\n",$1,$2,$3,$4}' $i > temp; mv temp $i; done

if $EXCLUDE_DATES; then
for i in $(cat exclude_date.txt);
do
rm $OUTPUT/nofilt/D$i
if $FILTER; then
rm $OUTPUT/filt/D$i
fi
done
fi

mkdir $OUTPUT/$NAME
mv $OUTPUT/nofilt $OUTPUT/$NAME/
if $FILTER; then
mv $OUTPUT/filt $OUTPUT/$NAME/
fi

cd $OUTPUT
zip $NAME.zip $NAME -rqq

rclone copy $NAME.zip gdrive_krasny:/resultados/
