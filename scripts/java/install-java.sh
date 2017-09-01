#!/bin/bash
# Copyright 2017 WSO2 Inc. (http://wso2.org)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------------------------------------------
# Installation script for setting up Java on Linux.
# This is a simplified version of the script in 
# https://github.com/chrishantha/install-java
# ----------------------------------------------------------------------------

java_dist="$1"

# Make sure the script is running as root.
if [ "$UID" -ne "0" ]; then
    echo "You must be root to run $0. Try following"; echo "sudo $0";
    exit 9
fi

if [[ ! -f $java_dist ]]; then
    echo "Please specify the java distribution file (tar.gz)"
    help
    exit 1
fi

#Check whether unzip command exsits
if ! command -v unzip >/dev/null 2>&1; then
    echo "Please install unzip (sudo apt -y install unzip)"
    exit 1
fi

java_dir="/usr/lib/jvm"
mkdir -p $java_dir

# Extract Java Distribution
java_dist_filename=$(basename $java_dist)

dirname=$(echo $java_dist_filename | sed 's/jdk-\([78]\)u\([0-9]\{2,3\}\)-linux.*/jdk1.\1.0_\2/')

extracted_dirname=$java_dir"/"$dirname

if [[ ! -d $extracted_dirname ]]; then
    echo "Extracting $java_dist to $java_dir"
    tar -xof $java_dist -C $java_dir
    echo "JDK is extracted to $extracted_dirname"
else 
    echo "JDK is already extracted to $extracted_dirname"
fi


if [[ ! -f $extracted_dirname"/bin/java" ]]; then
    echo "Couldn't check the extracted directory. Please check the installation script"
    exit 1
fi

# Install Unlimited JCE Policy

unlimited_jce_policy_dist=""

if [[ "$java_dist_filename" =~ ^jdk-7.* ]]; then
    unlimited_jce_policy_dist="$(dirname $java_dist)/UnlimitedJCEPolicyJDK7.zip"
elif [[ "$java_dist_filename" =~ ^jdk-8.*  ]]; then
    unlimited_jce_policy_dist="$(dirname $java_dist)/jce_policy-8.zip"
fi

if [[ -f $unlimited_jce_policy_dist ]]; then
    echo "Extracting policy jars in $unlimited_jce_policy_dist to $extracted_dirname/jre/lib/security"
    unzip -j -o $unlimited_jce_policy_dist *.jar -d $extracted_dirname/jre/lib/security
fi

commands=( "jar" "java" "javac" "javadoc" "javah" "javap" "javaws" "jcmd" "jconsole" "jarsigner" "jhat" "jinfo" "jmap" "jmc" "jps" "jstack" "jstat" "jstatd" "jvisualvm" "keytool" "policytool" "wsgen" "wsimport" )

echo "Running update-alternatives --install and --config for ${commands[@]}"

for i in "${commands[@]}"
do
    command_path=$extracted_dirname/bin/$i
    sudo update-alternatives --install "/usr/bin/$i" "$i" "$command_path" 10000
    sudo update-alternatives --set "$i" "$command_path"
done

# Create system preferences directory
java_system_prefs_dir="/etc/.java/.systemPrefs"
if [[ ! -d $java_system_prefs_dir ]]; then
    echo "Creating $java_system_prefs_dir"
    mkdir -p $java_system_prefs_dir
    chown -R $SUDO_USER:$SUDO_USER $java_system_prefs_dir
fi

if grep -q "export JAVA_HOME=.*" $HOME/.bashrc; then
    sed -i "s|export JAVA_HOME=.*|export JAVA_HOME=$extracted_dirname|" $HOME/.bashrc
else
    echo "export JAVA_HOME=$extracted_dirname" >> $HOME/.bashrc
fi
source $HOME/.bashrc
