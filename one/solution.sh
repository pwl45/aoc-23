#!/bin/bash
# strip all numbers;          concat first and last number;               add to sum;    print sum at end
sed 's/[^0-9]//g' input | awk '{num=substr($0,1,1) substr($0,length($0)); sum+=num} END {print sum}'
