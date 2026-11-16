#!/usr/bin/env perl

use strict ;
use warnings ;
use FindBin;
use lib "$FindBin::RealBin/../lib";
use anne_files ;

my $fasta = "archea_bacteria.fasta" ;
my $outfile = "bagel4_swissport_descriptions.table" ;


my @lines = anne_files::read_lines($fasta);
my @result = "UniRefID\tFunction\tTax";
my $count = 0 ;
foreach my $line (@lines) {
	if ($line =~ m/^>(.*?)\s(.*)\sn=\d+\sTax=(.*?)\s/) {  # swissprot
		push @result, "$1\t$2\t$3" ; 
	} elsif ($line =~ m/^>(.*?)\s\|\s(.*?)\|\s(.*)/) { # all context
		push @result, "$1\t$2\t$3" ; 
	} elsif ($line =~ m/^>(.*?)\s(.*)/) {
		push @result, "$1\t$2\t'-'" ;
	}
	$count++ if ($line =~ m/^>/) ;	
}


anne_files::write_lines($outfile, @result) ;
my $countTable = scalar @result ;
print "FastA count = $count\n Added to table  $outfile: $countTable \n" ;


# >UniRef90_P0A9N6 Pyruvate formate-lyase 1-activating enzyme n=811 RepID=PFLA_ECO57
