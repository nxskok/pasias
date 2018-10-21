---
title: "Problems and Solutions in Applied Statistics"
author: "Ken Butler"
date: "2018-10-09"
site: bookdown::bookdown_site
documentclass: book
bibliography: []
biblio-style: apalike
link-citations: yes
github-repo: nxskok/pasias
url: 'http://ritsokiguess.site/pasias'
description: "A set of problems and solutions, in R, on various parts of applied statistics"
---

# Introduction


This book will hold a collection of problems, and my solutions to them, in applied statistics with R. These come from my courses STAC32 and STAD29 at the University of Toronto Scarborough.

The problems were originally written in Sweave (that is, LaTeX with R code chunks), using the `exam` document class. I wrote [a Perl program](https://raw.githubusercontent.com/nxskok/pasias/master/convert.pl) to strip out the LaTeX and turn each problem into R Markdown for this book. You will undoubtedly see bits of LaTeX still embedded in the text. I am trying to update my program to catch them, but I am sure to miss some. If you see anything, [file an issue](https://github.com/nxskok/pasias/issues) on the Github page for now. I want to fix problems programmatically at first, but when the majority of the problems have been caught, I will certainly take pull requests. I will acknowledge all the people who catch things.

It looks as if everything compiles, but how does it look?

The next thing to nail down is converting LaTeX cross-references to R Markdown ones. Some reading required first. (I refer to other parts in the questions from time to time, and I want to do that properly in case I add new parts.) I am stuck as to how to do that. I can translate a `\label` into HTML as `<a name="thing"></a>`, and I can refer to it with `[my_thing](#thing)`, and it works, but `\ref{part:this}` is trickier, because I need not just the `part:this` (which gains a `#` on the front and goes in the `()` brackets), but  I need something like `(c)` to go into the `my_thing` slot, and I don't know how to get that programmatically, since that seems internal to LaTeX.

I don't think `pandoc` can help me here, because I can't even get it to convert the output of Sweave (a `.tex` file) into Markdown.

I have an extremely hacky "solution" to this for now: replace any `\ref{}` I find with `????` in the R Markdown, so that when I see it, I can hand-convert it. Ugh.

<= a7 done. There don't seem to be many ordinary regressions yet (most of them are tied up into writing reports).

Sparrowhawks question may still need some attention. Idea: use screenshots of the R Markdown of the report.
