#/bin/sh
#

NO=0

for i in $(/usr/bin/ls -rt *$1*.mp4) ; 
  do 
    NO=$(expr $NO + 1)
    PREFIX=$(seq -w $NO 21 | xargs | cut -d" " -f1)
    echo $PREFIX
    #ffmpeg -i $i -filter_complex "[0:v]setpts=0.75*PTS[v];[0:a]atempo=1.5[a]" \
    #             -map "[v]" -map "[a]" $(basename $i mp4)mkv
    if ! [ -f ${PREFIX}_$(basename $i .mp4)-X1.25.mkv ]
        then
    ffmpeg -i $i -filter_complex "[0:v]setpts=0.8*PTS[v];[0:a]atempo=1.25[a]" \
                 -map "[v]" -map "[a]" -c:v libx264 -c:a aac \
                 ${PREFIX}_$(basename $i .mp4)-X1.25.mkv
        fi
    # ffmpeg -i $i $(basename $i mp4)mp3 ; 
  done

#mkdir mkv
#mv *.mkv mkv
exit 0

#
# Commande à utiliser pour lancer ce script dans les sous-dossier d'une arborescence :
# 
for i in $(find . -type d | xargs| sed 's/\. //'); do cd $i && pwd ; ~/Vidéos/mp4TOmkv-X1.25.sh && cd .. ; done

