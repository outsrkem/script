#!/bin/bash
# Refer to "MySQL" startup script "mysqld_safe"
# Tue Dec 17 CST 2019
# outsrkem@163.com


# help options
usage () {
    cat <<EOF
Usage: $0 [OPTIONS]
  --version=19.0.0    Specify the version
  --file=file         The specified file
  --home=homedir      The specified directory
EOF
  exit 1
}

parse_arguments() {
  # Read the parameter
  for arg do 
  # the parameter after "=", or the whole $arg if no match
  val=`echo "$arg" | sed -e 's;^--[^=]*=;;'`
  # what's before "=", or the whole $arg if no match
  optname=`echo "$arg" | sed -e 's/^\(--[^=]*\)=.*$/\1/'`
  # replace "_" by "-" 
  optname_subst=`echo "$optname" | sed 's/_/-/g'`
  arg=`echo $arg | sed "s/^$optname/$optname_subst/"`   
    case "$arg" in       
      --version=*) version="$val" ;;
      --file=*) file="$val" ;;
      --home=*) home="$val" ;;
      --help) usage ;;
      *) shell_quote_string "$arg" ;;
    esac
  done
}
shell_quote_string() {
  # This sed command makes sure that any special chars are quoted,
  # so the arg gets passed exactly to the server.
  echo "$1" | sed -e 's,\([^a-zA-Z0-9/_.=-]\),\\\1,g'
}

parse_arguments "$@"

if test -n "$version"
then
  echo "version: $version"
fi

if test -n "$file"
then
  echo "file: $file"
fi

if test -n "$home"
then
  echo "home: $home"
fi
