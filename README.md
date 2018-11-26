# mdpp2MkDocs

This dockerfile builds the image needed to build a wiki from
+ MarkdownPP
+ some personal tricks to repare broken links from templates
+ MkDocs

## Usage
``` properties
-m : mode. Supported => destruct_mode => delete mdpp files before publishing. For CI only !
-l : use linkchecker to check for broken links
-v : set mkdocs to verbose mode - for debugging only
-u : an unicorn in this crual world shouldn't hurt anyone
```
