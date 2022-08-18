# https://github.com/jackyzha0/quartz/blob/hugo/Makefile

.DEFAULT_GOAL := serve

help: ## Show all Makefile targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

update: ## Update Quartz to the latest version on Github
	@git remote show upstream || (echo "remote 'upstream' not present, setting 'upstream'" && git remote add upstream https://github.com/vanadium23/obsidian-notes-template.git)
	git fetch upstream
	git log --oneline --decorate --graph ..upstream/main
	git checkout -p upstream/main -- _includes _layouts _pages _plugins .github assets Gemfile Makefile

install:
	bundle

serve:
	bundle exec jekyll serve -w
