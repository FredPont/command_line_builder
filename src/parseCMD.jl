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

# parsePatrn("Fex[1]") == "Fex", 1
function parsePatrn(pattern)::Tuple{String,Int}
    r = split(pattern, r"[\[\]]")
    pat = r[1]
    nb = parse(Int,r[2])
    return pat, nb
end

# extrctPatrn("bowtie2  -1 /path/Fex[1] -2 /path/Fex[2] | samtools view -bS - > /path/Fne[1]") == ["Fex[1]", "Fex[2]", "Fne[1]"]
function extrctPatrn(str)
    res = Array{String,1}()
    rx = r"Fex\[\d+\]|Fne\[\d+\]"
    m = eachmatch(rx, str)
    for pat in m
        push!(res, pat.match)
    end
    return res
end

# filesPerCMD count the number of file needed for the cmd line
function filesPerCMD(patterns ::Array{String,1})
    max = 0
    for p in patterns
        (_, nb) = parsePatrn(p)
        if nb > max
            max = nb
        end
    end
    return max
    
end

# checkFileNB verify if the number of file is a multiple of the files/cmd
function checkFileNB(filenames, nb)
    return length(filenames) % nb == 0
end

# buildCMD replace the pattern by the filenames in cmd
function buildCMD(cmd, patterns, filenames)
    for pat in patterns
        prefix, nb = parsePatrn(pat)
        if prefix == "Fex"
            cmd = replace(cmd, pat => filenames[nb])
        elseif prefix == "Fne"
            # get the filename before the first dot x.tar.gz => x
            fn = split(filenames[nb], ".")
            cmd = replace(cmd, pat => fn[1])
        else
            error("pattern ", pat, " not found in command line")
        end
    end
    return cmd
end

# main function to process files
function processFiles(filenames)
    cmds = readCmds()   # cmd lines to process

    for (ct, cmd) in enumerate(cmds)
        results = Array{String, 1}()
        patterns = extrctPatrn(cmd)         # get the patterns from cmd line
        fperCmd = filesPerCMD(patterns)     # files needed for cmd
        println(ct, "/", length(cmds))
        checkFileNB(filenames, fperCmd) || error("files number, ", length(filenames), " is not a multiple of files per cmd, " , fperCmd)
        
        for i in Iterators.countfrom(1, fperCmd)
            i > length(filenames) && break
            #println(filenames[i : i+fperCmd-1])
            finalCmd = buildCMD(cmd, patterns, filenames[i : i+fperCmd-1])
            println(finalCmd)
            push!(results, finalCmd)
        end
        writeResults("cmd_" * string(ct) * ".txt", results)
    end
    
end