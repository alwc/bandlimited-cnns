#!/usr/bin/env bash

#bash Anaconda3-5.1.0-Linux-x86_64.sh -b
#source ~/.bashrc

curl -O https://repo.continuum.io/archive/Anaconda3-5.2.0-Linux-x86_64.sh
bash Anaconda3-5.2.0-Linux-x86_64.sh -b -p /local/\$\{USER\}/anaconda3/ -u
ln -s /local/\$\{USER\}/anaconda3/ /home/\$\{USER\}/anaconda3/
echo 'export PATH="~/anaconda3/bin:$PATH"' >> ~/.bashrc
export PATH=~/anaconda3/bin:$PATH
cd
source ~/.bashrc
source .bashrc
conda update conda --yes
conda --version
pip install --upgrade pip
pip install matplotlib
pip install memory_profiler

pip install py3nvml
pip install -U tensorflow-gpu




