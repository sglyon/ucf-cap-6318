### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 6d3f7e71-403c-47d2-8e40-7abeb57af0dc
using LightGraphs, SimpleWeightedGraphs, GraphPlot

# ╔═╡ 3b5fa035-f74b-4916-a77a-da2bc0c3b177
using PlutoUI

# ╔═╡ 57ba21eb-3a03-4a6c-9acf-675eb650407a
html"""<button onClick="present()">present</button>"""

# ╔═╡ 84ec7de8-1ae8-11ec-1eec-77c7bb749869
md"""
# Network Traffic with Game Theory

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon

**Prerequisites**

- Networks
- Game Theory

**Outcomes**

- Represent network traffic weighted DiGraph
- Analyze equilibrium network outcomes using the concept of Nash Equilibirum
- Understand Braes' paradox
- Learn about the concept of social welfare and a social planners


**References**

- [Easley and Kleinberg](https://www.cs.cornell.edu/home/kleinber/networks-book/) chapter 8
"""

# ╔═╡ 4691f26f-becd-44f5-9ecd-7c3a4f5d3161
md"""
# Congestion

- We regularly use physical networks of all kinds
  - Power grids
  - The internet
  - Streets
  - Railroads
- What happens when the networks get congested?
  - Typically -- flow across the network slows down
- Today we'll study how game theoretic ideas are helpful when analyzing how a network with finite capacity or increasing costs
"""

# ╔═╡ 4b208e14-5453-4c80-8b25-6b0798838358
md"""
# A Traffic Network

- We'll start by considering a traffic network
- The figure caption has extra detail -- so be sure to read it!
"""

# ╔═╡ 2b71398e-c8e1-428e-b9fa-5ebd565d3c20
Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week05/traffic_graph.png")

# ╔═╡ 46d27f4e-8bb9-49ec-af54-a87716f93b12
md"""
- We'll write up some helper Julia functions that will let us create and visualize the traffic network for arbitrary values of x
"""

# ╔═╡ 83a321bb-dff8-4d81-8355-59c2d5ff41ee
function traffic_graph1(x)
	A = [
		0 0 x/100 45;
		0 0 0 0;
		0 45 0 0;
		0 x/100 0 0
		]
	SimpleWeightedDiGraph(A)
end

# ╔═╡ b3160b5b-40e2-43fb-b7e4-28d4ea8f8744
function plot_traffic_graph(g::SimpleWeightedDiGraph)
	locs_x = [1.0, 3, 2, 2]
	locs_y = [1.0, 1, 0, 2]
	labels = collect('A':'Z')[1:nv(g)]
	gplot(g, locs_x, locs_y, nodelabel=labels, edgelabel=weight.(edges(g)))
end

# ╔═╡ 73cbb08e-d073-46af-86b7-add7950d645e
@bind x Slider(10:10:4000, default=500, show_value=true)

# ╔═╡ 68a542cf-de15-428e-81f5-484a018b08c0
plot_traffic_graph(traffic_graph1(x))

# ╔═╡ ee053bd3-f1ab-4bb1-9523-6004b9a43f63
md"""
- Play around with the slider and watch the weights on our graph change
"""

# ╔═╡ 50bf91c0-d2c3-468f-82b4-4aa03c5093c3
md"""
## The Game

- Now suppose, as indicated in the figure caption, that we have 4,000 drivers that need to commute from A to B in the morning
- If all take the upper route (A-C-B) we get a total time of 40 + 45 = 85 minutes
- If all take the lower route (A-D-B) we get a total time of 40 + 45 = 85 minutes
- If, however, they evenly divide we get a total time of 20 + 45 = 65 minutes

"""

# ╔═╡ da8bafc9-3a41-4d51-a07b-76097e6a7be6
md"""
## Equilibrium

- Recall that for a set of strategies (here driving paths) to be a Nash Equilibrium, each player's strategy must be a best response to the strategy of all other players
- We'll argue that the only NE of this commuting game is that 2,000 drivers take (A-C-B) and 2,000 take (A-D-B) and everyone takes 65 mintues to commute

"""

# ╔═╡ b764f6ac-978d-4f89-8a1e-27acda3a6ba2
md"""
## Exercise

- Show that this strategy (2,000 drivers take (A-C-B) and 2,000 take (A-D-B)) is indeed a Nash equilibrium
- To do this recognize that the game is symmetric for all drivers
- Then, argue that if 3,999 drivers are following that strategy, the best response for the last driver is also to follow the strategy 
"""

# ╔═╡ 35fa6b4c-6822-4814-a611-373088b71671
md"""
- Your work HERE!
"""

# ╔═╡ 4e7df9d5-d3f1-4768-b73b-11cacb7407dd
md"""
## Discussion

- Note a powerful outcome here -- without any coordination by a central authority, drivers  will automatically balance perfectly in equilibrium
- The only assumptions we made were:
  1. Drivers want to minimize driving time
  2. Drivers are allowed to respond to the decisions of others
- The first assumption is very plausable -- nobody wants to sit in more traffic than necessary
- The second highlights a key facet of our modern society...
  - Information availability (here decisions of other drivers) can (and does!) lead to optimal outcomes without the need for further regulation or policing
"""

# ╔═╡ 439de83d-57f1-4d3f-9f79-87bd511af13e
md"""
# Adding a "warp tunnel"

- Now suppose that we modify the network and add a new edge between C-D that has **zero cost**
- Effectively we add a wormhole that connects C to D
"""

# ╔═╡ ef650b54-310e-416b-b5e8-26c82f4c2492
function traffic_graph2(x)
	G = traffic_graph1(x)
	# need to add an edge with minimal weight so it shows up in plot
	add_edge!(G, 3, 4, 1e-16)
	G
end

# ╔═╡ 03d345e9-0843-4c1f-8421-a7b1b5973714
@bind x2 Slider(10:10:4000, default=500, show_value=true)

# ╔═╡ aeeee747-2ab6-4639-8769-e4df4d25aec6
plot_traffic_graph(traffic_graph2(x2))

# ╔═╡ 37bc2f74-8d0d-4af3-b551-d8851b2c069c
md"""
## Exercise

- Is a 50/50 split of traffic still a Nash equilibrium in this case?
- Why or why not?
- Is all 4,000 drivers doing (A-C-D-B) a Nash equilibrium?
- Why or why not?
"""

# ╔═╡ 9196d48e-a685-4407-b42f-dc9b4e91e84b
md"""
## Braes' Paradox

- In the previous exercise, we saw a rather startling result...
- Doing a network "upgrade" -- adding a wormhole connecting C and D -- resulted in a *worse* equilibrium outcome for everyone!
- The equilbirum driving time is now 80 mintues for all drivers instead of 65 minutes (which was the case before the wormhole)
- This is known as Braes' paradox
"""

# ╔═╡ 5e4d40cb-c46f-4f70-9576-b3daf1aabcd9
md"""
## Follow ups

- Braes' paradox was the starting point for a large body of research on using game theory to analyze network traffic
- Some questions that have been asked are:
  - How much larger can equilibirum travel time increase after a network upgrade?
  - How can network upgrade be designed to be resilient to Braes' paradox?
"""

# ╔═╡ 969c2a49-8e5c-43ec-8232-75dad1d5bedd
md"""
# Social Welfare

- Many economic models are composed of individual actors who make autonomous decisions and have autonomous payoffs
- We've been studying some of these settings using tools from game theory, focusing on the *individual* perspective
  - Our notion of equilibrium is dependent on no individual wanting to change strategy in response to other strategies
- Another form of analysis works at the macro level -- we analyze the **total** payoff for all agents (i.e. sum of payoffs)
- We call this aggregate payoff **social welfare**
"""

# ╔═╡ 073466c7-b4f9-4305-8714-784d59fb5e73
md"""
## The Social Planner

- In an economic model, someone who seeks to maximize social welfare is called a *social planner*
- A social planner is given the authority to make decisions for all agents
- In our traffic model, a social planner would choose to ignore the wormhole and have 1/2 the drivers take A-C-B and the other half take A-D-B
  - In this case everyone would be better off with a cost of 65 minutes instead of the equilibrium 80 minutes
"""

# ╔═╡ f63750f5-6f2b-40f2-8964-a67a2f5c7b9e
md"""
## Cost of Freedom

- Question: in a generic traffic model, how much *worse* can the equilibrium outcome be than the social optimium?
- In our example, 
  - Optimal social welfare is 4000 * 65 = $(4000*65)
  - Equilibrium social welfare is 4000 * 80 = $(4000*80)
  - A change of $(4000*15)
- To answer this question for a general traffic model, we need to be able to compute the equilibrium for a generic traffic model
- We may study this next week, or perhaps even on your homework 😉
"""

# ╔═╡ 4c315dae-3a3d-428a-8f5a-cc7fca8a3bb8
md"""
## Dependencies
"""

# ╔═╡ b9c88aa6-2a97-4a9f-bb13-b7340253a6be
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
	check_number(have::Array, want::Array) = length(have) == length(want) ? all(check_number.(have, want)) : false
	check_number(have::Tuple, want::Tuple) = all(check_number.(have, want))
	
	function default_checks(vname, have, want)
		if ismissing(have) || isnothing(have)
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
GraphPlot = "a2cc645c-3eea-5389-862e-a155d0052231"
LightGraphs = "093fc24a-ae57-5d10-9952-331d41423f4d"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SimpleWeightedGraphs = "47aef6b3-ad0c-573a-a1e2-d07658019622"

[compat]
GraphPlot = "~0.4.4"
LightGraphs = "~1.3.5"
PlutoUI = "~0.7.10"
SimpleWeightedGraphs = "~1.1.1"
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
git-tree-sha1 = "4866e381721b30fac8dda4c8cb1d9db45c8d2994"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.37.0"

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

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

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
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

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
deps = ["Base64", "Dates", "HypertextLiteral", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "26b4d16873562469a0a1e6ae41d90dec9e51286d"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.10"

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

[[SimpleWeightedGraphs]]
deps = ["LightGraphs", "LinearAlgebra", "Markdown", "SparseArrays", "Test"]
git-tree-sha1 = "f3f7396c2d5e9d4752357894889a87340262f904"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.1.1"

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
# ╠═57ba21eb-3a03-4a6c-9acf-675eb650407a
# ╟─84ec7de8-1ae8-11ec-1eec-77c7bb749869
# ╟─4691f26f-becd-44f5-9ecd-7c3a4f5d3161
# ╟─4b208e14-5453-4c80-8b25-6b0798838358
# ╟─2b71398e-c8e1-428e-b9fa-5ebd565d3c20
# ╟─46d27f4e-8bb9-49ec-af54-a87716f93b12
# ╠═6d3f7e71-403c-47d2-8e40-7abeb57af0dc
# ╠═83a321bb-dff8-4d81-8355-59c2d5ff41ee
# ╠═b3160b5b-40e2-43fb-b7e4-28d4ea8f8744
# ╠═73cbb08e-d073-46af-86b7-add7950d645e
# ╠═68a542cf-de15-428e-81f5-484a018b08c0
# ╟─ee053bd3-f1ab-4bb1-9523-6004b9a43f63
# ╟─50bf91c0-d2c3-468f-82b4-4aa03c5093c3
# ╟─da8bafc9-3a41-4d51-a07b-76097e6a7be6
# ╟─b764f6ac-978d-4f89-8a1e-27acda3a6ba2
# ╠═35fa6b4c-6822-4814-a611-373088b71671
# ╟─4e7df9d5-d3f1-4768-b73b-11cacb7407dd
# ╟─439de83d-57f1-4d3f-9f79-87bd511af13e
# ╠═ef650b54-310e-416b-b5e8-26c82f4c2492
# ╠═03d345e9-0843-4c1f-8421-a7b1b5973714
# ╠═aeeee747-2ab6-4639-8769-e4df4d25aec6
# ╟─37bc2f74-8d0d-4af3-b551-d8851b2c069c
# ╟─9196d48e-a685-4407-b42f-dc9b4e91e84b
# ╟─5e4d40cb-c46f-4f70-9576-b3daf1aabcd9
# ╟─969c2a49-8e5c-43ec-8232-75dad1d5bedd
# ╟─073466c7-b4f9-4305-8714-784d59fb5e73
# ╟─f63750f5-6f2b-40f2-8964-a67a2f5c7b9e
# ╟─4c315dae-3a3d-428a-8f5a-cc7fca8a3bb8
# ╠═3b5fa035-f74b-4916-a77a-da2bc0c3b177
# ╟─b9c88aa6-2a97-4a9f-bb13-b7340253a6be
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
