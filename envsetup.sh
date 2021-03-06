#!/bin/sh

START_DIR=`pwd`

while [ "`pwd`" != "/" -a "$DMZ_ROOT" = "" ] ; do
    if [ -d ./lmkproject -a -d ./bin ] ; then
       DMZ_ROOT=`pwd`
    else
       cd ..
    fi
done

if [ "$DMZ_ROOT" = "" -a -d "$HOME/cm/" ] ; then
   DMZ_ROOT="$HOME/cm"
fi

if [ "$DMZ_ROOT" = "" ] ; then
   echo "Unable to locate the DMZ root directory"
   exit -1
else
   echo "DMZ Root: $DMZ_ROOT"
   echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
   cd "$START_DIR"
fi

export QT_PLUGIN_PATH="$DMZ_ROOT/depend/Qt"

if [ "$DMZ_BIN_MODE" = "" ] ; then
   DMZ_BIN_MODE="debug"
fi

if [ `uname` = "Darwin" ] ; then
   export DYLD_LIBRARY_PATH=$DMZ_ROOT/bin/macos-$DMZ_BIN_MODE:$DMZ_ROOT/depend/Qt:$DMZ_ROOT/depend/osg/lib:$DMZ_ROOT/depend/Collada14Dom.framework:$DMZ_ROOT/depend/v8/lib:$DMZ_ROOT/depend/luajit/lib:$DYLD_LIBRARY_PATH
   export BIN_HOME=$DMZ_ROOT/bin/macos-$DMZ_BIN_MODE ;
   export DEBUG_EXE="gdb --args "
elif [ `uname` = "Linux" ] ; then
   export LD_LIBRARY_PATH=$DMZ_ROOT/bin/linux-$DMZ_BIN_MODE:$LD_LIBRARY_PATH
   export BIN_HOME=$DMZ_ROOT/bin/linux-$DMZ_BIN_MODE ;
   export DEBUG_EXE="gdb --args "
elif [ `uname -o` = "Cygwin" ] ; then
   if [ "$PATH" = "" ] ; then
      export PATH=$DMZ_ROOT/depend/bin
   else
      export PATH=$DMZ_ROOT/depend/bin:$PATH
   fi
   export BIN_HOME=`cygpath -w $DMZ_ROOT/bin/win32-$DMZ_BIN_MODE` ;
   export DEBUG_EXE="devenv /debugexe "
else
   echo "Unsupported platform: " `uname`
   exit -1
fi

if [ "$DMZ_DEBUG" = "true" ] ; then
   export RUN_DEBUG="$DEBUG_EXE"
else
   export RUN_DEBUG=""
fi

export DMZ_BIN_PATH=$RUN_DEBUG$BIN_HOME
