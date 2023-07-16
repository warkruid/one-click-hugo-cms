---
title: "Generate Banners With Random Backgrounds"
date: 2023-07-16T11:06:50+02:00
draft: false 
categories: [publishing, development]
tags: [random, banners, hugo, curl, trivia]
---

I sometimes want to use a image background for a certain text banner. 
Or use a pictures as a placeholder for an image I will add later.

Usually that meant I had to choose an image that I already had on my HD and resize it and add the text to it.
Boring!

So when I stumbled on https://picsum.photos I quickly hacked together a script that grabbed a random image from picsum, and added a text to it.
Hey Presto! Random placeholder images (with or without text). 

# Requirements
* curl or wget
* imagemagick

# Script
```shell
#!/bin/bash
title=$1
image=$2
width=$3
height=$4
wget -q https://picsum.photos/$width/$height -O $image.jpg
convert \
-background '#0008' \
-font Arvo \
-pointsize 35 \
-fill white \
-gravity center \
-size 800x150 caption:"$title" \
$image.jpg \
+swap \
-gravity south \
-composite $image.jpg
```

# Test run
./test.sh test test 800 600 

# Output
![Testimage generated with script](/test.jpg)
