# euler-refgenie

<div>
<img src="assets/eth_logo.png" alt="Jupyterhub logo" title="Jupyterhub logo" width="150" style="vertical-align: top;">
&nbsp;
<img src="assets/refgenie_logo.png" alt="ETH Zurich logo" title="ETH Zurich logo" width="150" style="vertical-align: top;">
&nbsp;
<div/>

<div>
&nbsp;
<div/>

This repository hosts scripts for building refgenie assets for various reference genomes. Designed for the ETH Zürich Euler cluster, these scripts are adaptable for use on other systems as well.

To facilitate ease of use and ensure compatibility, we've packaged refgenie along with all necessary dependencies within a Docker container. This approach eliminates the need for local dependency management. You can find the container here: [josousa/refgenie on Docker Hub](https://hub.docker.com/r/josousa/refgenie).

## Building the Assets

### Step 1: Set Up Environment Variables

First, create an environment file containing essential variables for your reference genome:

```bash
export SPECIES="homo_sapiens"
export GENOME_NAME="Homo_sapiens_GRCh38_p14"
export GENOME_DESCRIPTION="Homo sapiens GRCh38.p14 (GCA_000001405.29)"
export ENSEMBL_RELEASE="112"
export FASTA_FILENAME="Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz"
export ENSEMBL_GTF_FILENAME="Homo_sapiens.GRCh38.${ENSEMBL_RELEASE}.gtf.gz"
export ENSEMBL_GFF_FILENAME="Homo_sapiens.GRCh38.${ENSEMBL_RELEASE}.gff3.gz"
export BLACKLIST_FILENAME="ENCFF356LFX.bed.gz"

export TAG="ensembl_release_${ENSEMBL_RELEASE}"
export TAG_DESCRIPTION="Downloaded from Ensembl release ${ENSEMBL_RELEASE}"
export FASTA_FILE="ftp.ensembl.org/pub/release-${ENSEMBL_RELEASE}/fasta/${SPECIES}/dna/${FASTA_FILENAME}"
export ENSEMBL_GTF_FILE="ftp.ensembl.org/pub/release-${ENSEMBL_RELEASE}/gtf/${SPECIES}/${ENSEMBL_GTF_FILENAME}"
export ENSEMBL_GFF_FILE="ftp.ensembl.org/pub/release-${ENSEMBL_RELEASE}/gff3/${SPECIES}/${ENSEMBL_GFF_FILENAME}"
export BLACKLIST_FILE="https://www.encodeproject.org/files/ENCFF356LFX/@@download/${BLACKLIST_FILENAME}"
```

Note: The blacklist and GFF variables are optional.

The files can be links to download or local files already downloaded.

### Step 2: Build the Assets

To create assets such as `fasta`, `fasta_txome`, `ensembl_gtf`, `ensembl_rb`, and `blacklist`, run:

```bash
base_refgenie_build -e <path to your environment file>
```

### Step 3: Index Building

For index building, a similar approach is used. For instance, to build a Bowtie2 index:

```bash
bowtie2_index_build -e <path to your environment file>
```

This command initiates a SLURM batch job for each index with the `--map` flag.

### Important Note

After completing each index build, it's crucial to run `refgenie build --reduce` to finalize the genome build. If you're constructing multiple indexes concurrently, ensure all builds are complete before running the reduce command. This precaution helps prevent build conflicts.
