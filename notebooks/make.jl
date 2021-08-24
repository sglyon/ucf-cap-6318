using PlutoSliderServer

const NB_DIR = "."

# generate html files and save in correct directory
PlutoSliderServer.export_directory(NB_DIR; Export_cache_dir="pluto_export_cache", Export_output_dir="../website/content/notebooks")

# generate list of jl files
nbs = PlutoSliderServer.find_notebook_files_recursive(".")

for (root, dirs, files) in walkdir(NB_DIR)
    for_root = []
    weight = 5
    prefix_match = match(r"week(\d\d)", root)
    prefix = !isnothing(prefix_match) ? prefix_match[1] : ""
    prefix_num = length(prefix) > 0 ? parse(Int, prefix) : 0

    for (i, file) in enumerate(sort(files))
        fn = relpath(joinpath(root, file))
        suffix_match = match(r"(\d\d).+\.jl", file)
        suffix = !isnothing(suffix_match) ? suffix_match[1] : ""
        pre = length(suffix) > 0 && length(prefix) > 0 ? "$(prefix).$(suffix) " : ""
        if fn in nbs
            @show fn
            if suffix == "00"
                content = """
                ---
                title: Week $(prefix_num)
                weight:
                pre: "<b>$(prefix) </b>"
                ---

                {{< plutonotebook "$(replace(fn, ".jl" => ""))" >}}
                """
                open("../website/content/$(root)/_index.md", "w") do f print(f, content) end
            else
                content = """
                ---
                title: $(replace(file, ".jl" => "")[4:end])
                weight: $(weight * i)
                pre: "<b>$(pre) </b>"
                ---

                {{< plutonotebook "$(replace(fn, ".jl" => ""))" >}}
                """
                open("../website/content/$(replace(fn, ".jl" => ".md"))", "w") do f print(f, content) end
            end
            push!(for_root, fn)
        end
    end
    println("For directory $(root) we have these files:")
    foreach(println, for_root)
end

