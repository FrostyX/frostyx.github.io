help:
	@echo "Please use \`make <target>' where <target> is one of these"
	@echo "  serve          to run jekyll serve"
	@echo "  tags           to generate tag pages from posts properties"

serve:
	jekyll serve --drafts

tags:
	python ./tag_generator.py
