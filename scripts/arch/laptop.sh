#!/usr/bin/env bash
source ./scripts/arch/paccmds.sh
source ./scripts/bash_functions.sh 

# Battery utils for laptops:
cd $REPO_CLONES

git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
sudo auto-cpufreq --install

ensure_in_dir

