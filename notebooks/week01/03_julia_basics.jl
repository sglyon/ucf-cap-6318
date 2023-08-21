### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ c9115768-9392-4f7a-add0-d92629fdfe0b
using Distributions

# ╔═╡ 94be61b6-024d-466d-9d48-0d1d52a5ff8a
using DataFrames

# ╔═╡ 09480927-e85a-4e5e-836e-22aa95a18723
using PlotlyBase

# ╔═╡ c411d524-041b-11ec-1863-8b1d11a9e04c
md"""
# Julia Basics



**Prerequisites**

- Laptop or personal computer with internet connection

**Outcomes**

- Understand the main benefits and features of Julia
- See how to define variables, functions, and types in Julia
- Install commonly used packages for Graphs, DataFrames, Plotting and more

**References**

- [Packages and Software Engineering](https://julia.quantecon.org/more_julia/index.html) section of QuantEcon julia lectures
"""

# ╔═╡ 617ee5d8-4ad3-4235-bc19-6fdfc7600464
md"""
## What is Julia?

- Julia is a relatively new programming language (first public release in 2012, 1.0 release in 2018)
- General purpose, but specializes in numerical computation
- Leverages advanced compiler technology to generate very efficient code
- It can be as clear to read and write as Python, and as quick to evaluate as C!
"""

# ╔═╡ 2d5d5219-a008-4150-8421-2ec19be6eea6
md"""
# Core Types

- We'll start by learning about the core datatypes built in to Julia
- Along the way we'll pick up some of the key syntax elements
- We will move quickly, so some prior programming experience would be helpful
"""

# ╔═╡ 257d08da-7e03-4522-930e-3b3dbe0a20f6
md"""
## Numbers

- Let's start with numbers
- Two work with a number, just type it!
"""

# ╔═╡ 413bfb6c-d875-4020-86bf-f0452b588bfa
42

# ╔═╡ 538f2a00-9995-4f5b-b34a-60897ddd4338
md"- We can also do basic arithmetic in the way you would expect"

# ╔═╡ 175565e0-9307-42e8-ba15-b0dd51c51976
10 * 3

# ╔═╡ 0da147f5-0cec-4af9-9bbd-aeb9ad537629
1 + 2

# ╔═╡ ba9f4de7-7a60-409f-8986-2a345b7d498b
md"""

- So far we've worked with integers (whole numbers)
- Julia can also work with numbers containing a decimal
- In Julia these are called floating point numbers
"""

# ╔═╡ 22298b46-6f21-49ee-a935-005fbc865ecc
1.234 ^ 2.2

# ╔═╡ 6dd6cd99-5483-4812-b783-218aa0ee2dcd
553.34 / 12.9

# ╔═╡ 4c19b685-eb43-43c7-81b0-a2e5f81f04e4
md"""
- We can mix and match integers and floats
"""

# ╔═╡ 0cd7bfbd-c2d1-4d00-bd11-e8171aed1b60
25 / 2.5

# ╔═╡ decc8d93-f975-4d7f-b254-3d2430660561
25 / 2  # dividing integers returns a float (notice the `.`)

# ╔═╡ 081453a1-5441-4cf3-af47-b2a127701cd1
md"""
- notice we used `#` to define a comment
"""

# ╔═╡ a6422782-f24c-4c5c-bf15-372695455160
md"""
## Text Data

- Not all data is numerical
- Some is textual
- To represent text in Julia we use a `String`
- To define a String we use quotation marks (`"`) as below
"""

# ╔═╡ d99b391b-109f-4d5e-9cef-fe103a8c9661
"My name is Spencer"

# ╔═╡ 666c836f-f8f5-4ee7-a15d-f2a31c1f10c2
"1"  # an integer in a string

# ╔═╡ a3baa86f-7b24-4bcd-b3d1-7a6a9567b2df
md"""
## Arrays

- When doing numerical work, we often need to deal with multiple pieces of data at the same time
- In Julia the default way of doing this is to use an array
- Arrays are defined with `[` and `]` as below
"""

# ╔═╡ ea4f6a5d-9f0d-4b0d-9941-c0029441304f
[1, 2, 3]  # a 3 element array 

# ╔═╡ 287a52f9-8b6b-412b-bae3-fc693e180f71
[1 2 3]  # a 1x3 matrix

# ╔═╡ 63600022-009c-4798-ba70-78b4010e459e
[1 2; 3 4]  # a 2x2 matrix

# ╔═╡ 9bcdac3e-efac-4a8c-b931-a86b8aa2919e
[1 2
 3 4]  # another way to write a 2x2 matrix

# ╔═╡ beb922e0-344c-48e4-a9cd-37af49cfcaa1
[1 "hello"; 2 "world"]  # a 2x2 matrix with int and string

# ╔═╡ 8bce9b3b-9d50-474c-b763-938222e75304
md"""
# Variables

- Often when programming, we need to refer to the same piece of data more than once
- To do this we use a variable
- Variables are defined using an `=`, as in `name = value`
"""

# ╔═╡ 83afb931-68b1-456a-97f8-d4c40b1725b8
x = 1

# ╔═╡ 8f0a39af-e499-40e6-9501-af701071d4eb
y = 42

# ╔═╡ 2b500dc8-a92e-4221-bb8b-6f2645fab184
x + y  # 'use' or 'refer to' x and y

# ╔═╡ 93b6cfea-5439-4720-aa07-3d4dda3323f7
m1 = [1 0; 0 1]

# ╔═╡ 21e11f76-8516-4a0e-80dd-3d707f328ee4
m2 = [1 2; 3 4]

# ╔═╡ 55552713-b73e-486a-b2fd-2ac8d076a034
m1 * m2  # matrix multiplication

# ╔═╡ 509c3317-ebbc-45a2-b50b-b6c92fc58602
m2 * m2  # again -- but with something besides identity matrix!

# ╔═╡ 88835b49-5663-4d92-ab87-7f15f88584ea
md"""
# Functions

- Most Julia programs do more than basic arithmetic operations on data
- To apply an operation to a piece of data, we call a function
- To call a function we use the `function_name(data1, data2)`
- A very handy function is the `typeof` function
"""

# ╔═╡ 4525264b-08a3-434c-bd9e-8970fde366eb
typeof(1)

# ╔═╡ 3951b69d-c19a-49f1-99cc-ef14e6bc26e9
typeof(2.0)

# ╔═╡ 05e7ffe4-c974-4e30-984a-22a1bb050747
typeof([1,2,3])

# ╔═╡ 38e2089c-ed63-4acf-a04a-b23c5aa4ddff
typeof([1 2; 3 4.0])

# ╔═╡ 43ce8c7b-e555-414a-b792-52f4cedcc7cf
md"""
- Many standard operations are built in to Julia as functions
"""

# ╔═╡ 798ce526-001c-4b65-98ec-085e87901b85
sum([1, 2, 3])  # compute sum of array of numbers

# ╔═╡ 03c0be05-265d-425e-a883-7948c58605ef
inv([1 2; 3 4])  # matrix inverse

# ╔═╡ 1833987b-fd07-40ef-9ff6-7f6ce44c7a0b
size([1 2; 3 4])  # number of (rows, columns)  in matrix

# ╔═╡ cbb0b647-b9b9-4425-9cbb-3e025d03239c
length([1, 2, 3])  # number of elements in array

# ╔═╡ 7f885226-9983-446f-9457-f420f41c2455
length([1 2; 3 4])  # returns total number of elements in a Matrix

# ╔═╡ fe3bca64-2303-4b6b-abe5-f962947d6786
rand(2, 2, 2)  # a 2x2x2 array of random numbers, sampled from uniform[0,1] dist

# ╔═╡ 858e9f68-d977-44f7-a614-36e3f5e7d8db
md"""
- Julia has 1000s of functions
- We'll learn more as we go along...
- Just watch for the pattern with parentisis: `name(args)`
"""

# ╔═╡ 4d9e4ce7-1e98-4c66-84e9-18a485ed6fe3
md"""
## Defining Functions

- Functions are used to execute a predefined set of operations
- Defining our own funcitons allows us to break programs into small, easily written an understood components
- We define functions using the syntax
```julia
function name(arg1, arg2)
    # steps
end
```
"""

# ╔═╡ 6146b89c-ac76-4559-acf3-6974db7cdb08
function mean(x)
	total = sum(x)
	N = length(x)
	total / N
end

# ╔═╡ df72d92b-0296-4fb5-994c-79c88b7f054b
mean([1, 2, 3])

# ╔═╡ b77c43fd-24e6-497b-b3cc-879573ae87fa
mean(rand(1000))  # mean of 1000 random samples from U[0,1] -- should be ~ 0.5

# ╔═╡ fc951362-6869-4a34-bb24-1d1aec9b39d4
md"""
- If a function only contains one line of code, you can also use a shorthand notation:
```julia
function_name(arg1, arg2) = # step
```
"""

# ╔═╡ f183a604-af44-4129-9d7c-1a41668fddfd
add_two(x) = x + 2

# ╔═╡ c62fb5e9-a829-45b5-9493-592926399d15
add_two(40)

# ╔═╡ b8ab9b11-6925-4626-9c15-a17c956e496b
md"""
## Broadcsting

- Our `add_two` function only works for numbers
- It would fail if we tried to evaluate on an array of numbers:
"""

# ╔═╡ 59a645f8-53aa-4c32-b477-53048b5c4e33
add_two([1, 2, 3])

# ╔═╡ cb4feca5-5ff6-4260-be13-b43ce43ca806
md"""
- To apply a function to all elements of some container (like an array) we can use **broadcasting**
- Broadcasting is a very powerful Julia feature that we will learn more about over time
- For now we'll learn the syntax and show an example
- To *broadcast* a function (call it `f`) over an array (call it `a`) we use `f.(a)` -- notice the `.`!
"""

# ╔═╡ 2aba939f-3402-4fa3-9455-db4f9815a9ab
add_two.([1, 2, 3])

# ╔═╡ 0fedf91f-f83f-4bd3-a675-5603f0742707
md"""
# Packages

- Julia comes ready to go with many powerful functions and data types
- However, there is a very active community of Julia programmers who are experts in different subfields of science and engineering
- This has led to the development of vibrant and exciting ecosystem of packages or toolboxes for performing specific tasks
- We can access these routines by using Julia packages
"""

# ╔═╡ cb260f40-64de-47d0-b9fb-dc719b38ae43
md"""
## Packages in Pluto

- To load a package in Julia you use `using PackageName`
- If you are working inside a Pluto.jl notebook, Pluto will check if you already have this package on your computer and load it
- If you do not have this package, Pluto will download and install it for you!
"""

# ╔═╡ b6e32b7d-3ccf-43ba-b2b4-f758152ab072
md"""
## Popular Packages

- There are some truly excellent pacakages in the Julia package ecosystem
- We'll learn about many of them as we go along
- Today, we'll preview a few of them to show how to work with packages
"""

# ╔═╡ 5a5d516f-9120-4a41-b1f9-21a60bd1816b
md"""
## Distributions

- Many aspects of our computational work will require working with probability distributions and random numbers
- The [Distributions](https://juliastats.org/Distributions.jl/latest/) package contains a specification of dozens of probability distributions and a consistent set of functions for each of them
- Let's see how it works
"""

# ╔═╡ bdb4f356-706c-4f12-8c1e-b0377af90193
d1 = Normal(2, 4)  # Normal (Gaussian) distribution with mean 2, standard deviation 4

# ╔═╡ 3886f4a6-49b9-45f4-9bc6-4f773d91ad8c
var(d1)  # variance

# ╔═╡ 9535d6fb-bf27-4dba-bee0-0c63e8edf32c
rand(d1, 2, 2)  # 2x2 matrix of samples from d1

# ╔═╡ 1bd855ad-82d9-40c8-9994-e61a0ccff286
quantile(d1, [0.25, 0.75])  # quantiles - here the interquartile range

# ╔═╡ cd964ffb-3335-4097-97ee-4329a5ca6634
pdf(d1, [1, 2, 3, 4])  # evaluate the pdf

# ╔═╡ bfba4b67-6fcf-4d4a-af0c-569580c8ac8e
cdf(d1, [1, 2, 3, 4])  # evaulate the cdf

# ╔═╡ b6e0f0be-11f7-4d98-beb0-eedb6ac2a102
@doc Pareto  # get help about an object using `@doc X` -- here the Pareto dist

# ╔═╡ 56537423-a8e1-4b86-9374-8ecbb717f493
d2 = Pareto()

# ╔═╡ 51114a51-dfcd-4156-95d8-1c9f97545370
# same functions are defined for this distribution
var(d2)

# ╔═╡ 2a0a5ac8-2749-4860-891f-30148f1a8871


# ╔═╡ 889e8496-4bcf-4c8a-b654-7e8578248282
md"""
## DataFrames

- Frequently we will have data that comes in the form of a table, with rows and labeled columns
- The most common way to store and work with tabular data like this in Julia is using the [DataFrames.jl](https://dataframes.juliadata.org/stable/) package
- The DataFrames.jl package exports a type `DataFrame` that is simliar to the `pandas.DataFrame` from Python or the `data.frame` from R
"""

# ╔═╡ a77106f7-2d5c-48e2-86e4-e0abd4c32daf
df1 = DataFrame(
	countrycode = ["CHN", "CHN", "CHN", "FRA", "FRA", "FRA"],
	pop = [1124.8, 1246.8, 1318.2, 58.2, 60.8, 64.7],
	realgdp = [2.611, 4.951, 11.106, 1.294, 1.753, 2.032],
	year = [1990, 2000, 2010, 1990, 2000, 2010]
)

# ╔═╡ 9fc77cd7-bde5-4e74-b901-6d51cdf04e1d
maximum(df1.pop)

# ╔═╡ 95058250-04f7-4fc0-9a90-82e2c0ade5c3
gdf = groupby(df1, :countrycode)

# ╔═╡ f3eba10c-d174-4ea4-8482-267d04c40997
combine(gdf, :pop => mean, nrow, :realgdp => extrema)

# ╔═╡ 540d11b3-3f03-4934-b7d3-bffb7b88650c
md"""
## PlotlyBase.jl

- Our last stop on the tour of packages for today is a plotting package
  - Everyone loves plots and pictures!
- There are a few very popular plotting packages for Julia
- We'll learn about one called PlotlyBase.jl
  - Others include Plots.jl, Gadfly.jl, and Makie.jl
"""

# ╔═╡ 6cb5d904-93b2-4831-ab92-887de0a51691
Plot(1:3, [1, 4, 9], Layout(width=800, height=450))

# ╔═╡ 19c13105-05cb-42f5-bda5-f13717826e50
Plot(
	df1, 
	x=:pop, y=:realgdp, color=:countrycode, 
	mode="markers", Layout(height=400, xaxis_type="log")
)

# ╔═╡ 728f4fbe-de06-44ff-a18b-d7bdd91657b2
md"""
# Dependencies
"""

# ╔═╡ cb6a44b4-d991-45df-aa44-538d4a314e13
html"""<button onClick="present()">present</button>"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"

[compat]
DataFrames = "~1.2.2"
Distributions = "~0.25.11"
PlotlyBase = "~0.8.13"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "bdc0937269321858ab2a4f288486cb258b9a0af7"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.3.0"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "9995eb3977fbf67b86d0a0a0508e83017ded03f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.14.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "727e463cfebd0c7b999bbf3e9e7e16f254b94193"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.34.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "ee400abb2298bd13bfc3df1c412ed228061a2385"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.7.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns"]
git-tree-sha1 = "3889f646423ce91dd1055a76317e9a1d3a23fff1"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.11"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "a32185f5428d3986f47c2ab78b1f216d5e6cc96f"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.5"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "7c365bdef6380b29cfc5caaf99688cd7489f9b87"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.12.2"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InvertedIndices]]
deps = ["Test"]
git-tree-sha1 = "15732c475062348b0165684ffe28e85ea8396afc"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.0.0"

[[IrrationalConstants]]
git-tree-sha1 = "f76424439413893a832026ca355fe273e93bce94"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "3d682c07e6dd250ed082f883dc88aee7996bf2cc"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.0"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "2ca267b08821e86c5ef4376cffed98a46c2cb205"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "4dd403333bcf0909341cfe57ec115152f937d7d8"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.1"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "2276ac65f1e236e0a6ea70baff3f62ad4c625345"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.2"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "3984b84a295d1bcf0d0f7902f9fb1eeed54f97db"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.13"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "cde4ce9d6f33219465b55162811d8de8139c0414"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.2.1"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "0d1245a357cc61c8cd61934c07447aa569ff22e6"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.1.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "12fbe86da16df6679be7521dfb39fbc861e1dc7b"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "adcd36e8ba9665c88eb0bd156d4e2a19f9b0d889"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.0"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "LogExpFunctions", "OpenSpecFun_jll"]
git-tree-sha1 = "a322a9493e49c5f3a10b50df3aedaf1cdb3244b7"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.6.1"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "fed1ec1e65749c4d96fc20dd13bea72b55457e62"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.9"

[[StatsFuns]]
deps = ["IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "20d1bb720b9b27636280f751746ba4abb465f19d"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.9"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "d0c690d37c73aeb5ca063056283fde5585a41710"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─c411d524-041b-11ec-1863-8b1d11a9e04c
# ╟─617ee5d8-4ad3-4235-bc19-6fdfc7600464
# ╟─2d5d5219-a008-4150-8421-2ec19be6eea6
# ╟─257d08da-7e03-4522-930e-3b3dbe0a20f6
# ╠═413bfb6c-d875-4020-86bf-f0452b588bfa
# ╟─538f2a00-9995-4f5b-b34a-60897ddd4338
# ╠═175565e0-9307-42e8-ba15-b0dd51c51976
# ╠═0da147f5-0cec-4af9-9bbd-aeb9ad537629
# ╟─ba9f4de7-7a60-409f-8986-2a345b7d498b
# ╠═22298b46-6f21-49ee-a935-005fbc865ecc
# ╠═6dd6cd99-5483-4812-b783-218aa0ee2dcd
# ╟─4c19b685-eb43-43c7-81b0-a2e5f81f04e4
# ╠═0cd7bfbd-c2d1-4d00-bd11-e8171aed1b60
# ╠═decc8d93-f975-4d7f-b254-3d2430660561
# ╠═081453a1-5441-4cf3-af47-b2a127701cd1
# ╟─a6422782-f24c-4c5c-bf15-372695455160
# ╠═d99b391b-109f-4d5e-9cef-fe103a8c9661
# ╠═666c836f-f8f5-4ee7-a15d-f2a31c1f10c2
# ╟─a3baa86f-7b24-4bcd-b3d1-7a6a9567b2df
# ╠═ea4f6a5d-9f0d-4b0d-9941-c0029441304f
# ╠═287a52f9-8b6b-412b-bae3-fc693e180f71
# ╠═63600022-009c-4798-ba70-78b4010e459e
# ╠═9bcdac3e-efac-4a8c-b931-a86b8aa2919e
# ╠═beb922e0-344c-48e4-a9cd-37af49cfcaa1
# ╟─8bce9b3b-9d50-474c-b763-938222e75304
# ╠═83afb931-68b1-456a-97f8-d4c40b1725b8
# ╠═8f0a39af-e499-40e6-9501-af701071d4eb
# ╠═2b500dc8-a92e-4221-bb8b-6f2645fab184
# ╠═93b6cfea-5439-4720-aa07-3d4dda3323f7
# ╠═21e11f76-8516-4a0e-80dd-3d707f328ee4
# ╠═55552713-b73e-486a-b2fd-2ac8d076a034
# ╠═509c3317-ebbc-45a2-b50b-b6c92fc58602
# ╟─88835b49-5663-4d92-ab87-7f15f88584ea
# ╠═4525264b-08a3-434c-bd9e-8970fde366eb
# ╠═3951b69d-c19a-49f1-99cc-ef14e6bc26e9
# ╠═05e7ffe4-c974-4e30-984a-22a1bb050747
# ╠═38e2089c-ed63-4acf-a04a-b23c5aa4ddff
# ╠═43ce8c7b-e555-414a-b792-52f4cedcc7cf
# ╠═798ce526-001c-4b65-98ec-085e87901b85
# ╠═03c0be05-265d-425e-a883-7948c58605ef
# ╠═1833987b-fd07-40ef-9ff6-7f6ce44c7a0b
# ╠═cbb0b647-b9b9-4425-9cbb-3e025d03239c
# ╠═7f885226-9983-446f-9457-f420f41c2455
# ╠═fe3bca64-2303-4b6b-abe5-f962947d6786
# ╟─858e9f68-d977-44f7-a614-36e3f5e7d8db
# ╟─4d9e4ce7-1e98-4c66-84e9-18a485ed6fe3
# ╠═6146b89c-ac76-4559-acf3-6974db7cdb08
# ╠═df72d92b-0296-4fb5-994c-79c88b7f054b
# ╠═b77c43fd-24e6-497b-b3cc-879573ae87fa
# ╟─fc951362-6869-4a34-bb24-1d1aec9b39d4
# ╠═f183a604-af44-4129-9d7c-1a41668fddfd
# ╠═c62fb5e9-a829-45b5-9493-592926399d15
# ╟─b8ab9b11-6925-4626-9c15-a17c956e496b
# ╠═59a645f8-53aa-4c32-b477-53048b5c4e33
# ╟─cb4feca5-5ff6-4260-be13-b43ce43ca806
# ╠═2aba939f-3402-4fa3-9455-db4f9815a9ab
# ╟─0fedf91f-f83f-4bd3-a675-5603f0742707
# ╟─cb260f40-64de-47d0-b9fb-dc719b38ae43
# ╟─b6e32b7d-3ccf-43ba-b2b4-f758152ab072
# ╟─5a5d516f-9120-4a41-b1f9-21a60bd1816b
# ╠═c9115768-9392-4f7a-add0-d92629fdfe0b
# ╠═bdb4f356-706c-4f12-8c1e-b0377af90193
# ╠═3886f4a6-49b9-45f4-9bc6-4f773d91ad8c
# ╠═9535d6fb-bf27-4dba-bee0-0c63e8edf32c
# ╠═1bd855ad-82d9-40c8-9994-e61a0ccff286
# ╠═cd964ffb-3335-4097-97ee-4329a5ca6634
# ╠═bfba4b67-6fcf-4d4a-af0c-569580c8ac8e
# ╠═b6e0f0be-11f7-4d98-beb0-eedb6ac2a102
# ╠═56537423-a8e1-4b86-9374-8ecbb717f493
# ╠═51114a51-dfcd-4156-95d8-1c9f97545370
# ╠═2a0a5ac8-2749-4860-891f-30148f1a8871
# ╟─889e8496-4bcf-4c8a-b654-7e8578248282
# ╠═94be61b6-024d-466d-9d48-0d1d52a5ff8a
# ╠═a77106f7-2d5c-48e2-86e4-e0abd4c32daf
# ╠═9fc77cd7-bde5-4e74-b901-6d51cdf04e1d
# ╠═95058250-04f7-4fc0-9a90-82e2c0ade5c3
# ╠═f3eba10c-d174-4ea4-8482-267d04c40997
# ╟─540d11b3-3f03-4934-b7d3-bffb7b88650c
# ╠═09480927-e85a-4e5e-836e-22aa95a18723
# ╠═6cb5d904-93b2-4831-ab92-887de0a51691
# ╠═19c13105-05cb-42f5-bda5-f13717826e50
# ╟─728f4fbe-de06-44ff-a18b-d7bdd91657b2
# ╟─cb6a44b4-d991-45df-aa44-538d4a314e13
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
