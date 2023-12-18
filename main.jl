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

# usage : julia main.jl filenames.csv 
#      or julia main.jl (filenames are read on the disk from the path in filePath.txt file)

using DelimitedFiles

include("src/readconf.jl")
include("src/parseCMD.jl")

function main()
    T0 = time()
    filenames = Array{String, 1}()
    # read files
    if length(ARGS) == 0
        filenames = readFnames() # without arguments, the filenames are read from the filePath.txt file
    else
        filenames = readdlm(ARGS[1]) # with argument, the filenames are read from the file used as argument
        filenames = filter(!=(" "), filenames) # remove empty string
        #println(filenames)
        sort!(filenames)
    end
    processFiles(filenames)
    println("Elapsed time : ", time()-T0, " sec")
end


function title()

	println("   ┌───────────────────────────────────────────────────┐") # unicode U+250C
	println("   │    Command Line Builder (c)Frederic PONT 2022     │")
	println("   │     Free Software GNU General Public License      │")
	println("   └───────────────────────────────────────────────────┘")

end

title()

main()