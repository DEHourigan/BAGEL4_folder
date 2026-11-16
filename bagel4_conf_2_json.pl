#!/usr/bin/env perl


# Convert the bagel4.conf to json

# depends on MOODS 


use strict ;
use warnings ;
use FindBin;
use lib "$FindBin::RealBin/lib";
use bagel4_functions ;
use anne_files ;
use anne_misc ;
use File::Basename;
use JSON qw(encode_json);


# ---------------------------------------------------------- parameters -------------------------------------------------------------------------

my $sessiondir = '.';
my $program_dir = dirname($0) ;
my $fna_file  ;
my $outfile = 'promoterscan.table' ;
my $usage = "option:
		-s		sessiondir [default=$sessiondir]

				
	Conver the bagel4.conf to bagel4.conf.json
				
	e.g.  /data/bagel4/bagel4_conf_2_json.pl -s /tmp/BAGEL4WRAPPER/test	
" ;
my %conf = bagel4_functions::read_conf("$program_dir/bagel4.conf") ;

&parseparam() ;

# ---------------------------------------------------------- main -------------------------------------------------------------------------


foreach my $key (keys %conf) {
	$conf{$key} = 0 + $conf{$key} if $conf{$key} =~ /^-?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$/;
}
anne_files::write_lines("$sessiondir/bagel4.conf.json", encode_json({ bagel4_conf => \%conf }));

# ---------------------------------------------------------- functions -------------------------------------------------------------------------

sub parseparam {
    my $var ;
    my @arg = @ARGV ;
    while(@arg) {
        $var = shift(@arg) ;
        die $usage if ($var eq '-h' or $var eq '--help') ;
		$sessiondir		= shift(@arg) if($var eq '-s') ;
    }
}

