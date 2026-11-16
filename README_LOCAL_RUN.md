# Running this copy of BAGEL4

Use the `bagel4` Conda environment before running the wrapper. The environment
provides Perl dependencies, Python 2.7 for the bundled MOODS extensions, and
legacy BLAST `formatdb`. Copying individual Conda executables is not sufficient
to copy their interpreters, shared libraries and Perl modules. The included
`environment-bagel4.yml` records the working environment's explicitly requested
packages without a machine-specific prefix. It can be used to create an
environment on another machine with `conda env create -f environment-bagel4.yml`.
Recreation has not been tested and may require adjustments for another platform.

From this directory, activate the environment and run:

```sh
conda activate bagel4
perl bagel4_wrapper.pl -s my_results -query test_in -r '*.fna'
```

Quote the pattern so the shell does not expand it before the wrapper sees it.
Use a new results directory for each run. The script can also be invoked by its
absolute path from another working directory; use absolute paths for the input
and results in that case. The pipeline invokes shell commands without quoting
all paths, so avoid spaces or shell metacharacters in installation, input and
results paths.

`bagel4.conf` in this directory is the source configuration. The tool directories
are relative to that file; database paths are relative to the installation.
Bundled Linux binaries are used for BLAST+, HMMER, Glimmer and Transterm, and
the MOODS Python package is bundled. They are platform-specific, not guaranteed
to run on other operating systems or CPU architectures. Keep their databases,
parameter files and symlinks together when moving this directory. The active
environment must also provide `formatdb` for the ORF-search stage.

The wrapper generates `bagel4.conf.json` in each results directory from the
source configuration; it is a snapshot, not an input configuration. Resolved
tool paths in that snapshot describe the installation at the time of the run.
The JSON in the installation directory is likewise generated and can be
regenerated with `perl bagel4_conf_2_json.pl -s .`.

The optional web-server, RNA-seq example, database-update and Pfam workflows
may require additional site-specific data and dependencies. They are not
needed for the standard genome test above.
The legacy prescan script currently has a pre-existing Perl compilation error;
some older tools also require a separate `genomics.pm` library not in this copy.