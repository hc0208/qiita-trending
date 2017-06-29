#!/bin/sh

file_name=`date +%Y-%m-%d`

if [ ! -e "posts/${file_name}.md" ]; then
  items=`curl -s http://qiita.com/popular-items/feed | \
         grep -o '<title>.*</title>\|http://qiita.com/.*?' | \
         sed -e '1d' -e 's/  //' -e 's/?$//' -e 's/^<title>//' -e 's/<\/title>$//'`

  IFS=$'\n'
  count=1

  for items in `echo "$items"`
  do
    if [ $(( count % 2 )) == 0 ]; then
      title=[$items]
      row=$title$url
      echo $row >> "posts/${file_name}.md"
    else
      url="(${items})"
    fi
    count=$(( count + 1 ))
  done

  git add .
  git commit -m "add post ${file_name}.md"
  git push origin master
fi
