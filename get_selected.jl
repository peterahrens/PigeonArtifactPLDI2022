using BSON
using JSON
using Statistics
using Printf
using Pigeon

function main(arg)
    data = BSON.load(arg)
    println()
    println("Selected Kernel")
    display(data["auto_kernel"])
    println()
end

main(ARGS[1])
