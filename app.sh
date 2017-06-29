#!/bin/sh

$0

file_name=`date +%Y-%m-%d`
path="$(cd $(dirname $0) && pwd)/posts/${file_name}.md"

if [ ! -e $path ]; then
  items=`curl -s http://qiita.com/popular-items/feed | \
         grep -o '<title>.*</title>\|http://qiita.com/.*?' | \
         sed -e '1d' -e 's/  //' -e 's/?$//' -e 's/^<title>//' -e 's/<\/title>$//'`

  IFS=$'\n'
  count=1

  for items in `echo "$items"`
  do
    if [ $(( count % 2 )) == 0 ]; then
      title="- [${items}]"
      row=$title$url
      echo $row >> $path
    else
      url="(${items})"
    fi
    count=$(( count + 1 ))
  done

  git add .
  git commit -m "add post ${file_name}.md"
  git push origin master
fi
