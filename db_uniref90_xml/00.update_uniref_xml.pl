#!/usr/bin/env perl

use strict ;
use warnings ;
use FindBin;
use lib "$FindBin::RealBin/../lib";
use anne_files ;
use File::Basename;
use LWP::Simple;


# Routine to download/update all bagel uniprot xml files

my $sessiondir = '.';

my $usage = "options:
				-s Sessiondir [default=current folder]
		e.g.  ./00.update_uniref_xml -s /data/bagel4/test -i webblast_query.faa 
		
		
		Routine to download/update all bagel uniprot xml files
		
\n - Anne de Jong - \n" ;



&parseparam() ;
# ------------------------------------------------------------------  functions  ----------------------------------------------------------------


my %table = anne_files::read_table_to_hash('../db_proteins/bagel4_class1bacteriocin_db.txt','../db_proteins/bagel4_class2bacteriocin_db.txt') ;
foreach my $key (sort keys %table) {
	my $uniprot = $table{$key}{Uniprot} ;
	if ( $uniprot ne '') {
		print "$key\t$uniprot\n";
		my $url = "http://www.uniprot.org/uniprot/$uniprot.xml" ;
		my $xml = get($url);
		anne_files::write_string("$uniprot.xml", $xml) ;
	}	
}	

sub parseparam {
    my $var ;
    my @arg = @ARGV ;
    while(@arg) {
        $var = shift(@arg) ;
        die $usage if ($var eq '-h' or $var eq '--help') ;
        $sessiondir = shift(@arg) if($var eq '-s') ;
    }
    #die $usage if (!$query) ;
}


