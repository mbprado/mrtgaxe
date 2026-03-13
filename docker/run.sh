#!/bin/bash
docker run -dit --rm --name mrtgaxe -p 9999:9999 -v ../mrtg:/mrtgaxe/mrtg -v ../miners:/mrtgaxe/miners mrtgaxe_menu
