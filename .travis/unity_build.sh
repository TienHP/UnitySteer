#! /bin/sh

if [ "$packagename" == "" ]; then
    project="${TRAVIS_REPO_SLUG##*/}"
else
    project="$packagename"
fi
if [ "$include_version" == "True" ]; then
    package="$project"_"$TRAVIS_TAG".unitypackage
else
    package=$project.unitypackage
fi

printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
echo "Setting up project directory; ------------------------------------------------------------------------------------------"
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
mkdir ./Project
if [ "$verbose" == "True" ];
then
    /Applications/Unity/Unity.app/Contents/MacOS/Unity \
     -batchmode \
     -nographics \
     -silent-crashes \
     -logFile ./.travis/unityProject.log \
     -createProject ./Project \
     -quit
    
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
    echo 'Project Log; -----------------------------------------------------------------------------------------------------------'
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
    cat ./.travis/unityProject.log
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
else
    /Applications/Unity/Unity.app/Contents/MacOS/Unity \
     -batchmode \
     -nographics \
     -silent-crashes \
     -createProject ./Project \
     -quit
fi

printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
echo "Moving files into temporary project; -----------------------------------------------------------------------------------"
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
mkdir -p ./Project/Assets/"$project"
find ./* \
 ! -path '*/\.*' \
 ! -path "./Project/*" \
 ! -name "Project" \
 ! -path "./.travis/*" \
 ! -name ".travis" \
 ! -name ".gitignore" \
 -exec cp -v {} ./Project/Assets/"$project"/ \;

printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
echo "Attempting to package $project;"
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
if [ "$verbose" == "True" ];
then
    /Applications/Unity/Unity.app/Contents/MacOS/Unity \
     -batchmode \
     -nographics \
     -silent-crashes \
     -logFile ./.travis/unityPackage.log \
     -projectPath "$PWD"/Project \
     -exportPackage Assets/"$project" "$package" \
     -quit
     
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
    echo 'Packaging Log; ---------------------------------------------------------------------------------------------------------'
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
    cat ./.travis/unityPackage.log
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
else
    /Applications/Unity/Unity.app/Contents/MacOS/Unity \
     -batchmode \
     -nographics \
     -silent-crashes \
     -projectPath "$PWD"/Project \
     -exportPackage Assets/"$project" "$package" \
     -quit
fi

#The package is exported to ./Project/$package
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
echo "Checking package exists; -----------------------------------------------------------------------------------------------"
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
file=./Project/$package

if [ -e "$file" ];
then
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
	echo "Package exported successfully: $file"
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
	exit 0
else
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
	echo "Package not exported. Aborting.----------------------------------------------------------------------------------------------"
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
	exit 1
fi
