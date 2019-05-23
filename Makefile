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
    hsb.Rmd oz-multi.Rmd nonmissing.Rmd worcester.Rmd drug-treatment.Rmd myeloma.Rmd\
    catbrain-b.Rmd ovarian.Rmd caffeine-contrast.Rmd studyhours.Rmd\
    mental-context.Rmd shirts.Rmd productivity.Rmd leprosy.Rmd urine.Rmd\
    hayfever.Rmd acidrain.Rmd caffeine.Rmd ratweight.Rmd geriatrics.Rmd airport.Rmd bodyfat2.Rmd king.Rmd rm.Rmd\
    manova1.Rmd urine.Rmd athletes-manova.Rmd swiss-money.Rmd urine2.Rmd manova1a.Rmd jobs.Rmd adhd.Rmd\
    cornseed.Rmd athletes-d.Rmd fruits.Rmd species.Rmd beer.Rmd seabed.Rmd\
    swiss-cluster.Rmd carc.Rmd decathlon.Rmd pittsburgh.Rmd college-plans.Rmd\
    vote.Rmd airpollution.Rmd weather_2014.Rmd corrmat.Rmd ipip.Rmd\
    wisconsin.Rmd stimuli.Rmd letterrec.Rmd beermds.Rmd stimuli2.Rmd ais-km.Rmd\
    different-ways.Rmd hayfever.Rmd acidrain.Rmd\
manova1.Rmd bootstrap.Rmd bootstrap_median.Rmd binomial_stan.Rmd regression_stan.Rmd
%.Rmd: ~/teaching/d29/exams/%.Rnw convert.pl
	perl convert.pl $< > $@
	Rscript -e "styler::style_file(\"$@\")"
all: index.Rmd
	Rscript -e "bookdown::render_book('index.Rmd')"
pdf: index.Rmd
	Rscript -e "bookdown::render_book(\"index.Rmd\", output_format=\"bookdown::tufte_book2\")"
ch01: index.Rmd
	Rscript -e "bookdown::preview_chapter('01-getting-used.Rmd')"
ch10: index.Rmd
	Rscript -e "bookdown::preview_chapter('10-analysis-of-variance.Rmd')"
ch15: index.Rmd
	Rscript -e "bookdown::preview_chapter('15-logistic-regression.Rmd')"
ch16: index.Rmd
	Rscript -e "bookdown::preview_chapter('16-ordinal-nominal-response.Rmd')"
ch17: index.Rmd
	Rscript -e "bookdown::preview_chapter('17-survival-analysis.Rmd')"
ch18: index.Rmd
	Rscript -e "bookdown::preview_chapter('18-anova-revisited.Rmd')"
ch19: index.Rmd
	Rscript -e "bookdown::preview_chapter('19-manova.Rmd')"
ch20: index.Rmd
	Rscript -e "bookdown::preview_chapter('20-repeated-measures.Rmd')"
ch21: index.Rmd
	Rscript -e "bookdown::preview_chapter('21-discriminant-analysis.Rmd')"
ch22: index.Rmd
	Rscript -e "bookdown::preview_chapter('22-thingy.Rmd')"
ch23: index.Rmd
	Rscript -e "bookdown::preview_chapter('23-mds.Rmd')"
ch24: index.Rmd
	Rscript -e "bookdown::preview_chapter('24-pcfa.Rmd')"
ch25: index.Rmd
	Rscript -e "bookdown::preview_chapter('25-loglin.Rmd')"

