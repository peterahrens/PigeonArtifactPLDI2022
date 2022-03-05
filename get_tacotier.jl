using BSON
using JSON
using Statistics
using Printf
using Pigeon

function main(arg)
    data = BSON.load(arg)
    println()
    foreach(display, data["tacotier"])
    println()
end

main(ARGS[1])
