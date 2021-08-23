### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

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

# ╔═╡ 7aa47418-dcc0-4eb3-9992-584a630a3573
md"""
# Dependencies
"""

# ╔═╡ c7d82edc-d486-4c53-8158-378f61ef8026
html"""<button onClick="present()">present</button>"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "adcd36e8ba9665c88eb0bd156d4e2a19f9b0d889"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╟─15e99b4e-042a-11ec-30d5-7fc98c6d5177
# ╟─281ac180-08dc-4094-9671-03033929cb99
# ╟─cbe8e17d-1fd5-40a8-ad5f-660258840464
# ╟─62fa64a2-45de-4db0-8f78-bccfeb83ff50
# ╟─2e9ccb30-a0db-4f9d-951d-1be717075b5f
# ╟─7aa47418-dcc0-4eb3-9992-584a630a3573
# ╟─c7d82edc-d486-4c53-8158-378f61ef8026
# ╠═4ff5e61f-c221-476b-bb23-ea2943a914bc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
