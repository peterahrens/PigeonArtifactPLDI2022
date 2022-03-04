#using Plots
using UnicodePlots
using Plots
gr()
using BSON
using JSON
using Statistics
using PrettyTables

function main(args)
    println("figure 6:")
    figure6 = open("figure6.txt", "w")
    header = (
        ["Kernel", "Min-Depth", "Undominated", "Min-Depth", "Undominated", "Asymptotic"],
        ["",       "Schedules", "Schedules",   "Schedules", "Schedules",   "Filter"],
        ["",       "",          "",            "(TACO)",    "(TACO)",      "Runtime"],
    )
    table = Array{Any}(undef, 0, 6)
    for arg in args
        data = Dict()
        open(arg, "r") do f
            data = JSON.parse(f)
        end
        name = basename(first(splitext(arg)))
        row = [
            name,
            get(data, "universe_length", "TIMEOUT"),
            get(data, "frontier_length", "TIMEOUT"),
            data["tacoverse_length"],
            data["tacotier_length"],
            data["tacotier_filter_time"] / data["tacoverse_length"],
        ]
        table = vcat(table, permutedims(row))
    end
    pretty_table(table, header=header)
    pretty_table(figure6, table, header=header)
    close(figure6)

    println("figure 7")
    figure7 = open("figure7.txt", "w")
    for arg in args
        data = Dict()
        open(arg, "r") do f
            data = JSON.parse(f)
        end
        name = basename(first(splitext(arg)))
        println("$name:\n")
        println(figure7, "$name:\n")

        p = lineplot(log10.(data["n_series"]), log10.(data["default_n_series"]), color=:blue, title="Runtime vs. Dimension (p=0.01)", xlabel="Log10 Dimension n", ylabel="Log10 Runtime (Seconds)")
        p = scatterplot!(p, log10.(data["n_series"]), log10.(data["default_n_series"]), name="Default Schedule (+)", color=:blue, marker=:+)
        p = lineplot!(p, log10.(data["n_series"]), log10.(data["auto_n_series"]), color=:red)
        p = scatterplot!(p, log10.(data["n_series"]), log10.(data["auto_n_series"]), name="Tuned Schedule (O)", color=:red, marker=:O)
        println(p)
        println()
        show(figure7, p)
        println(figure7, "\n")

        p = lineplot(log10.(data["p_series"]), log10.(data["default_p_series"]), color=:blue, title="Runtime vs. Density (n=$(data["N"]))", xlabel="Log10 Density p", ylabel="Log10 Runtime (Seconds)")
        p = scatterplot!(p, log10.(data["p_series"]), log10.(data["default_p_series"]), name="Default Schedule (+)", color=:blue, marker=:+)
        p = lineplot!(p, log10.(data["p_series"]), log10.(data["auto_p_series"]), color=:red)
        p = scatterplot!(p, log10.(data["p_series"]), log10.(data["auto_p_series"]), name="Tuned Schedule (O)", color=:red, marker=:O)
        println(p)
        println()
        show(figure7, p)
        println(figure7, "\n")
    end
    close(figure7)
end

main(ARGS)
