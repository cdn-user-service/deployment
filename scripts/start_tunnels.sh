#!/bin/bash

autossh -M 0 -f -N -L 9200:127.0.0.1:9200 cdn-master
autossh -M 0 -f -N -L 13306:127.0.0.1:3306 cdn-master
autossh -M 0 -f -N -L 16379:127.0.0.1:6379 cdn-master