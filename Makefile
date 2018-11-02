.PHONY: rmds
rmds: carp.Rmd socwork.Rmd pinetrees.Rmd jays-dplyr.Rmd tomatoes.Rmd migraine.Rmd kencars.Rmd plants.Rmd crickets-b.Rmd whas.Rmd func.Rmd birthtypes.Rmd coasters.Rmd mizuna-r.Rmd hotpo.Rmd denali-r.Rmd r-signup.Rmd
%.Rmd: ~/teaching/c32/assgt/%.Rnw convert.pl
	perl convert.pl $< > $@
docs/index.html: index.Rmd
	Rscript -e "bookdown::render_book('index.Rmd')"
