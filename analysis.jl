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
    for arg in args
        data = Dict()
        open(arg, "r") do f
            data = JSON.parse(f)
        end
        name = basename(first(splitext(arg)))
        println("$name:\n")

        p = lineplot(log10.(data["n_series"]), log10.(data["default_n_series"]), color=:blue, title="Runtime vs. Dimension (p=0.01)", xlabel="Log10 Dimension n", ylabel="Log10 Runtime (Seconds)")
        p = scatterplot!(p, log10.(data["n_series"]), log10.(data["default_n_series"]), name="Default Schedule (+)", color=:blue, marker=:+)
        p = lineplot!(p, log10.(data["n_series"]), log10.(data["auto_n_series"]), color=:red)
        p = scatterplot!(p, log10.(data["n_series"]), log10.(data["auto_n_series"]), name="Tuned Schedule (O)", color=:red, marker=:O)
        println(p)
        println()

        p = lineplot(log10.(data["p_series"]), log10.(data["default_p_series"]), color=:blue, title="Runtime vs. Density (n=$(data["N"]))", xlabel="Log10 Density p", ylabel="Log10 Runtime (Seconds)")
        p = scatterplot!(p, log10.(data["p_series"]), log10.(data["default_p_series"]), name="Default Schedule (+)", color=:blue, marker=:+)
        p = lineplot!(p, log10.(data["p_series"]), log10.(data["auto_p_series"]), color=:red)
        p = scatterplot!(p, log10.(data["p_series"]), log10.(data["auto_p_series"]), name="Tuned Schedule (O)", color=:red, marker=:O)
        println(p)
        println()

        p = plot(title="Runtime vs. Dimension (p=0.01)", xlabel="Dimension n", ylabel="Runtime (Seconds)", xscale=:log10, yscale=:log10, legend=:topleft, titlefontsize=9, thickness_scaling=1.7)
        p = plot!(p, data["n_series"], data["default_n_series"], label="Default Schedule", markershape=:circle)
        p = plot!(p, data["n_series"], data["auto_n_series"], label="Tuned Schedule", markershape=:circle)
        Plots.savefig(p, "$(name)_figure7_dimension.png")

        p = plot(title="Runtime vs. Density (n=$(data["N"]))", xlabel="Density p", ylabel="Runtime (Seconds)", xscale=:log10, yscale=:log10, legend=:topleft, titlefontsize=9, thickness_scaling=1.7, xflip=false)
        p = plot!(p, data["p_series"], data["default_p_series"], label="Default Schedule", markershape=:circle)
        p = plot!(p, data["p_series"], data["auto_p_series"], label="Tuned Schedule", markershape=:circle)
        Plots.savefig(p, "$(name)_figure7_density.png")
    end
end

main(ARGS)
