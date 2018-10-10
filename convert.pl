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
    $content=~s/\n\s\s+/\n/g;
    $content=~s/\\question/\n## Question title\n\n/g;
    $content=~s/\\begin\{parts\}//g;
    $content=~s/\\end\{parts\}//g;
    $content=~s/\\begin\{select\}//g;
    $content=~s/\\end\{select\}//g;
    $content=~s/\\end\{solution\}//g;
    $content=~s/\\begin\{center\}//g;
    $content=~s/\\end\{center\}//g;

    # quotes

    $content=~s/``(.*?)''/"$1"/g;
	
    
    $content=~s/\\part/\nNextyy part/g;
    $content=~s/\\begin\{solution\}/\nSolution\n\n/g;

    $content=~s/<<(.*)>>=/```\{r $1\}/g;
    $content=~s/@/```/g;
    # text formatting

    $content=~s/\\texttt\{(.*?)\}/`$1`/g;
    $content=~s/\\emph\{(.*?)\}/*$1*/g;
    $content=~s/\\textbf\{(.*?)\}/**$1**/g;

    $content=~s/\\includegraphics\[*.*\]\{(.*)\}/![]($1.png)/g;
    $content=~s/\\url\{(.*)\}/\[$1\]($1)/g;
    $content=~s/\\begin\{verbatim\}/\n```\n/g;
    $content=~s/\\end\{verbatim\}/\n```\n/g;

    # number the parts

    for my $i (1..20) {
	if ($content=~/Nextyy part/) {
	    my $replacement="($letters[$i])";
	    $content=~s/Nextyy part/$replacement/;
	}
    }


    # any stray backslashes, get rid of

    $content=~s/\\//g;

    # any stray comments

    $content=~s/\$\%//g;
    $content=~s/\n\s*\%/\n/g;

    
    say $content;
}
