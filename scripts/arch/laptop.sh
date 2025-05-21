#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/arch/paccmds.sh
source ./scripts/bash_functions.sh 

sudo -v

# Battery utils for laptops:
cd $REPO_CLONES

git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
sudo auto-cpufreq --install

ensure_in_dir

