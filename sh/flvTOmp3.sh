#/bin/sh
# DR - 25/04/2023 - clone de mp4TOmp3.sh - Ajout Variables d'extention
# But : Convertir les flv (pas tjs lisibles avec read-audio.html) 
#       en mp3 ( sans changer la vitesse de lecture )

# 2d argument if given is start of increment prefix
( [ -z "$2" ] && NO=0 ) || NO=$(expr $2 - 1) || echo "Erreur paramètre 2 est l'indice de départ (nombre entier)"

SRC_EXT="flv"
DST_EXT="mp3"
echo "/usr/bin/ls -rt *$1*.$SRC_EXT"
/usr/bin/ls -rt *${1}*.$SRC_EXT

for i in $(/usr/bin/ls -rt *${1}*.$SRC_EXT)
do 
    NO=$(expr $NO + 1)
    PREFIX=$(seq -w $NO 21 | xargs | cut -d" " -f1)
    echo $PREFIX
    echo "${PREFIX}_$(basename $i .$SRC_EXT)-X1.25.$DST_EXT"
    if ! [ -f ${PREFIX}_$(basename $i .$SRC_EXT)-X1.25.$DST_EXT ]
        then
	    # Or || is when error occurs running ffmpeg ( flv broken or not readable or whatever went wrong...)
            ffmpeg -i $i ${PREFIX}_$(basename $i .$SRC_EXT)-X1.25.$DST_EXT 2>/dev/null || touch ${PREFIX}_$(basename $i .$SRC_EXT)-X1.25.KO
        fi
done

# Not to return always 0 == Ok...
[ $? == 0 ] && exit 0 || exit 1

############# EXAMPLES D'UTILISATION ##############
#
# Commande à utiliser pour lancer ce script dans les sous-dossier d'un module :
# 
# PWD=$(pwd) ; for i in $(find . -type d | xargs| sed 's/\. //'); do cd "$i/" && pwd ; ~/Vidéos/flvTOmp3.sh && cd $PWD ; done
# OK PWWD nest PAS une VARIABLE SPECIALE DU SHELL BASH/SH !!!
# => CA MARCHE ENFIN !!! :PD) - DR
# AT LEAST I FOUND IT !!!
#    Browse all directories from current and try to convert flv if present (with his script above)
#    Paste from parent directory location to convert all flv in its sub-dirs.
PWWD=$(pwd) ; for i in $(find . -type d | xargs| sed 's/\. //'); do cd "$i/" ; ~/Vidéos/flvTOmp3.sh ; cd $PWWD ; done

