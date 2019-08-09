#!/usr/bin/env bash

function WorkRemove(){
    removeFileName=$1
    LogInfo "Remove ${removeFileName}"
    rm -rf ${removeFileName}
}

function WorkCp(){
    chanFile=$1
    oriFile=$2
    LogInfo "Copy ${chanFile} ${oriFile}"
    cp ${chanFile} ${oriFile}
}

### shell ###

function WorkShellScript(){
    shellPath=$1
    LogInfo "Start ShellScript ${shellPath}"
    ${shellPath}
}

### git ###

function WorkGitClone(){
    url=$1
    dirName=$2
    LogInfo "Git clone ${url} ${dirName}"
    git clone ${url} ${dirName}
}

### Docker ###

function WorkDockerBuild() {
    imgName=$1
    dockerFilePath=$2
    if [[ $(sudo docker image ls | grep ${imgName}) == *"${imgName}"* ]] > /dev/null 2>&1; then
        LogInfo "built ${imgName}"
    else
        LogInfo "building ${imgName}"
        sudo docker build -t ${imgName} ${dockerFilePath}
    fi
}

function WorkdockerImgCheck(){
    imgName=$1
    dockerfilePath=$2
    if [[ ${imgName} == "electrum-android-builder-img" ]] > /dev/null 2>&1; then
        WorkDockerBuild ${imgName} ${dockerfilePath}
    fi
}

function WorkDockerApkBuild(){
    dirPath=$1
    imgName=$2

    cd ${dirPath} &&\
    sudo docker run -it --rm \
    --name electrum-android-builder-cont \
    -v $PWD:/home/user/wspace/electrum \
    -v ~/.keystore:/home/user/.keystore \
    --workdir /home/user/wspace/electrum \
    ${imgName} \
    ./contrib/make_apk
}
### PIP ###

function WorkPythonPip(){
    packageName=$1
#    if [[ $(sudo -H python3 -m pip list --format=legacy | grep ${packageName}) == *"${packageName}"* ]] > /dev/null 2>&1; then
#        LogInfo "${packageName} is already installed."
#    else
#        LogInfo "Install ${packageName}"
#        sudo -H python3 -m pip install --upgrade ${packageName}
#    fi
    LogInfo "Python pip update ${packageName}"
    sudo -H python3 -m pip install --upgrade ${packageName}
}