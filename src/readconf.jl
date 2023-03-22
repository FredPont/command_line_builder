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

# read filePath in config text file
function readPath()
    return readline("config/filePath.txt")
end

# read the files names
function readFnames()
    path = readPath()
    curdir = pwd()
    cd(path)    # if the directory is not changed files cannot be distinguished from dir
    #println("current dir : ", pwd())
    d = readdir()
    files = d[.!isdir.(d)]  # extract files and remove folders
    cd(curdir)
    return files
end

# read command file
function readCmds()
    rows = readlines("config/cmds.txt")
    cmds = Array{String,1}()
    for r in rows
        if startswith( r, "//")  # skip comments
            continue
        end
        push!(cmds, r)
    end
    return cmds
end


function writeResults(out ::String, results ::Array{String, 1})
    outfile = "results/" * out
    open(outfile, "w") do f
        for i in results
            println(f, i)
        end
    end # the file f is automatically closed after this block finishes
end