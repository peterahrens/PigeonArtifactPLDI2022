using Plots
gr()
using BSON
using JSON
using Statistics
using Printf
using Pigeon

function main(args)
    for name in args
        data = BSON.load(name)
        display(name)
        println()
        println("Selected Kernel")
        display(data["auto_kernel"])
        println()
    end
end

main(args)
