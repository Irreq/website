# Define directories

# In
SRC_DIR := src

# Out
SITE_DIR := site

STYLE_DIR := css
TEMPLATE_DIR := templates
THEME_DIR := themes

SCRIPT_DIR := scripts

HIGHLIGHT_THEME := onedark.theme

# Finding source files for posts
SRC_FILES := $(wildcard $(SRC_DIR)/posts/*.md)
POSTS_FILES := $(patsubst $(SRC_DIR)/posts/%.md, $(SITE_DIR)/posts/%.html, $(SRC_FILES))


# Finding regular source files
SITE_FILES_MD := $(wildcard $(SRC_DIR)/*.md)
SITE_FILES := $(patsubst $(SRC_DIR)/%.md, $(SITE_DIR)/%.html, $(SITE_FILES_MD))

STYLE := $(SITE_DIR)/styles/style.css

RM := rm

all:  website 

website: $(SITE_FILES) 

# Generate out
$(SITE_DIR):
	mkdir -p $(SITE_DIR)

$(SITE_DIR)/styles: | $(SITE_DIR)
	mkdir -p $(SITE_DIR)/styles

# Copy assets
$(SITE_DIR)/assets: | $(SITE_DIR)
	cp -r assets $(SITE_DIR)/

# Copy style
$(SITE_DIR)/styles/style.css: $(STYLE_DIR)/style.css | $(SITE_DIR)/assets $(SITE_DIR)/styles
	cp $(STYLE_DIR)/style.css $(SITE_DIR)/styles/style.css

# Create posts dir
$(SITE_DIR)/posts: | $(SITE_DIR)
	mkdir -p $(SITE_DIR)/posts

# Generate posts
$(SITE_DIR)/posts/%.html: $(SRC_DIR)/posts/%.md $(SITE_DIR)/styles/style.css $(TEMPLATE_DIR)/post.html $(TEMPLATE_DIR)/footer.html | $(SITE_DIR)/posts
	pandoc --standalone --template=$(TEMPLATE_DIR)/post.html --include-after-body=$(TEMPLATE_DIR)/footer.html --highlight-style $(THEME_DIR)/$(HIGHLIGHT_THEME) $< -o $@

# Generate regular pages
$(SITE_DIR)/%.html: $(SRC_DIR)/%.md $(TEMPLATE_DIR)/%.html $(SITE_DIR)/styles/style.css $(TEMPLATE_DIR)/footer.html | $(SITE_DIR)
	pandoc $< --template=$(TEMPLATE_DIR)/$*.html --include-after-body=$(TEMPLATE_DIR)/footer.html -o $@

# Generate blog
$(SITE_DIR)/blog.html: $(POSTS_FILES) $(SRC_DIR)/blog.md
	pandoc $(SRC_DIR)/blog.md --template=$(TEMPLATE_DIR)/blog.html --include-after-body=$(TEMPLATE_DIR)/footer.html -o $(SITE_DIR)/blog.html
	./$(SCRIPT_DIR)/generate_index.sh
	

# Define a target to clean up (optional)
clean:
	$(RM) -rf $(SITE_DIR)

.PHONY: all clean
