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

# build and start local server  in local network
build:
	git pull
	hugo server --bind 192.168.178.25 --baseURL http://192.168.178.25

# make a new post
post:
	hugo new posts/$(call args,"defaultstring")
	git add content/en/posts/$(call args,"defaultstring")

pdf:
	hugo --cleanDestinationDir --minify
	cat ./public/all-content/index.html | wkhtmltopdf --outline-depth 2 --enable-internal-links - ./public/downloads/all-content.pdf
	rm -r ./public/all-content
