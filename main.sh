#!/usr/bin/env bash

# Import
. ./lib/Log.sh
. ./lib/APT-GET.sh
. lib/Work.sh

# init
ElectrumDashRepository="https://github.com/akhavr/electrum-dash.git"
RepositoryDirName="electrum-dash"
chanFilePath="./base"
chanMakeApkFilePath="${chanFilePath}/make_apk"
oriMakeApkFilePath="./${RepositoryDirName}/contrib/make_apk"
chanBuildozerSpecPath="${chanFilePath}/buildozer.spec"
oriBuildozerSpecPath="./${RepositoryDirName}/electrum_dash/gui/kivy/tools/buildozer.spec"
makeLocalePath="./${RepositoryDirName}/contrib/make_locale"
makePackagesPath="./${RepositoryDirName}/contrib/make_packages"
dockerApkBuilderImgName="electrum-android-builder-img"

function main(){

    LogInfo "< Electrum-Dash-APK-Builder >"

    AptCheck "python3.7"
    AptCheck "python3-pip"
    AptCheck "python3-testresources"
    WorkPythonPip "setuptools"
    WorkPythonPip "pip"
    AptCheck "docker"

    WorkRemove ${RepositoryDirName}

    WorkGitClone ${ElectrumDashRepository} ${RepositoryDirName}

    WorkCp ${chanMakeApkFilePath} ${oriMakeApkFilePath}

    WorkCp ${chanBuildozerSpecPath} ${oriBuildozerSpecPath}

    WorkdockerImgCheck ${dockerApkBuilderImgName} ${chanFilePath}

    WorkShellScript ${makeLocalePath}

    WorkShellScript ${makePackagesPath}

    WorkDockerApkBuild ${RepositoryDirName} ${dockerApkBuilderImgName}
}

main
