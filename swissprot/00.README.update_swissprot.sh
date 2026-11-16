# retrieve data from http://www.uniprot.org
# Select reviewed only
# Select Taxonomy Archea and Bacteria
# Select UniRef 90%

# download query at UniProt
	# uniprot:(taxonomy:"Archaea [2157]" reviewed:yes) AND identity:0.9
	# uniprot:(taxonomy:"Bacteria [2]" reviewed:yes) AND identity:0.9


# copy files to /data/bagel4/swissprot
cd /data/bagel4/swissprot

# unpack rename and cat the two databases
cat archea.fasta bacteria.fasta ../db_proteins/all_context_db.fasta > archea_bacteria.fasta

#cat archea.tab bacteria.tab > archea_bacteria.tab
# NOTE: change in header in the tab: replace name by _name. Meaning that there are no spaces in the header names

# Unpack and rename and format db
makeblastdb -in archea_bacteria.fasta -dbtype prot -out archea_bacteria

# make the description file ==> bagel4_swissport_descriptions.table
./bagel4_make_swissprot_descriptions.pl


# add BAGEL context PFAM annotation ==> bagel4_swissport_descriptions_pfams.table
./bagel4_add_context_pfams.pl




# test
cd /data/bagel4/swissprot
time blastp -num_threads 4 -query example_opp.fasta -db bacteria -outfmt 6 -max_target_seqs 1 

