use strict;
use warnings;
use 5.010;
use Data::Dumper;

main(@ARGV);

sub main {
    my @rmd=`ls *.Rmd`;
    my %rmd=map { ( $_, -m ) } @rmd;
    print Dumper (\%rmd);
#     my @name_rmd=map { local $_=$_ ; s/^(.*)\.Rmd/$1/ ; $_ } @rmd;
#     my @rnw=`ls ~/teaching/c32/assgt/*.Rnw`;
#     my @name_rnw=map {  local $_=$_ ; s/\/home\/ken\/teaching\/c32\/assgt\/(.*)\.Rnw/$1/ ; $_ } @rnw;
}
