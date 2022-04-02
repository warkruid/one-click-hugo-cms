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
