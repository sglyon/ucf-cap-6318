### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ be9ecc7f-2326-4690-be7c-fe7a61f4c8a2
using DataFrames, LightGraphs, GraphPlot

# ╔═╡ add29c68-f613-4350-a10e-9a71d7d1740a
using DataStructures

# ╔═╡ c74dbf4b-9d53-45fe-903c-a1c930655ba8
using PlutoUI

# ╔═╡ a54d66b2-1005-11ec-0754-874cd005d801
md"""
# Homophily

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon

**Prerequisites**

- Introduction to Graphs
- Strong and Weak Ties

**Outcomes**

- Understand the concept of homophily
- Practice working through "by hand" examples of diagnosing homophily
- Be prepared to computationally diagnose homophily in a large network

**References**

- [Easley and Kleinberg](https://www.cs.cornell.edu/home/kleinber/networks-book/) chapter 4 (especially section 4.1)
"""

# ╔═╡ 2de9acf4-40bc-4d52-8777-821fde5de467
md"""
## Main Idea

- Consider your friends. Do they tend to 
  - Enjoy the same movies, music, hobbies as you?
  - Hold similar religous or political beliefs?
  - Come from simliar schools, workplaces, or socio-economic settings?
- What about a random sample of people in the world?
- If you are like me, your answers likely indicate that you have more in common with your friends than you would expect to have with a random sample of people
- This concept -- that we are similar to our friends -- is called **homophily**
"""

# ╔═╡ 3b775eac-2da3-4a0c-8339-94569f74cf67
md"""
## Homophily in Graphs

- In the context of graphs or networks, homophily means that nodes that are connected are *more similar* than nodes at a further distance in the graph
- But what do we mean by *more similar*?
  - Idea: We might have common friends. 
    - This is an **intrinsic** force that led to node formation (e.g. triadic closure)
  - Alternative: We may share characteristics or properties that are not represented in the graph -- **external** forces. 
    - Examples: same race, gender, school, employer, sports team, etc.
- These external forces are what homophily captures
"""

# ╔═╡ e2b85fca-c204-47c3-8bd9-a94a783c3c62
md"""
## Context

- To identify if homophily is active in a network, we must have access to **context** on top of list of nodes and edges
- One way to represent this context would be with a DataFrame in addition to a graph:
  - One row per node
  - One column indicating the node identifier (or just use row number)
  - One column for additional characteristic

"""

# ╔═╡ 0f08e105-8a6a-458a-95d6-d20140f7a9dc
df1 = DataFrame(
	node_id=["Spencer", "Shannen", "Brinley", "MJ", "LeBron"],
	favorite_color=["blue", "pink", "pink", "red", "blue"],
	school=["ucf", "byu", "wes", "unc", "hs"],
	sport=["volleyball", "wakeboarding", "wakeboarding", "basketball", "basketball"],
	favorite_food=["pizza", "burger", "pizza", "burger", "ice cream"],
	gender=['M', 'F', 'F', 'M', 'M'],
)


# ╔═╡ 4a017258-6300-452c-aa7b-af7a6a3bb83e
begin
	edges = [
		0 1 1 0 1 
		1 0 1 1 0 
		1 1 0 0 0
		0 1 0 0 1
		1 0 0 1 0
	]
	g1 = Graph(edges)
end

# ╔═╡ 47da7b86-7dd0-4ea9-bd63-b66f6ff58874
gplot(g1, nodelabel=df1.node_id)

# ╔═╡ f9483a99-97c7-4759-be98-5b44ff73d92c
md"""
# Measuring Homophily

- Our discussion on homophily so far has been conceptual... let's make it precise
- We'll frame the discussion in terms of a null hypothesis
- Concept should be familiar from statistics, but not exactly the same we we won't make distributional assumptions

"""

# ╔═╡ bc2ed08f-2635-40ab-a113-bd98e3d3ebd6
md"""
## Random Homophily

- Our analytical approach begins with a thought experiment (counter factual) that all edges are randomly formed
- In this case, we should not expect the context around our graph to help us predict its structure
- Suppose we consider a characteristic $X$
- We have $N$ nodes and $N_x$ of them exhibit feature $X$ and $N - N_x$ of them to not
  - We'll work with probabilities: $p_x = \frac{N_x}{N}$
- The probability that an arbitrary edge is between two nodes that both share $X$ is equal to $p_x^2$
  - Probability of edge between two non $X$ nodes: $(1-p_x)^2$
  - Probabillity of edge bewtween one $X$ and one non $X$: 
$$\begin{aligned}\text{prob}(\text{edge (X <=> not X)}) &= p_x (1-p_x) + (1-p_x) p_x \\ &= 2 p_x (1-p_x)\end{aligned}$$
- This will be our "random edge formation" benchmark
"""

# ╔═╡ 64929403-ea4d-45d0-be0a-e3f17bdd6cbd
md"""
## Counting Frequencies

- Now an empirical value...
- Let there be $E$ edges
- Let...

| variable | meaning |
|----------|---------|
| $E_{xx}$ | # edges between 2 $X$ |
| $E_{xy}$ | # edges between 2 not $X$ |
| $E_{xy}$ | # edges between 1 $X$  and 1 not $X$|
- Then $E = E_{xx} + E_{yy} + E_{xy}$
- We'll use these 4 numbers to count frequencies of edges between $X$ types and non-$X$ types
"""


# ╔═╡ 37d008bc-c1e9-49b8-8d2e-988c79bedd4f
md"""
## H0: no homophily

- We are now ready for our null hypothesis:
- **H0**: the network does not exhibit homophily in characteristic $X$
- Our test: 
 
$$2 p_x(1-p_x) >> \frac{E_{xy}}{E}?$$

- If the inequality above is satisfied, we reject the null hypothesis and conclude that the graph exhibits homophily
- Intuition: actual cross-characteristic edge formation is significantly different than what would be expected if edge formation was random
"""

# ╔═╡ 72e5bf38-0f45-426b-96cc-4f1bb9dd6e63
md"""
## Example: high school relationships

- Recall the graph of romantic relationships between high school students
- **Question**: does this graph exhibit homophily in gender? Why?
"""

# ╔═╡ 810a3c96-6643-40e9-a893-939eda4ef656
PlutoUI.LocalResource("./hs_dating_graph.png")

# ╔═╡ 003da800-28ed-489c-8489-d97e9975d322
md"""
# Example: Lyon and All Stars

- Let's work through an example of numerically dianosing homophily using our made up data
- I'll repeat it below
"""

# ╔═╡ 9eed1884-54dd-4650-9a14-d8f94743089e
df1

# ╔═╡ 08142db5-e014-4751-9810-06f04bea88fa
gplot(g1, nodelabel=df1.node_id)

# ╔═╡ ce6cf9f9-52f6-416d-838c-ee085272b75d
md"""
## Step 1: Counting frequencies

- First we need to count frequencies for all our characteristics
- We'll do that here
"""

# ╔═╡ f3fcd8d8-5fc1-4349-9cc5-7e4ed2af755c
function count_frequencies(vals)
	counts = DataStructures.counter(vals)
	total = length(vals)
	Dict(c => v / total for (c, v) in pairs(counts))
end

# ╔═╡ 85f52a97-4442-428b-b1fc-585037738a06
count_frequencies(df1.gender)

# ╔═╡ 3ee30442-ff4f-4484-a995-582bb7a0ec06
Dict(
	n => count_frequencies(df1[!, n])
	for n in names(df1)[2:end]
)

# ╔═╡ 3d38d6b8-4dfe-4cca-8073-650480f07292
md"""
## Step 2: Counting Edges

- Next we need to count the number of edges of each type
- This step is a bit tricker as it will require that we access both data from the Graph and the DataFrame
- To not spoil the fun, we'll leave this code as an exercise on the homework
- For now we'll look at things "by hand"
"""

# ╔═╡ c5a3a0d6-dc53-4ef7-a8f6-41a6817560f5
df1

# ╔═╡ f12110d1-bff4-4a1e-9651-4818894df2c8
md"""
- Let's consider favorite_color and test if edges form based on favorite color being blue
- There are $(ne(g1)) total edges (E)
- Of these, 5 are cross edges $(E_{xy})$
- The ratio of cross edges is 5/6
- The ratio of nodes that like blue is 2/5 ($p_x$)
"""

# ╔═╡ dc371ac7-3a06-4497-975f-a2c536fb4562
let
	E = ne(g1)
	Exy = 5
	n_blue = 2
	N = nv(g1)
	px = n_blue / N
	
	# test
	2 * px * (1-px), Exy/E
end

# ╔═╡ feaa52bd-e98d-4b8d-88d8-88908bc05e4e
md"""
- Here we have that **more** cross edges formed than we would expect 
- An instance of *inverse homophily* (opposites attract)
"""

# ╔═╡ b4baef6f-5cde-491b-bd8c-4b781fcbab2f
md"""
## Exercise

- Repeat the counting exercise, but for the gender and favorite sport characteristics
- What do you find? Do either of these characteristcs exhibit homophily?
"""

# ╔═╡ 3124315f-a8eb-4f13-9493-cef5f998654a
md"""
## Dependencies
"""

# ╔═╡ 8e7b6b9d-ab3b-4fba-98d4-1c83d27e14a7
begin
	hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))
	
	almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))
	
	still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))
	
	keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))
	
	yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]
	
	correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))
	
	not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))
	
	check_number(have::Int, want::Int) = have == want
	check_number(have::T, want::T) where T <: AbstractFloat = abs(want - have) < 1e-10
	
	function default_checks(vname, have, want)
		if ismissing(have)
			still_missing(Markdown.MD(Markdown.Paragraph([
				"Make sure to compute a value for ",
				Markdown.Code(vname)
			])))
		elseif typeof(have) != typeof(want)
			keep_working(Markdown.MD(Markdown.Paragraph([
				Markdown.Code(vname), 
				"should be a $(typeof(want)), found $(typeof(have))"
			])))
		else
			if !check_number(have, want)
				keep_working(Markdown.MD(Markdown.Paragraph([
				Markdown.Code(vname), 
				"is not quite right"
			])))
			else
				correct()
			end
		end
	end
	nothing
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataStructures = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
GraphPlot = "a2cc645c-3eea-5389-862e-a155d0052231"
LightGraphs = "093fc24a-ae57-5d10-9952-331d41423f4d"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
DataFrames = "~1.2.2"
DataStructures = "~0.18.10"
GraphPlot = "~0.4.4"
LightGraphs = "~1.3.5"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "f87e559f87a45bece9c9ed97458d3afe98b1ebb9"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.1.0"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "32a2b8af383f11cbb65803883837a149d10dfe8a"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.10.12"

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

[[Compose]]
deps = ["Base64", "Colors", "DataStructures", "Dates", "IterTools", "JSON", "LinearAlgebra", "Measures", "Printf", "Random", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "c6461fc7c35a4bb8d00905df7adafcff1fe3a6bc"
uuid = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
version = "0.9.2"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "bec2532f8adb82005476c141ec23e921fc20971b"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.8.0"

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

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

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

[[GraphPlot]]
deps = ["ArnoldiMethod", "ColorTypes", "Colors", "Compose", "DelimitedFiles", "LightGraphs", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "dd8f15128a91b0079dfe3f4a4a1e190e54ac7164"
uuid = "a2cc645c-3eea-5389-862e-a155d0052231"
version = "0.4.4"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

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

[[LightGraphs]]
deps = ["ArnoldiMethod", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "432428df5f360964040ed60418dd5601ecd240b6"
uuid = "093fc24a-ae57-5d10-9952-331d41423f4d"
version = "1.3.5"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "0fb723cd8c45858c22169b2e42269e53271a6df7"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.7"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

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

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a193d6ad9c45ada72c14b731a318bedd3c2f00cf"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.3.0"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "0d1245a357cc61c8cd61934c07447aa569ff22e6"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.1.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

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

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

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

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─a54d66b2-1005-11ec-0754-874cd005d801
# ╟─2de9acf4-40bc-4d52-8777-821fde5de467
# ╟─3b775eac-2da3-4a0c-8339-94569f74cf67
# ╟─e2b85fca-c204-47c3-8bd9-a94a783c3c62
# ╠═be9ecc7f-2326-4690-be7c-fe7a61f4c8a2
# ╠═0f08e105-8a6a-458a-95d6-d20140f7a9dc
# ╠═4a017258-6300-452c-aa7b-af7a6a3bb83e
# ╠═47da7b86-7dd0-4ea9-bd63-b66f6ff58874
# ╟─f9483a99-97c7-4759-be98-5b44ff73d92c
# ╟─bc2ed08f-2635-40ab-a113-bd98e3d3ebd6
# ╟─64929403-ea4d-45d0-be0a-e3f17bdd6cbd
# ╟─37d008bc-c1e9-49b8-8d2e-988c79bedd4f
# ╟─72e5bf38-0f45-426b-96cc-4f1bb9dd6e63
# ╟─810a3c96-6643-40e9-a893-939eda4ef656
# ╟─003da800-28ed-489c-8489-d97e9975d322
# ╠═9eed1884-54dd-4650-9a14-d8f94743089e
# ╠═08142db5-e014-4751-9810-06f04bea88fa
# ╟─ce6cf9f9-52f6-416d-838c-ee085272b75d
# ╠═add29c68-f613-4350-a10e-9a71d7d1740a
# ╠═f3fcd8d8-5fc1-4349-9cc5-7e4ed2af755c
# ╠═85f52a97-4442-428b-b1fc-585037738a06
# ╠═3ee30442-ff4f-4484-a995-582bb7a0ec06
# ╟─3d38d6b8-4dfe-4cca-8073-650480f07292
# ╠═c5a3a0d6-dc53-4ef7-a8f6-41a6817560f5
# ╟─f12110d1-bff4-4a1e-9651-4818894df2c8
# ╠═dc371ac7-3a06-4497-975f-a2c536fb4562
# ╟─feaa52bd-e98d-4b8d-88d8-88908bc05e4e
# ╟─b4baef6f-5cde-491b-bd8c-4b781fcbab2f
# ╟─3124315f-a8eb-4f13-9493-cef5f998654a
# ╠═c74dbf4b-9d53-45fe-903c-a1c930655ba8
# ╟─8e7b6b9d-ab3b-4fba-98d4-1c83d27e14a7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
