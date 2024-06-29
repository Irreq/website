#!/bin/bash

SITE_DIR="site"
POSTS_DIR="posts"
SEARCH_POST_DIR="$SITE_DIR/$POSTS_DIR"
BLOG_FILE="$SITE_DIR/blog.html"

# Create a list of links to all HTML files in the posts directory
POST_LINKS=""
for post in site/posts/*.html; do
    FILENAME=$(basename "$post")
    # Extract the title from the <title> tag within the HTML file
    # TITLE=$(echo $FILENAME | grep -oP '.+?(?=\.html)')
    TITLE=$(cat $post | grep -oP "(?<=\<title\>).*(?=\<\/title\>)")
    # TITLE=$(grep -oP '(?<=<title>)(.*)(?=</title>)' "$post")
    POST_LINKS+="<li><a href=\"$POSTS_DIR/$FILENAME\">$TITLE</a></li>"
    
done
# echo $POST_LINKS
# Escape forward slashes in POST_LINKS for use in sed
POST_LINKS_ESCAPED=$(echo "$POST_LINKS" | sed 's/[&/\]/\\&/g')


# echo "$POST_LINKS_ESCAPED"

# Read the index template and replace $post_links$ with the actual links
# sed "s/\$post_links\\$/$POST_LINKS_ESCAPED/g" "$INDEX_TEMPLATE" > "$INDEX_FILE"
# sed "s/\$post_links\\$/$POST_LINKS_ESCAPED/g" $INDEX_FILE
sed -i "s/POST_LINKS/$POST_LINKS_ESCAPED/g" $BLOG_FILE
# 024-06-28
