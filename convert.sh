#!/bin/sh
#pandoc modop.md -s -o modop.pdf
pandoc modop.md -s -o modop.html
exit 0
#--slides
#pandoc -t slidy -s slide.md -c giveit.css -o slide.html
pandoc -t slidy -s slide.md  -o slide.html
pandoc -t slidy -s slide2.md  -o slide.pdf

ls -latr modop.pdf modop.html slide.html


