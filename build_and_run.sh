#!/bin/sh
if [ ! -d Temp ]
then
    mkdir Temp
fi
if [ ! -d Builds ]
then
    mkdir Builds
fi

for pid in $(tasklist -fo CSV -v -fi "imagename eq PlaydateSimulator.exe" | tail -n +2 | awk -F',' '{print $2}' | tr -d '"')
do
    echo $pid
    taskkill -IM $pid
done 


pdc Source Builds/Game.pdx
cd Temp

if [[ $OSTYPE == 'darwin'* ]]; then
    open "$HOME/Developer/PlaydateSDK/bin/Playdate Simulator.app" ../Builds/Game.pdx
fi
if [[ $OSTYPE == 'msys'* ]]; then
    start %PLAYDATE_SDK_PATH%/bin/PlaydateSimulator.exe ../Builds/Game.pdx | echo
fi
cd ..