using Pluto, JSON

drop_lines(x) = filter(x -> typeof(x) != LineNumberNode, x)

function to_code_cell(c::Pluto.Cell)
    ex = Meta.parse(c.code)

    source = map(x -> x * "\n", split(c.code, "\n"))

    if ex.head == :block
        ll = drop_lines(ex.args)
        source = map(x -> string(x) * "\n", ll)
    end

    source[end] = strip(source[end], ['\n'])

    return (
        cell_type="code",
        execution_count=nothing,
        metadata=Dict(),
        outputs=[],
        source=source
    )
end

function to_markdown_cell(c::Pluto.Cell)
    ex = Meta.parse(c.code)
    source = map(x -> x * "\n", split(ex.args[3], "\n"))
    source[end] = strip(source[end], ['\n'])
    return (
        cell_type="markdown",
        metadata=Dict(
            :slideshow => Dict(
                :slide_type => "subslide"
            )
        ),
        source=source,
    )
end


function cell_type(c::Pluto.Cell)
    ex = Meta.parse(c.code)

    if ex.head == :macrocall && ex.args[1] == Symbol("@md_str")
        return :markdown
    end

    return :code
end


function render_cell(c::Pluto.Cell)
    if cell_type(c) == :markdown
        return to_markdown_cell(c)
    end
    if cell_type(c) == :code
        return to_code_cell(c)
    end
end

function init_notebook()
    return (
        cells=[],
        metadata=(
            celltoolbar="Slideshow",
            kernelspec=(
                display_name="Julia 1.8.0",
                language="julia",
                name="julia-1.8"
            ),
            language_info=(
                file_extension=".jl",
                mimetype="application/julia",
                name="julia",
                version="1.8.1"
            ),
        ),
        nbformat=4,
        nbformat_minor=2
    )
end

function to_ipynb(fn::String)
    nb = Pluto.load_notebook_nobackup(fn)
    dest_name = replace(basename(fn), ".jl" => ".ipynb")
    ipynb = init_notebook()

    for id in nb.cell_order
        push!(ipynb.cells, render_cell(nb.cells_dict[id]))
    end

    open(dest_name, "w") do f
        JSON.print(f, ipynb, 2)
    end
end


function main()
    to_ipynb(ARGS[1])
end

main()
