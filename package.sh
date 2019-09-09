if [ $# -eq 0 ]; then
  if [ "$TRAVIS_PULL_REQUEST" != false ]; then
    echo "Need to supply version argument" && exit;
  fi
fi

# Use mono or .net depending on OS
case "$(uname -s)" in
    CYGWIN*|MINGW32*|MINGW64*|MSYS*)
        # on windows, use dotnet
        runtime="dotnet"
        ;;
    *)
        # otherwise use mono
        runtime="mono"
        ;;
esac

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
  VERSION="$(date +%H:%M:%S)"
  YEAR="$(date +%Y)"
  MONTH="$(date +%m)"
  DAY="$(date +%d)"
else
  VERSION=$1
  BRANCH=$2
  BRANCH=${BRANCH#refs\/heads\/}
  BRANCH=${BRANCH//\//-}
fi
outputFolder='./_output'
outputFolderMono='./_output_mono'
outputFolderOsx='./_output_osx'
outputFolderOsxApp='./_output_osx_app'

tr -d "\r" < $outputFolderOsxApp/Sonarr.app/Contents/MacOS/Sonarr > $outputFolderOsxApp/Sonarr.app/Contents/MacOS/Sonarr2
rm $outputFolderOsxApp/Sonarr.app/Contents/MacOS/Sonarr
chmod +x $outputFolderOsxApp/Sonarr.app/Contents/MacOS/Sonarr2
mv $outputFolderOsxApp/Sonarr.app/Contents/MacOS/Sonarr2 $outputFolderOsxApp/Sonarr.app/Contents/MacOS/Sonarr >& error.log

if [ $runtime = "dotnet" ] ; then
  ./7za.exe a Sonarr_Windows_$VERSION.zip ./Sonarr_Windows_$VERSION/*
  ./7za.exe a -ttar -so Sonarr_Mono_$VERSION.tar ./Sonarr_Mono_$VERSION/* | ./7za.exe a -si Sonarr_Mono_$VERSION.tar.gz
  ./7za.exe a -ttar -so Sonarr_OSX_$VERSION.tar ./_output_osx/* | ./7za.exe a -si Sonarr_OSX_$VERSION.tar.gz
  ./7za.exe a -ttar -so Sonarr_OSX_App_$VERSION.tar ./_output_osx_app/* | ./7za.exe a -si Sonarr_OSX_App_$VERSION.tar.gz
else
  cp -r $outputFolder/ Sonarr
  #zip -r Sonarr.$BRANCH.$VERSION.windows.zip Sonarr
  rm -rf Sonarr
  cp -r $outputFolderMono/ Sonarr
  tar -zcvf Sonarr.$BRANCH.linux.tar.gz Sonarr
  rm -rf Sonarr
  cp -r $outputFolderOsx/ Sonarr
  #tar -zcvf Sonarr.$BRANCH.$VERSION.osx.tar.gz Sonarr
  rm -rf Sonarr
  #TODO update for tar.gz

  cd _output_osx_app/
  #zip -r ../Sonarr.$BRANCH.$VERSION.osx-app.zip *
fi
# ftp -n ftp.leonardogalli.ch << END_SCRIPT
# passive
# quote USER $FTP_USER
# quote PASS $FTP_PASS
# mkdir builds
# cd builds
# mkdir $YEAR
# cd $YEAR
# mkdir $MONTH
# cd $MONTH
# mkdir $DAY
# cd $DAY
# binary
# put Sonarr_Windows_$VERSION.zip
# put Sonarr_Mono_$VERSION.zip
# put Sonarr_OSX_$VERSION.zip
# quit
# END_SCRIPT
