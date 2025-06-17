help:
	@echo "Please use \`make <target>' where <target> is one of these"
	@echo "  serve          to run jekyll serve"
	@echo "  tags           to generate tag pages from posts properties"

serve:
	jekyll serve --drafts --host 0.0.0.0

tags:
	python ./tag_generator.py
