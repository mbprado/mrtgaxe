#!/bin/bash
cp Dockerfile ..
mkdir -p ../mrtg
mkdir -p ../miners
docker build -t mrtgaxe_menu ../
