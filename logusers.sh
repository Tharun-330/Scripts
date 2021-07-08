#!/bin/bash
today=`date | awk '{print $1, $2, $3}'`
last | grep "$today"

