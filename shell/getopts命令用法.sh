#!/bin/bash
while getopts h:m:s: option
do
  case "$option" in
  h)
      echo "option:h,value:$OPTARG"
      echo "next arg index:$OPTIND";;
  m)
      echo "option:m,value:$OPTARG"
      echo "next arg index:$OPTIND";;
  s)
      echo "option:s,value:$OPTARG"
      echo "next arg index:$OPTIND";;
  ?)
      echo "usage error..."
  esac
done
