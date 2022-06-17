# Command Line Builder
Command Line Builder is a tool to build a list of command lines from a list of files. Command Line Builder insert automatically the file names in the command line until all the file names are all used.

For example, with a file list :  
[file01.ext, .. file10.ext]

and the pattern :  
bowtie2  -1 /path/Fex[1] -2 /path/Fex[2] | samtools view -bS - > /path/Fne[1].bam


Command Line Builder produces :  

bowtie2  -1 /path/file01.ext -2 /path/file02.ext | samtools view -bS - > /path/file01.bam  
bowtie2  -1 /path/file03.ext -2 /path/file04.ext | samtools view -bS - > /path/file03.bam  
bowtie2  -1 /path/file05.ext -2 /path/file06.ext | samtools view -bS - > /path/file05.bam  
bowtie2  -1 /path/file07.ext -2 /path/file08.ext | samtools view -bS - > /path/file07.bam  
bowtie2  -1 /path/file09.ext -2 /path/file10.ext | samtools view -bS - > /path/file09.bam  

# Manual
Install [Julia](https://julialang.org/downloads/) programming language

1- edit the file config/filePath.txt
insert the path to your files

ex:
/tmp/filesDir/


2- edit the file config/cmd.txt
insert your command line
it is possible to put more than one command line, but only one per line
replace the file names by Fex[1], for the first file with extension... Fex[n], for the n file
To insert a file name without extension use Fne[n]

ex:
bowtie2  -1 /path/Fex[1] -2 /path/Fex[2] | samtools view -bS - > /path/Fne[1].bam

3- run the software with the command : julia main.jl

4- The software will substitute the Fex[n]/Fne[n] pattern with the list of files in alphabetical order
