#!/bin/bash

#################
# DOCUMENTATION #
#################

# Uses cURL to scrap CCCSF Coder's Flickr page for image URLs and formats them
# into anchor tags for easy copy and paste to the gallery page.
# Anchor tags are outputted to "flickr.out" file

#############
# FUNCTIONS #
#############

# output an error message and return
error () {
    local prog=$(basename $0)
    echo -e "$prog:ERROR: $*">&2
}

# output an error message and then exit
fatal() {
    error "$*"
    exit 1
}

##########
# SCRIPT #
##########

# create temp file
flickr_img=$(mktemp) || fatal "Unable to write temp files"

# download flickr page and parse for image URLs
curl https://www.flickr.com/photos/120620472@N04/ | grep -o "https://c[0-9].*\.jpg" > flickr_img

# format image URLs to anchor tags for gallery page
while read line; do
  line_noz="${line%_z.jpg}"
  line_thumb="${line_noz%.jpg}_n.jpg"
  echo -e "<a class=\"thumbail gallery\" href=\"$line\" title=\"coders image\">"
  echo -e   "\t<img src=\"$line_thumb\" alt=\"coders image\">"
  echo -e "</a>"
done < flickr_img > flickr.out

# remove temp file
rm $flickr_img
