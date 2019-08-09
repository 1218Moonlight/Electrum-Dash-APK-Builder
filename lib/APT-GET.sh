#!/usr/bin/env bash

function AptInstall() {
    packageName=$1
    if [[ $(dpkg -l | grep ${packageName} 2>&1) == *"${packageName}"* ]] > /dev/null 2>&1; then
        LogInfo "${packageName} is already installed."
    else
        LogInfo "Install ${packageName}"
        sudo apt-get install -y ${packageName}
    fi
}

function AptInstallPython37() {
    packageName=$1
    if [[ $(${packageName} -V 2>&1) == *"Python 3.7"* ]] > /dev/null 2>&1; then
        LogInfo "Python 3.7 is already installed."
    else
        LogInfo "Install python3.7"
        sudo apt-get update &&\
        sudo apt-get install -y software-properties-common &&\
        sudo add-apt-repository ppa:deadsnakes/ppa &&\
        sudo apt-get install -y python3.7
    fi
}

function AptInstallDocker() {
    packageName=$1
    if [[ $(${packageName} -v 2>&1) == *"Docker"* ]] > /dev/null 2>&1; then
        LogInfo "Docker is already installed."
    else
        echo "Install Docker"
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&\
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&\
        sudo apt-get update &&\
        sudo apt-get install -y docker-ce
    fi
}

function AptCheck() {
    packageName=$1
    if [[ ${packageName} == "python3.7" ]] > /dev/null 2>&1; then
        AptInstallPython37 ${packageName}
    elif [[ ${packageName} == "docker" ]] > /dev/null 2>&1; then
        AptInstallDocker ${packageName}
    elif [[ ${packageName} == "python3-pip" ]] > /dev/null 2>&1; then
        AptInstall ${packageName}
    elif [[ ${packageName} == "python3-testresources" ]] > /dev/null 2>&1; then
        AptInstall ${packageName}
    fi
}