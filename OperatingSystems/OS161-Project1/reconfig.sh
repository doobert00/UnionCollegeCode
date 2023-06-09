#!/bin/bash
cd src
./configure --ostree=$PWD/../root
bmake 
bmake install
cd kern/conf
./config PROJ2
cd ..
cd compile/PROJ2
bmake depend 
bmake
bmake install
