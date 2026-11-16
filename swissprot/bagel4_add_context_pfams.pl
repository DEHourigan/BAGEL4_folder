#!/usr/bin/perl

use strict ;
use warnings ;
use FindBin;
use lib "$FindBin::RealBin/../lib";
use bagel4_functions ;
use anne_files ;
use File::Basename;

my %conf = bagel4_functions::read_conf("$FindBin::RealBin/../bagel4.conf") ;
my $domT = $conf{domT} ; # PFAM score cutoff --domT
my $cpu = $conf{cpu} ;


my $faa_file = 'archea_bacteria.fasta' ;



# 1. Read context hmms
	my %context_hmms = anne_files::read_table_to_hash("../tables/context_hmm.txt");

# 3. Screen the swissprot database for the context pfams	
	my @result_files = hmmsearch() ;
	anne_files::print_lines(@result_files) ;



# 4. Add pfam to swissprot descriptions
	my %descriptions = anne_files::read_table_to_hash('bagel4_swissport_descriptions.table') ;
	my %context_hmm_results ;
	foreach my $file (@result_files) { get_context_hmm_results($file) ;	}	# data will be stored in %context_hmm_results 


	
# 5. Print results
	my @table = "UniRefID\tFunction\tTax\tPFAMS" ;
	foreach my $key (sort keys %descriptions) {   # $key = UniRef ID
		#print "$key\n";
		my $pfams = '';
		if (defined($context_hmm_results{$key})) {
			$pfams = $context_hmm_results{$key}  ;
			print "$key\t$pfams\n";
		}	
		push @table, "$descriptions{$key}{UniRefID}\t$descriptions{$key}{Function}\t$descriptions{$key}{Tax}\t$pfams" ;
	}
	anne_files::write_lines('bagel4_swissport_descriptions_pfams.table', @table);
	print "PFAMS added, new table name = 'bagel4_swissport_descriptions_pfams.table'\n";
	
	
# ------------------------------------------------------------------------------------- functions -------------------------------------------------------------------------------	


sub get_context_hmm_results {
	my $file = shift ;
	my $pfam = $file ;
	$pfam =~ s/result\.// ;
	$pfam =~ s/\.domtblout// ;
	my @lines = anne_files::read_lines($file) ;
	foreach my $line (@lines) {
		#if ($line =~ m/^(UniRef90.*?)\s+/) {
		if ($line !~ m/^#/) {
			if ($line =~ m/^(.*?)\s+/) {
				if (!defined($context_hmm_results{$1})) {
					$context_hmm_results{$1} = $pfam ;
				} else {
					$context_hmm_results{$1} = $context_hmm_results{$1}.';'.$pfam ; 
				}
			}	
		}	
	}
}
	
sub hmmsearch {
	my @result_files ;
	foreach my $context_hmm ( keys %context_hmms ) {
		my $domtblout = "result.$context_hmm.domtblout";
		push (@result_files, $domtblout) ;
		my $tmp = "$conf{hmmsearch}/hmmsearch --noali --cpu $cpu --domtblout $domtblout --domT $domT ../db_hmm/$context_hmm.hmm $faa_file >>result.logfile.txt" ;
		system($tmp) ;
	}
	return @result_files ;
}

