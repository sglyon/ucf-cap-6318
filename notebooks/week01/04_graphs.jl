### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ b4216de7-ac9f-4f20-a32c-bac12f03e8a6
using LightGraphs, GraphPlot

# ╔═╡ 4ff5e61f-c221-476b-bb23-ea2943a914bc
using PlutoUI

# ╔═╡ 15e99b4e-042a-11ec-30d5-7fc98c6d5177
md"""
# Graphs

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon

**Prerequisites**

- Julia Setup

**Outcomes**


**References**

- [Easley and Kleinberg](https://www.cs.cornell.edu/home/kleinber/networks-book/) chapters 2-3
"""

# ╔═╡ 281ac180-08dc-4094-9671-03033929cb99
md"""
## Why Study Graphs?
- Economic, cultural, political, and social interactions are influenced by *structure* of relationships
  - Transmission of viruses
  - International trade, supply chains, marketplaces
  - Spread of information, diffusion of innovation
  - Political persuasion, localized voting patterns
  - Human behaviors influenced by network of friends (sports, clothes, music)
- Behaviors can be effected by social networks
  - "Influencers"
  - Circles of followers can create echo chambers
"""

# ╔═╡ cbe8e17d-1fd5-40a8-ad5f-660258840464
md"""
## Edges and Nodes

- A **graph** specifies relationships between a collection of items
- Each item is called a **node**
- A relationship between nodes is represented by an **edge**
- Visually, graphs might look like this:
"""

# ╔═╡ 62fa64a2-45de-4db0-8f78-bccfeb83ff50
PlutoUI.LocalResource("./graph_structure.png")

# ╔═╡ 2e9ccb30-a0db-4f9d-951d-1be717075b5f
md"""
- Here the nodes are `A`, `B`, `C`, `D`
- The edges connect nodes `A-B`, `B-C`, `B-D`, `C-D`
"""

# ╔═╡ 3fba22ed-dad8-4cdb-9c8b-91d62300922a
md"""
## Adjacency Matrix

- How might we represent the graph above numerically?
- One very common approach is to use a matrix of 0's and 1's called an *adjancency matrix*
- Suppose we have a graph of $N$ nodes
  - Without loss of generality, we'll represent them as integers `1:N`
- Let $A \in \{0,1\}^{N \times N}$ be our adjacency matrix
- Element $A_{ij}$ will be zero unless there is an edge between nodes $i$ and $j$ (diagonal is left as $0$)
- In our above we had 
  - Nodes `A`, `B`, `C`, `D` (or 1, 2, 3, 4 respectively)
  - Edges connecting nodes `1-2`, `2-3`, `2-4`, `3-4`
- The adjacency matrix for this example is 
$$A = \begin{bmatrix} 
0 & 1 & 0 & 0 \\
1 & 0 & 1 & 1 \\
0 & 1 & 0 & 1 \\
0 & 1 & 1 & 0
\end{bmatrix}$$
"""

# ╔═╡ 563ab06f-fbac-4c15-95e8-9351f7c32ec4
md"""
# Graphs in Julia

- In Julia there are a few ways we could represent our example graph above
- We could start with the adjacency matrix concept as follows
"""

# ╔═╡ c8cc039d-35b1-4dd6-bf33-8c0dea8b6136
A = [
	0 1 0 0
	1 0 1 1
	0 1 0 1
	0 1 1 0
]

# ╔═╡ ebbe6ea7-5555-4122-997b-2c6c78eb1633
md"""
## Working with Adjacency Matrices

- An adjacency matrix gives us a lot of information about the structure of the graph
- We could compute all of the following
  - Total number of nodes: number of rows or columns of $A$
  - Total number of edges: $\sum_{ij} A_{ij}$
  - Node with most edges: $\text{argmax}_{i} \sum_{j} A_{i,j}$
  - Average number of edges per node: $N \cdot \sum_{i,j} A_{i,j}$
"""

# ╔═╡ 4a461113-9542-46f0-9409-3a6f98078e29
md"""
### Exercise: Adjacency Matrix

- In the cell below we have defined an adjacency matrix called `A_ex1`
- Using `A_ex1` answer the following questions:
  - How many nodes are in the graph?
  - How many edges?
  - Node with most edges (hint, use the `dims` argument to `sum` and then the `argmax` function)
  - Average number of edges per node
"""

# ╔═╡ 7e6382d0-3e6b-4d30-8ed8-78ea3dd8a654
begin  # to use multiple lines in a cell you need to use `begin` CODE `end`
	A_ex1 = rand(0:1, 30, 30)
	
	# remove diagonal elements
	for i in 1:30
		A_ex1[i, i] = 0
	end
end


# ╔═╡ 148e7b00-d3c9-4da8-bcc6-15f39c248479
# your work here!

# ╔═╡ 907f475c-4726-4fd1-8e85-339decb296c5
md"""
## LightGraphs.jl

- There are many smart graph theory experts in the Juila community
- They have built a package called LightGraphs for working with Graphs (as well as ancillary pacakges for extra features)
- We can build a `LightGraphs.Graph` object directly from our adjacency matrix
"""

# ╔═╡ 4cb2d7cb-9b68-40f4-866a-5e13b0b9540d
G1 = Graph(A)

# ╔═╡ d992b543-a500-4bb8-ad98-bc547e85c002
collect(edges(G1))  # collect turns an `iterator` into an array

# ╔═╡ dd13830c-3fe5-446c-8820-b899079a4eb6
collect(vertices(G1))  # LightGraphs refers to nodes as `vertices`

# ╔═╡ 19e7f48f-2a24-4377-b0e0-6245ae434eda
gplot(G1)

# ╔═╡ 6abb1533-dbb3-45e1-bbed-091e0be79e85


# ╔═╡ 4486b5df-c810-4c11-bacc-480853b4ff98


# ╔═╡ 07b738a3-5404-46e0-80fb-bda35ee391da
md"""
## Size considerations
"""


# ╔═╡ 3b4ac8b1-2d44-4dd5-8bf4-140b1e0d17d7
md"""
- Using `Array{Int64,2}` to store an adjacency matrix turns out to be a rather costly way to store a graph
- In the original example graph we had 4 nodes and 4 edges
- To store this we needed to have a 4x4 matrix of 64 bit integers
  - This is only $(Int(16 * 64 / 8)) bytes in our exapmle, 
  - But consider a graph of websites and links between them -- that graph would have millions of nodes and edges...
- There are a few approaches to reducing this storage cost:
  - Only store the upper triangle of the matrix
  - Use Boolean ( $(sizeof(Bool)) bit!) instead of Int to store 
  - Use a [SparseMatrix](https://docs.julialang.org/en/v1/stdlib/SparseArrays/)
  - Store as a `Vector{Vector{Int}}`
"""

# ╔═╡ 726c860a-275e-44a9-b248-5f53f5dbe493
A2 = [[2], [1, 3, 4], [2, 4], [2, 3]]

# ╔═╡ c315dc6d-1198-4063-bc99-eb0f6a654140
md"""
- This would be a much more space efficient way to store a graph
"""

# ╔═╡ 7aa47418-dcc0-4eb3-9992-584a630a3573
md"""
# Dependencies
"""

# ╔═╡ c7d82edc-d486-4c53-8158-378f61ef8026
html"""<button onClick="present()">present</button>"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
GraphPlot = "a2cc645c-3eea-5389-862e-a155d0052231"
LightGraphs = "093fc24a-ae57-5d10-9952-331d41423f4d"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
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

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

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

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

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
git-tree-sha1 = "adcd36e8ba9665c88eb0bd156d4e2a19f9b0d889"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.0"

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
# ╟─15e99b4e-042a-11ec-30d5-7fc98c6d5177
# ╟─281ac180-08dc-4094-9671-03033929cb99
# ╟─cbe8e17d-1fd5-40a8-ad5f-660258840464
# ╟─62fa64a2-45de-4db0-8f78-bccfeb83ff50
# ╟─2e9ccb30-a0db-4f9d-951d-1be717075b5f
# ╟─3fba22ed-dad8-4cdb-9c8b-91d62300922a
# ╟─563ab06f-fbac-4c15-95e8-9351f7c32ec4
# ╠═c8cc039d-35b1-4dd6-bf33-8c0dea8b6136
# ╟─ebbe6ea7-5555-4122-997b-2c6c78eb1633
# ╟─4a461113-9542-46f0-9409-3a6f98078e29
# ╠═7e6382d0-3e6b-4d30-8ed8-78ea3dd8a654
# ╠═148e7b00-d3c9-4da8-bcc6-15f39c248479
# ╠═907f475c-4726-4fd1-8e85-339decb296c5
# ╠═b4216de7-ac9f-4f20-a32c-bac12f03e8a6
# ╠═4cb2d7cb-9b68-40f4-866a-5e13b0b9540d
# ╠═d992b543-a500-4bb8-ad98-bc547e85c002
# ╠═dd13830c-3fe5-446c-8820-b899079a4eb6
# ╠═19e7f48f-2a24-4377-b0e0-6245ae434eda
# ╠═6abb1533-dbb3-45e1-bbed-091e0be79e85
# ╠═4486b5df-c810-4c11-bacc-480853b4ff98
# ╠═07b738a3-5404-46e0-80fb-bda35ee391da
# ╠═3b4ac8b1-2d44-4dd5-8bf4-140b1e0d17d7
# ╠═726c860a-275e-44a9-b248-5f53f5dbe493
# ╠═c315dc6d-1198-4063-bc99-eb0f6a654140
# ╟─7aa47418-dcc0-4eb3-9992-584a630a3573
# ╟─c7d82edc-d486-4c53-8158-378f61ef8026
# ╠═4ff5e61f-c221-476b-bb23-ea2943a914bc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
