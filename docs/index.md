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

This book will hold a collection of problems, and their solutions, in applied statistics with R. These come from my courses STAC32 and STAD29 at the University of Toronto Scarborough.

The problems were originally written in Sweave (that is, LaTeX with R code chunks), using the `exam` document class. I wrote a Perl program to strip out the LaTeX and turn each problem into R Markdown for this book. You will undoubtedly see bits of LaTeX still embedded in the text. I am trying to update my program to catch them, but I am sure to miss some. If you see anything, [file an issue](https://github.com/nxskok/pasias/issues) on the Github page for now. I want to fix problems programmatically at first, but when the majority of the problems have been caught, I will certainly take pull requests. I will acknowledge all the people who catch things.

Current progress: 5 chapters (up to one-sample inference). I am catching more of the latexery. But I still seem to have too many backslashes that are refugees from the sweave.
