#! /bin/bash

# on définit la date et l'heure
Date=`date +%H_%M_%S-%Y%m%d`

## sauvegarde 1 : JENKINS
# on définit les chemins
REP_A_SAUVER_JENKINS="/usr/local/jenkins"
REP_CIBLE_JENKINS="/home/server_ic"

# on archive et on compresse la sauvegarde dans le dossier idoine
tar -cvzf ${REP_CIBLE_JENKINS}/sauv_${Date}.tar.gz ${REP_A_SAUVER_JENKINS}


## sauvegarde 2 : WEB
# on définit les chemins
REP_A_SAUVER_WEB="/var/www/html"
REP_CIBLE_WEB="/home/web"

# on archive et on compresse la sauvegarde dans le dossier idoine
tar -cvzf ${REP_CIBLE_WEB}/sauv_${Date}.tar.gz ${REP_A_SAUVER_WEB}


###-------#### PURGE ####------###
find /home/server_ic -name *.tar.gz -mtime +7 -exec rm -rf {} \;
find /home/web -name *.tar.gz -mtime +7 -exec rm -rf {} \;
