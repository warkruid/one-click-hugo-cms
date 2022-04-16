SHELL=/bin/bash
# This is very much a work in progress

# make sure Make does not barf on unknown command
# I found this hack on stackoverflow some time ago,
# but cant find the exact url anymore
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
	source tokenfile
	git push https://warkruid:$(TOKEN)@github.com/warkruid/one-click-hugo-cms.git --all
