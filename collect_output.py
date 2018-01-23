from itertools import islice
from os import path

current_path = path.dirname(path.abspath(__file__))

sra_accessions = {}
with open(path.join(current_path, 'SC3', 'test', 'sra.txt')) as f:
    for line in f:
        temp = line.rstrip('\n')
        sra, disease = temp.split('\t')
        sra_accessions[sra] = disease

out = 'Disease State,SRA,Heterozygous SNPs,Homozygous SNPs\n'
for sra in sra_accessions:
    with open(path.join(current_path, 'SC3', 'test', 'out', sra, 'results.tsv')) as f:
        for line in islice(f, 1, None):
            temp = sra_accessions[sra] + line.split('\t')
            out += ','.join(line)

with open(path.join(current_path, 'test.csv'), 'w') as fout:
    fout.write(out)
