---
title: "Make and Hugo"
date: 2022-04-02T20:49:25+02:00
draft: false 
categories: [development, publishing]
tags: [make, hugo, commandline]
---

After a bit of experimenting with Hugo on the command line I quickly grew tired of typing in long and complex commandlines. Especially the commandline to push the repo to github was a special PITA. 

So.. I made a quick and dirty Makefile which simplified things a bit.


```
SHELL=/bin/bash

# make sure Make does not barf on unknown command
%:
	#:
	
# macro to read argument
args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

test: build
	hugo server -D

build:
	git pull
	hugo

# make a new post
post:
	hugo new posts/$(call args,"defaultstring")
	git add content/en/posts/$(call args,"defaultstring")

# push to github with TOKEN read from environment
push:
	git push https://warkruid:$(TOKEN)@github.com/warkruid/one-click-hugo-cms.git --all
```
