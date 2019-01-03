use strict;
use warnings;
use File::Slurp;
use 5.010;

main(@ARGV);

sub main {
    my $filename=shift;
    my $content=read_file($filename);
    my @letters=("null","a".."z"); # array starts at zero
    # change all the things in content
    $content=~s/^\%\%(.*)/## $1\n/g;
    $content=~s/\n\s\s+/\n/g;
    $content=~s/\\question/\n\n/g;
    $content=~s/\\begin\{parts\}//g;
    $content=~s/\\end\{parts\}//g;
    $content=~s/\\begin\{select\}//g;
    $content=~s/\\end\{select\}//g;
    $content=~s/\\end\{solution\}//g;
    $content=~s/\\begin\{center\}//g;
    $content=~s/\\end\{center\}//g;
    $content=~s/\\verb(.)(.*?)\1/`$2`/g;
    $content=~s/\\begin\{itemize\}//g;
    $content=~s/\\end\{itemize\}//g;
    $content=~s/\\begin\{enumerate\}//g;
    $content=~s/\\end\{enumerate\}//g;
    $content=~s/\\item\s(.*)/\n* $1/g;
    $content=~s/\\endnote\{(.*)\}/\n`r tufte::margin_note(\"$1\")`/g;
    # alert me to the need to fix up references (HTML seems to work if done properly)
    $content=~s/\\label\{(.*?)\}/<a name=\"$1\">*<\/a>/g;
    $content=~s/\\ref\{(.*?)\}/<a href=\"\#$1\">here<\/a>/g;
    
    # quotes

    $content=~s/``(.*?)''/"$1"/g; # in the original, all on one line
	
	  # block quotes?
    
    $content=~s/\\part/\nNextyy part/g;
    $content=~s/\\begin\{solution\}/\nSolution\n\n/g;

    $content=~s/\n<<(.*)>>=/\n```\{r $1\}/g;
    $content=~s/\n@/\n```\n\n/g;
    # text formatting

    $content=~s/\\texttt\{(.*?)\}/`$1`/g;
    $content=~s/\\emph\{(.*?)\}/*$1*/g;
    $content=~s/\\textbf\{(.*?)\}/**$1**/g;
    $content=~s/\\textsl\{(.*?)\}/*$1*/g;

    $content=~s/\\includegraphics\[*.*\]\{(.*)\}/\n![]($1.png)\n/g;
    $content=~s/\\url\{(.*)\}/\[link\]($1)/g;
    $content=~s/\\begin\{verbatim\}/\n```\n/g;
    $content=~s/\\end\{verbatim\}/\n```\n/g;

    # inline R code
    
    $content=~s/\\Sexpr\{(.*)\}/`r $1`/g;

    # no backslashes in quotes (do it twice)

    $content=~s/`(.*)\\(.*)`/`$1$2`/g;
    $content=~s/`(.*)\\(.*)`/`$1$2`/g;
    $content=~s/eg.\\/eg./g;

    # number the parts

    for my $i (1..20) {
	if ($content=~/Nextyy part/) {
	    my $replacement="($letters[$i])";
	    $content=~s/Nextyy part/$replacement/;
	}
    }


    # any stray backslashes, get rid of (not yet)

    # $content=~s/\\//g;

    # any stray comments

    $content=~s/\$\%//g;
    $content=~s/\n\s*\%/\n/g;

    
    say $content;
}
