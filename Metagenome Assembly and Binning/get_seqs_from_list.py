#!/usr/bin/python

#This script was writen by Francois Bucchini in Ghent April/2017 and customized by L. Felipe Benites in Banyuls sur mer Dec/2017. It subsets a FASTA file (sys.argv[1]), keep only those that are wanted (list of IDs, sys.argv[2]), and output a fasta file with the list od IDs file name

#Usage ./get_seqs_from_list.py <bigfile.fasta> <id_list> or python get_sequence_subset.py <bigfile.fasta> <id_list.txt>

from Bio import SeqIO
import sys

wanted_seq = [line.strip() for line in open(sys.argv[2])]
seq_iter = SeqIO.parse(open(sys.argv[1]), 'fasta')
SeqIO.write((seq for seq in seq_iter if seq.id in wanted_seq), sys.argv[2]+'.fasta', "fasta")
