#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.

#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.

#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#  Written by Frederic PONT.
#  (c) Frederic Pont 2022

using Test

include("src/readconf.jl")
include("src/parseCMD.jl")

@testset "parsePatrn" begin
@test parsePatrn("Fex[1]") == ("Fex" , 1)
@test parsePatrn("Fex[42]") == ("Fex" , 42)
end

@testset "extrctPatrn" begin
@test extrctPatrn("bowtie2  -1 /path/Fex[1] -2 /path/Fex[2] | samtools view -bS - > /path/Fne[1]") == ["Fex[1]", "Fex[2]", "Fne[1]"]
@test extrctPatrn("bowtie2  -1 /path/Fex[1] -2 /path/Fex[12] | samtools view -bS - > /path/Fne[5]") == ["Fex[1]", "Fex[12]", "Fne[5]"]
end

@testset "filesPerCMD" begin
@test filesPerCMD(["Fex[1]", "Fex[2]", "Fne[1]"]) == 2
@test filesPerCMD(["Fex[1]", "Fex[2]", "Fne[3]"]) == 3
end

@testset "checkFileNB" begin
@test checkFileNB(["DSCN2727.JPG", "DSCN2728.JPG", "DSCN2729.JPG"], 1) == true
@test checkFileNB(["DSCN2727.JPG", "DSCN2728.JPG", "DSCN2729.JPG"], 3) == true
@test checkFileNB(["DSCN2727.JPG", "DSCN2728.JPG", "DSCN2729.JPG"], 2) == false
@test checkFileNB(["DSCN2727.JPG", "DSCN2728.JPG", "DSCN2729.JPG"], 4) == false
end

@testset "buildCMD" begin
@test buildCMD("ls Fex[1]", ["Fex[1]"], ["DSCN2727.JPG", "DSCN2728.JPG", "DSCN2729.JPG"]) == "ls DSCN2727.JPG"
@test buildCMD("ls Fex[1] Fex[2]", ["Fex[1]", "Fex[2]"], ["DSCN2727.JPG", "DSCN2728.JPG", "DSCN2729.JPG"]) == "ls DSCN2727.JPG DSCN2728.JPG"
@test buildCMD("bowtie2  -1 /path/Fex[1] -2 /path/Fex[2] | samtools view -bS - > /path/Fne[1].bam", ["Fex[1]", "Fex[2]", "Fne[1]"], ["DSCN2727.JPG", "DSCN2728.JPG", "DSCN2729.JPG"]) == "bowtie2  -1 /path/DSCN2727.JPG -2 /path/DSCN2728.JPG | samtools view -bS - > /path/DSCN2727.bam"


a = Array{String,1}()
for i in 1:8
    push!(a, "file" * string(i) *".ext")
end

@test buildCMD("bowtie2  -1 /path/Fex[1] -2 /path/Fex[2] | samtools view -bS - > /path/Fne[1].bam", ["Fex[1]", "Fex[2]", "Fne[1]"], a) == "bowtie2  -1 /path/file1.ext -2 /path/file2.ext | samtools view -bS - > /path/file1.bam"

end