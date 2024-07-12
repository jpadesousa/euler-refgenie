#!/bin/bash

# Define base URL
base_url="https://ftp.ensembl.org/pub/release-112/fasta/bos_taurus/dna/"

# List of chromosomes or parts to download
declare -a parts=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "X" "MT")

# Loop through each part and download it
for part in "${parts[@]}"; do
    wget "${base_url}Bos_taurus.ARS-UCD1.3.dna_sm.primary_assembly.${part}.fa.gz"
done

# Create a temporary directory for decompressed files
temp_dir=$(mktemp -d)
trap "rm -rf ${temp_dir}" EXIT

# Decompress each part into the temporary directory and concatenate
for part in "${parts[@]}"; do
    gzip -cd "Bos_taurus.ARS-UCD1.3.dna_sm.primary_assembly.${part}.fa.gz" >> "${temp_dir}/Bos_taurus.ARS-UCD1.3.dna_sm.primary_assembly.fa"
done

# Recompress the concatenated file
gzip "${temp_dir}/Bos_taurus.ARS-UCD1.3.dna_sm.primary_assembly.fa"

# Move the final compressed file back to the current directory
mv "${temp_dir}/Bos_taurus.ARS-UCD1.3.dna_sm.primary_assembly.fa.gz" .

# Clean up downloaded parts
for part in "${parts[@]}"; do
    rm -f "Bos_taurus.ARS-UCD1.3.dna_sm.primary_assembly.${part}.fa.gz"
done

# Verify if all chromosomes are present in the final file
echo "Verifying chromosomes in the concatenated file:"
for part in "${parts[@]}"; do
    if ! zgrep -q ">${part} " "Bos_taurus.ARS-UCD1.3.dna_sm.primary_assembly.fa.gz"; then
        echo "Chromosome ${part} is missing."
    else
        echo "Chromosome ${part} is present."
    fi
done