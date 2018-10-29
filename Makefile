.PHONY: rmds
rmds: carp.Rmd socwork.Rmd
%.Rmd: ~/teaching/c32/assgt/%.Rnw convert.pl
	perl convert.pl $< > $@
docs/index.html: index.Rmd
	Rscript -e "bookdown::render_book('index.Rmd')"
