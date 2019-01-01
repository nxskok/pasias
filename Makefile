.PHONY: rmds
rmds: carp.Rmd socwork.Rmd pinetrees.Rmd jays-dplyr.Rmd tomatoes.Rmd migraine.Rmd kencars.Rmd plants.Rmd crickets-b.Rmd\
    whas.Rmd func.Rmd birthtypes.Rmd coasters.Rmd mizuna-r.Rmd hotpo.Rmd denali-r.Rmd r-signup.Rmd bikes.Rmd billboard.Rmd\
    throw-spaghetti.Rmd throw.Rmd bodyfat.Rmd bodyfat-sign.Rmd baseball-softball.Rmd salaryinc.Rmd proportion-power-sim.Rmd\
    whas.Rmd r-signup.Rmd mathphobia.Rmd movies2.Rmd crickets.Rmd carbon.Rmd county.Rmd deer.Rmd ethanol.Rmd forehead.Rmd\
    ftccigar.Rmd movies-r.Rmd sparrowhawk.Rmd youngboys.Rmd global.Rmd soap.Rmd ncbirths.Rmd ncbirths-inf.Rmd nenana.Rmd\
    nenana-inf.Rmd oj.Rmd parking.Rmd maze.Rmd fbfriends.Rmd heat-r.Rmd thomas.Rmd boulder.Rmd bellpepper.Rmd mousebully.Rmd\
    diabetic.Rmd tortoise.Rmd pizza.Rmd hospital.Rmd mathsal.Rmd kids-diet.Rmd gpa.Rmd fire_damage.Rmd chemical.Rmd\
    wolfspider.Rmd aphids.Rmd doseresponse.Rmd parasite.Rmd ethics.Rmd heart.Rmd breastfeed.Rmd donner.Rmd heart.Rmd\
    apache.Rmd ha2.Rmd mobile.Rmd abortion.Rmd ess.Rmd alligator.Rmd steak-data.Rmd sfcrime-data.Rmd steak.Rmd sfcrime.Rmd\
    hsb.Rmd oz-multi.Rmd
%.Rmd: ~/teaching/d29/exams/%.Rnw convert.pl
	perl convert.pl $< > $@
docs/index.html: index.Rmd
	Rscript -e "bookdown::render_book('index.Rmd')"
pasias.pdf: index.Rmd
	Rscript -e "bookdown::render_book(\"index.Rmd\", output_format=\"bookdown::tufte_book2\")"
docs/ordinal-nominal-response.html: index.Rmd
	Rscript -e "bookdown::preview_chapter('16-ordinal-nominal-response.Rmd')"
