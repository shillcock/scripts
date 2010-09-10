#!/bin/sh
if [ ! "$1" = "" ] ; then

   while [ "`pwd`" != "/" -a "$HGREPO" = "" ] ; do

       if [ -d ./lmkproject ] ; then

          HGREPO=`pwd`/src
       fi

       cd ..
   done

   if [ "$HGREPO" = "" -a -d "$HOME/cm/src" ] ; then
      HGREPO="$HOME/cm/src"
   fi

   if [ "$HGREPO" != "" ] ; then

      echo "Mercurial repositories found in $HGREPO"
      echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-"

      DIRS="`/bin/ls -1 $HGREPO`"

      for dir in $DIRS ; do

         if [ -d $HGREPO/$dir/.hg ] ; then
            echo "$dir -> hg $1"
            cd $HGREPO/$dir ; hg "$@"
            echo
         fi

      done
   else

      echo "Mercurial repositories not found."

   fi
fi
