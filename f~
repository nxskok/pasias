#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

# find matches for input text, open emacs on chosen file at that line

main(@ARGV);

sub main {
  my $line=listmatches(@ARGV);
  my ($file,$number)=split /:/, $line;
  say "File: $file, line number $number.";
  system "emacsclient -c +$number $file &";
}

sub listmatches {
  my ($phrase)=@_;
  my @out=qx/grep -n \"$phrase\" *.Rnw/;
  for my $i (0..$#out) {
    print "*** $i: $out[$i]";
  }
  print "\nChoice: ";
  my $choice=<STDIN>;
  chomp $choice;
  print "\nYou chose option $choice which is $out[$choice]\n";
  return $out[$choice];
}
