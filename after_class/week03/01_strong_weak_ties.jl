### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 521c893c-116d-4912-a163-716b28e3773e
using LightGraphs,  LightGraphs.LinAlg, GraphPlot

# ╔═╡ 2888aac7-2228-44a6-a8b4-2a7d468fac67
begin
	using Downloads
	# if !isfile("local_bridge.lg")
		Downloads.download("https://raw.githubusercontent.com/sglyon/ucf-cap-6318/Fall21/notebooks/week03/local_bridge.lg", "local_bridge.lg")
	# end
	g5 = loadgraph("local_bridge.lg")
	gplot(g5, nodelabel='A':'M', layout=spring_layout)
end

# ╔═╡ 44662f2f-b24e-4e6c-a173-23299250b1ff
using BenchmarkTools

# ╔═╡ 9b34b70b-ead8-40ef-9a16-6831a7a92141
using SNAPDatasets

# ╔═╡ 7c08cce9-c194-465e-8934-055f2f6f84da
using PlutoUI

# ╔═╡ f800da3e-2ffd-40a5-bfaf-33d32688e8af
html"""<button onClick="present()">present</button>"""

# ╔═╡ 5cdc2c64-0a61-11ec-2727-7513e274589e
md"""
# Strong and Weak Ties

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon

**Prerequisites**

- Introduction to Graphs

**Outcomes**

- Recognize open and closed triangles in a graph
- Understand concept of tradic closure
- Be able to identify global and local bridges in a network: visually and programatically
- Understand the "strength of weak ties"
- Be familiar with betwenness centrality and its use in graph partitioning

**References**

- [Easley and Kleinberg](https://www.cs.cornell.edu/home/kleinber/networks-book/) chapter 3
"""

# ╔═╡ e8898c44-0864-4d64-99a4-96c57905c46f
md"""
# Granovetter's question

- In the late 1960s a PhD student Mark Granovetter wanted to understand how people get a new job
- He interviewed many people who recently changed firms and asked how they got their job
- Unsurprisingly, people said they got referrals or learned about the job from personal contacts
- Surprisingly, most people said the contacts were made via their "aquaintances" and not "friends"
- Why?
"""

# ╔═╡ 382fcc1a-0df5-48b7-80ab-cbc5fece0d74
md"""
## Graphs for Information Flow

- To answer Granovetter's question, we'll turn to graphs
- As we'll see, this is one of many possible examples of how we can use a graph to study the **flow of information**
  - What other examples are there?
  - From what sources do you get your information?
  - Do you get different *types* of information from different *types* of source? Why?
- One interesting point to make in this regard is that by studying information flow via graphs we are making taking something inherently *interpersonal* or emotional (frienships and sharing information) and analyzing it from a *structural* perspective (as a graph)
- Keep these themes in mind as we study the theoreitcal/techinical tools
- We'll return back to the question Granovetter's question after building up some tools
"""

# ╔═╡ efd45a43-de4d-4d4c-b575-dfcfb06a02c7
md"""
# Triangles

- When studying graphs, the smallest possible structure involving more than two nodes is a triangle
- Triangles are made up of three nodes and either two or three edges that connect them
  - A triangle with only two edges is said to be *open*
  - A triangle with three edges is *closed*
- In the example below, there are 3 triangles, all of which are open
"""

# ╔═╡ 8cce7c54-4263-41d6-b1bb-49b7081a5311
begin 
	g1 = star_graph(4)
	add_vertex!(g1)
	gplot(g1, nodelabel='A':'E', layout=shell_layout)
end

# ╔═╡ 9a704d0f-b05d-4cf9-a31d-38a4c5077080
begin
	g2_test = copy(g1)
	add_edge!(g2_test, 3, 5)
	gplot(g2_test, nodelabel='A':'E', layout=shell_layout)
end

# ╔═╡ 616310c0-266f-4534-ace2-e586d5c20efa
local_clustering(g2_test)

# ╔═╡ 7bacdeff-97e7-4902-aa4e-f1698cba1315
md"""
## Social Triangles

- Suppose our graph is of students arriving for first year of college
- Each node is a student
- An edge represents a friendship or connection between students
- Story... 
  - `A` went to and out of school state, but happened to know `B`, `C`, and `D` from various summer camps or family-friend relationships
  - None of `B`, `C` and `D` know one another
- Question: Given only this information, is it more likely that `B` and `D` become friends, or `B` and `C`? Why?
"""

# ╔═╡ eb8d0345-2a5c-470a-9f70-0703aa1abd4f
md"""
## Closing triangles

- In our example graph the only edges are between A and another node
- Consider a triangle formed by nodes A, B, C
- To *close* this triangle, there would need to be a node between B-C as follows
"""

# ╔═╡ 1808620b-4ac3-4ae7-b442-ce72372ecfcd
begin
	g2 = copy(g1)
	add_edge!(g2, 2, 3)
	gplot(g2, nodelabel='A':'E', layout=shell_layout)
end

# ╔═╡ 948ca9e2-b7e6-438f-8f3f-e1b62cf82e60
md"""
## Triadic Closure

- There is overwhelming empirical evidence to support the intuition that when there are edges A-B and A-C, it is likely that an edge B-C will form
- This is known as **triadic closure** (closing the final edge of a triangle)
- For this reason, when analyzing social network data it is very common to see triangles
"""

# ╔═╡ a59ed1e0-248e-40b6-92a5-287d959e377c
md"""
## Triangles with LightGraphs

- There is good support in LightGraphs for helping us count triangles in a graph
- The two key functions are `triangles(g)` and `local_clustering(g)`
- `triangles(g)` will return an array of integers, where values correspond to how many closed triangels there are in the graph
"""

# ╔═╡ 759b1bcc-872f-4837-a52d-ed247d82bb43
triangles(g1)

# ╔═╡ a265f78e-cdfb-4b48-a228-328787ba204b
triangles(g2)

# ╔═╡ b2461922-d84d-418f-9349-2da2b1832cac
md"""
- The `local_clustering(g)` function will return a tuple of two things:
  1. The number of closed triangles for each node (same as `triangles(g)`)
  2. The number of *possible* triangles for each node in g
"""

# ╔═╡ 73431460-7fca-46b3-8a94-c99978943727
?lo

# ╔═╡ d37bf539-ba4a-4bad-9b49-529c31752878
local_clustering(g1)

# ╔═╡ 691be200-3798-4c0a-b89b-fdf3732597b4
local_clustering(g2)

# ╔═╡ 18504d01-4b75-40bf-94dd-2041ef650c51
md"""
## Clustering Coefficients

- It is helpful to have a single number summary of how "closed" a graphs triangles are
- The **clustering coefficient** tells us the fraction of triangles that are closed
- There is a local flavor, where we consider all triangles for a specific node
- There is also a global flavor where we consider all triangles for the entire graph
- LightGraphs.jl has functions `local_clustering_coefficient` and `global_clustering_coefficient` to compute these quantities respectively
"""

# ╔═╡ b00f160a-2a85-4488-8d08-316f761bc968
local_clustering_coefficient(g2)

# ╔═╡ 954fb52b-9079-4eea-a951-f492821bd161
global_clustering_coefficient(g2)

# ╔═╡ 45111ec6-6370-4274-af97-9dd949139f70
md"""
- **Question**: In the graph below, how many open triangles are there? How many closed?
"""

# ╔═╡ 8a114aa3-d928-46be-9705-f004fcabc678
gplot(g2, nodelabel='A':'E', layout=shell_layout)

# ╔═╡ e8155e31-6d22-49b9-95a1-e4c0cfe5ad62
md"""
# Bridges

- Consider the graph below
"""

# ╔═╡ 3f3de0c2-5172-40e9-a363-1a3f0cb65f8a
begin 
	g3 = barbell_graph(4, 4)
	gplot(g3, nodelabel='A':'H', layout=spring_layout)
end

# ╔═╡ 5c04a8df-6325-42b6-bb4d-6e39b27b0d11
local_clustering(g3, 4)

# ╔═╡ 44cc5acc-fdc9-4a11-b406-e917c75e72d4
md"""
- Now consider `D`
- Notice that connection between `D` and any of `A``B``C` is somehow different from connection to `E`
- `D-E` is known as a **bridge**
  - A *bridge* is an edge that, if removed, would cause the nodes involved to be in different components of the graph
"""

# ╔═╡ ca9c4ec8-e5b5-4e57-a136-45ef34ee7213
begin
	g4 = copy(g3)
	rem_edge!(g4, 4, 5)
	gplot(g4, nodelabel='A':'H', layout=spring_layout)
end

# ╔═╡ c7bbe09b-2654-4d3f-877e-40ebfc060a26
md"""
## Frequency of bridges

- Given our discussion on triadic closure, bridges are likely to be rare in real social networks
- It is very likely that an edge will form between `E` and one of `A``B``C`
- Even if that isn't the case, consider the possibility that the graph we have been looking at is actually a smaller subset of a larger graph:
"""

# ╔═╡ 2821ed48-705b-4f8f-b1fc-5329575efce5
md"""
**Local Bridges**

- In the graph above even if `D-E` were broken, there would only be one component in our graph
  - In other words there is another path from `D` to `E` (here `D-I-K-M-E`)
- Because true bridges are so rare, a looser definition of bridge was created called a *local bridge*
- An edge is a *local bridge* if `A` and `B` have no edges in common
"""

# ╔═╡ 207d4fa0-92d1-4c73-8375-e18dc99c3f2f
md"""
## Detecting Local Bridges

- So far we have dealt with example graphs that we can visually inspect
- Most real world graphs are far to large for this
- To analyze larger graphs we need computational tools
- Let's build up some code that will allow us to find local bridges
"""

# ╔═╡ c3419b5d-143c-4a8c-81c7-ac2f0a27a13d
function num_shared_neighbors(g, n1, n2)
	# total = 0
	# n2_neighbors = neighbors(g, n2)
	# for x in neighbors(g, n1)
	# 	if x in n2_neighbors
	# 		total += 1
	# 	end
	# end
	# total
	n1_neighbors = neighbors(g, n1)
	n2_neighbors = neighbors(g, n2)
	(n1_neighbors ∩ n2_neighbors) |> length
end

# ╔═╡ 7d05009d-cb2b-4a30-b5d8-d66eb4ba2e9c
function num_shared_neighbors_v2(g, n1, n2)
	total = 0
	n2_neighbors = neighbors(g, n2)
	for x in neighbors(g, n1)
		if x in n2_neighbors
			total += 1
		end
	end
	total
end

# ╔═╡ 009d6b13-c37e-4af9-b3af-115f8d505b64
@benchmark num_shared_neighbors_v2(g5, 3, 4)

# ╔═╡ 1f6284c7-1eab-4738-ba8e-3f0882135c03
@benchmark num_shared_neighbors(g5, 3, 4)

# ╔═╡ f696c8e9-9f2e-464e-871c-0f3348f7adba
md"""
- Now that we have a function for computing the number of shared neighbors, we can use it to build a routine for finding a local bridge
- We'll do that now
"""

# ╔═╡ 7f215bef-c862-46dc-9b89-ff53e5283572
has_edge

# ╔═╡ 7d08dfae-d619-4b0e-9844-8afd59e739bd
function local_bridges(g)
	out = []
	for n1 in 1:nv(g)
		for n2 in neighbors(g, n1)
			if (n2 < n1)
				continue
			end
			
			n_neighbors = num_shared_neighbors(g, n1, n2)
			if n_neighbors == 0
				# if we are connected, but have no neighbors 
				# we are a local bridge!
				push!(out, (n1, n2))
			end			
		end
	end
	return out
end

# ╔═╡ 8cc7f8a9-ea33-45d0-990b-043edbe5f453
local_bridges(g3)

# ╔═╡ 6632b0a1-42fb-4b63-950e-9e840484f68c
md"""
## Example: Twitter connections

- Let's now consider an example using real social network data
- Below we'll load up a graph called `tw` that is a graph of connections between twitter users
- Each node is a different twitter account
- There is an edge between nodes if either one of the accounts follows the other
"""

# ╔═╡ 58052c76-454c-41ea-82c6-0701ff4c612a
tw = loadsnap(:ego_twitter_u)

# ╔═╡ 99a41830-d5f1-4b33-94b5-58b8652e000b
md"""
- Notice that there are 81,306 nodes and 1,342,310 edges
- This is network is far to big to analyze visually
- Let's use a few of our empirical metrics to study the properties of this graph
"""

# ╔═╡ 493438ba-d55b-4fa0-b359-b7b50ac9e4aa
global_clustering_coefficient(tw)

# ╔═╡ 26dda823-b3eb-4dda-acd7-6d49ff4cfb35
tw_bridges = bridges(tw)

# ╔═╡ fa4c0109-9248-44c7-867b-b3832bad6e1d
ratio_bridges = length(tw_bridges) / ne(tw)

# ╔═╡ a8bf9347-c1f9-4bcc-bcbf-b6e755ba948a
md"""
Notice how only $(round(ratio_bridges * 100, digits=3))% of edges form a local bridge!
"""

# ╔═╡ 3a7fed46-c04c-4321-9832-3be119cf8585
md"""
# Edge Strength

- We have so far considered only whether or not two nodes are connected
- We have not discussed the strength of these connections
- We will now extend our analysis to the notion of an edge representing a strong or a weak tie
- In our friendship example, the strong ties would represent friends and the weak ties would represent acquaintances
"""

# ╔═╡ c4d6a245-7e80-4278-9cdf-7b826ca50125
md"""
## Strong and Weak ties

- In the figure below, we have a representation of a graph similar to our `g5` where all edges have been annotated with a `S` or a `W`
- A `S` edge represents a strong edge, or friendship
- A `W` edge represents a weak edge or, or acquaintance
"""

# ╔═╡ c180738b-4fea-42dc-8db8-c0598ec0f208
PlutoUI.LocalResource("./strong_weak_ties.png")

# ╔═╡ 0b9a9e9d-c626-49c9-9197-bc293ef107be
md"""
## Triadic Closure: Strong Vs Weak

- Let's extend the inutition behind triadic closure to our strong/weak setting
- Our argument was that because we have edges `A-B` and `A-C`, it is likely that an edge `B-C` will form
- Now we'll state that if `A-B` and `A-C` are both strong ties, then it is more likely that `B-C` will form than if either `A-B` or `A-C` were weak
- More formally... we have  the *Strong Triadic Closure Property*
> We say that a node `A` violates the Strong Triadic Closure Property if it has strong ties to two other nodes `B` and `C`, and there is no edge at all (either a strong or weak tie) between `B` and `C`. We say that a node `A` satisfies the Strong Triadic Closure Property if it does not violate it.
"""

# ╔═╡ 00f454b2-45ce-4b90-8c24-9918810be484
md"""
## Local Bridges and Weak Ties

- Given this definition of the Strong Triadic Closure Property, we can make the following claim (see section 3.2 of E&K for proof, intuition in figure below):
> Claim: If a node A in a network satifies the Strong Triadic Closure Property and is involved in at least two strong ties, then any local bridge it is involved in must be a weak tie.
"""

# ╔═╡ 855609da-010f-45fe-8f03-79d100abcf91
PlutoUI.LocalResource("./strong_triadic_closure.png")

# ╔═╡ 1eeba9e0-3fd2-48d1-a09f-0e020f926187
md"""
## Back to Granovetter

- Recall our original question: why do people report finding jobs through aquantainces (weak ties) more often than close friends (strong ties)?
- The Strong Triadic Closure Property gives the answer...
- Suppose `A` lost its job
  - By asking for a referral from any of `C`, `D`, or `E`; `A` is likely to get a similar set of information as they are strongly connected to one other and likely have access to the same set of information
  - Instead by talking to the weak tie `B`, `A` is likely to get new information from people in `B`'s social circle (including `H` and the three unlabeled nodes)
- tl;dr: local bridges are weak ties, so it is weak ties that get you access to "new" parts of the network
"""

# ╔═╡ 1b92e4d5-3aca-439c-af11-4f534244844c
PlutoUI.LocalResource("./strong_weak_ties.png")

# ╔═╡ e25cf15c-1cba-44e3-8c81-07f593388857
md"""
# Graph Partitioning

- Social networks often consist of tightly knit regions and weak ties that connect them
- One algorithmic problem that has is been studied and applied in many settings is that of graph partitioning
- To partition a graph is to break it down into the tightly-knit components
- When a graph is partitioned, it is broken down into components called *regions*
"""

# ╔═╡ 4064fc5f-9128-4f26-81ea-d8d9240f7819
PlutoUI.LocalResource("./partitioning.png")

# ╔═╡ 6727e617-d550-4b16-8607-199c523137c6
g6 = let 
	edges = LightGraphs.SimpleEdge.([
		(1,2), (1,3), (2,3), (3,7), (7,6), (6,4), (6,5), (4,5), (7,8),
		(8,9), (9,10), (10,11), (9,11), (8,12), (12,13), (13,14), (12,14)
	])
	SimpleGraph(edges) 
end

# ╔═╡ 6264dbf1-2048-4b6d-8936-859c792d6ff1
gplot(g6, nodelabel=1:14, layout=spring_layout)

# ╔═╡ 64adb743-803d-4f54-b2b2-b762bc5bbf43
md"""
## Two Approaches

- There are to classes of algorithms that can be used to partition a graph:
  1. Divisive: partition a graph by removing local bridges ("spanning links")  and breaking down the network into large chunks
  2. Agglomerative: start with a single node and construct regions "bottom-up" by iteratively finding nodes highly connected to existing nodes in the region
- We'll focus on divisive methods here
"""

# ╔═╡ f5b4404c-cc0b-470d-b8f3-a9310cb16682
md"""
## Betweenness Centrality

- In order to build a divisive partitioning algorithm, we'll first define a key metric for analyzing how "central" a node is in a network
- We'll provide a brief introduction here, and refer you to section 3.6 of E&K for more detail
- Let $V$ represent set of all nodes and $s, t, v \in V$
- Let $\sigma_{st}$ represent the number of shortest paths between $s$ and $t$
- Let $\sigma_{st}(v)$ represent the number of shortest paths between $s$ and $t$ that pass through $v$.
- Then, the **betweeness centrality**  for node $v$ ($C_{B}(v)$) is defined as: 
$$(C_{B}(v) = \sum_{s \ne v \ne t \in V} \frac{\sigma_{st}(v)}{\sigma_{st}}$$
- Conceptually, $C_B(v)$ captures how much information "flows" across node $v$ on average
"""

# ╔═╡ 98273b08-d9f8-47a7-8641-d10a1b227a36
md"""
## Computing $C_B(v)$

- There are various algorithms we could use to compute $C_B(v)$
- For now we will let LightGraphs.jl handle it for us ;)
"""

# ╔═╡ 90524705-27da-4146-8324-af44d572d698
betweenness_centrality(g6)

# ╔═╡ 472375c2-3ae0-4a04-9ea1-324dc013393e
md"""
- Note that `7` and `8` are a local bridge
- Also note that they carry the highest value of $C_B$...
"""

# ╔═╡ be2e064a-7538-46c5-9202-20dfc004bf4b
md"""
## Algorithm: Girvan-Newman

- We will not present the algorithm in detail, but will describe the overall steps
- Refer to Section 3.6 of E&K for details
- The Girvan-Newman algorithm for graph partitioning:
  - Inputs: node
  - Outputs: list of edges to delete at each step
  - Algorithm:
    1. Find nodes with highest betweenness centrality -- remove them from the network (and add edges connecting them to the network to the list of deleted edges for first step)
    2. Re-compute betweenness centrality for all subgraphs that resulted from deletion in step 1. Remove all nodes with highest betweenness centrality and record list of deleted edges
    3. Continue until all edges have been removed
"""

# ╔═╡ 6cce86e2-cbde-4a07-9db6-de7dd6b4e10e
md"""
# Summary: Key ideas


- Triangles are key network structures
- Closed triangles are common in social networks due to tradic closure
- Social networks are often composed of tightly knit regions bound together with weak ties
- Weak ties often form local bridges and are therefore valueable for referrals and information flow
- Betwenness centrality captures idea of how essential a node is in connecting regions of a graph (how much information flows across a node)
"""

# ╔═╡ 6ae7b62e-0162-4354-868e-feb96a5df265

md"""
## Dependencies
"""

# ╔═╡ ed266bdc-37ec-4c21-8698-cc9283db0aca
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

# ╔═╡ f5489fc9-01c1-4131-b343-53dfc82829d5
let 
	vals = [
		num_shared_neighbors(g5, 6, 7),
		num_shared_neighbors(g5, 4, 5)
	]
	if isnothing(vals[1])
		still_missing(md"Make sure your function returns something")
	elseif !(vals[1] isa Integer)
		keep_working(md"Your function should return an integer")
	elseif vals == [2, 0]
		correct()
	else
		keep_working(md"Answer isn't quite right")
	end
end

# ╔═╡ 22e413e0-5185-44db-9a4b-d4e24ed2b3c0
let 
	vals = [
		local_bridges(g5),
		local_bridges(g4)
	]
	if !(vals[1] isa Array)
		keep_working(md"Your function should return an integer")
	elseif length(vals[1]) == 0
		still_missing(md"Make sure to  push! onto out")
	elseif vals[1] == [(4,5)] && vals[2] == []
		correct()
	else
		keep_working(md"Answer isn't quite right")
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
GraphPlot = "a2cc645c-3eea-5389-862e-a155d0052231"
LightGraphs = "093fc24a-ae57-5d10-9952-331d41423f4d"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SNAPDatasets = "fc66bc1b-447b-53fc-8f09-bc9cfb0b0c10"

[compat]
BenchmarkTools = "~1.1.4"
GraphPlot = "~0.4.4"
LightGraphs = "~1.3.5"
PlutoUI = "~0.7.9"
SNAPDatasets = "~0.1.0"
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

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Statistics", "UUIDs"]
git-tree-sha1 = "42ac5e523869a84eac9669eaceed9e4aa0e1587b"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.1.4"

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

[[SNAPDatasets]]
deps = ["LightGraphs", "Test"]
git-tree-sha1 = "4df9b4298f93608554a6f3131fd7a1ce662734eb"
uuid = "fc66bc1b-447b-53fc-8f09-bc9cfb0b0c10"
version = "0.1.0"

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
# ╟─f800da3e-2ffd-40a5-bfaf-33d32688e8af
# ╟─5cdc2c64-0a61-11ec-2727-7513e274589e
# ╟─e8898c44-0864-4d64-99a4-96c57905c46f
# ╟─382fcc1a-0df5-48b7-80ab-cbc5fece0d74
# ╟─efd45a43-de4d-4d4c-b575-dfcfb06a02c7
# ╠═521c893c-116d-4912-a163-716b28e3773e
# ╠═8cce7c54-4263-41d6-b1bb-49b7081a5311
# ╠═9a704d0f-b05d-4cf9-a31d-38a4c5077080
# ╠═616310c0-266f-4534-ace2-e586d5c20efa
# ╟─7bacdeff-97e7-4902-aa4e-f1698cba1315
# ╟─eb8d0345-2a5c-470a-9f70-0703aa1abd4f
# ╠═1808620b-4ac3-4ae7-b442-ce72372ecfcd
# ╟─948ca9e2-b7e6-438f-8f3f-e1b62cf82e60
# ╟─a59ed1e0-248e-40b6-92a5-287d959e377c
# ╠═759b1bcc-872f-4837-a52d-ed247d82bb43
# ╠═a265f78e-cdfb-4b48-a228-328787ba204b
# ╟─b2461922-d84d-418f-9349-2da2b1832cac
# ╠═73431460-7fca-46b3-8a94-c99978943727
# ╠═d37bf539-ba4a-4bad-9b49-529c31752878
# ╠═691be200-3798-4c0a-b89b-fdf3732597b4
# ╟─18504d01-4b75-40bf-94dd-2041ef650c51
# ╠═b00f160a-2a85-4488-8d08-316f761bc968
# ╠═954fb52b-9079-4eea-a951-f492821bd161
# ╟─45111ec6-6370-4274-af97-9dd949139f70
# ╠═8a114aa3-d928-46be-9705-f004fcabc678
# ╟─e8155e31-6d22-49b9-95a1-e4c0cfe5ad62
# ╠═5c04a8df-6325-42b6-bb4d-6e39b27b0d11
# ╠═3f3de0c2-5172-40e9-a363-1a3f0cb65f8a
# ╟─44cc5acc-fdc9-4a11-b406-e917c75e72d4
# ╠═ca9c4ec8-e5b5-4e57-a136-45ef34ee7213
# ╟─c7bbe09b-2654-4d3f-877e-40ebfc060a26
# ╠═2888aac7-2228-44a6-a8b4-2a7d468fac67
# ╟─2821ed48-705b-4f8f-b1fc-5329575efce5
# ╟─207d4fa0-92d1-4c73-8375-e18dc99c3f2f
# ╠═c3419b5d-143c-4a8c-81c7-ac2f0a27a13d
# ╠═7d05009d-cb2b-4a30-b5d8-d66eb4ba2e9c
# ╠═44662f2f-b24e-4e6c-a173-23299250b1ff
# ╠═009d6b13-c37e-4af9-b3af-115f8d505b64
# ╠═1f6284c7-1eab-4738-ba8e-3f0882135c03
# ╟─f5489fc9-01c1-4131-b343-53dfc82829d5
# ╟─f696c8e9-9f2e-464e-871c-0f3348f7adba
# ╠═7f215bef-c862-46dc-9b89-ff53e5283572
# ╠═7d08dfae-d619-4b0e-9844-8afd59e739bd
# ╠═8cc7f8a9-ea33-45d0-990b-043edbe5f453
# ╟─22e413e0-5185-44db-9a4b-d4e24ed2b3c0
# ╟─6632b0a1-42fb-4b63-950e-9e840484f68c
# ╠═9b34b70b-ead8-40ef-9a16-6831a7a92141
# ╠═58052c76-454c-41ea-82c6-0701ff4c612a
# ╟─99a41830-d5f1-4b33-94b5-58b8652e000b
# ╠═493438ba-d55b-4fa0-b359-b7b50ac9e4aa
# ╠═26dda823-b3eb-4dda-acd7-6d49ff4cfb35
# ╠═fa4c0109-9248-44c7-867b-b3832bad6e1d
# ╟─a8bf9347-c1f9-4bcc-bcbf-b6e755ba948a
# ╟─3a7fed46-c04c-4321-9832-3be119cf8585
# ╟─c4d6a245-7e80-4278-9cdf-7b826ca50125
# ╟─c180738b-4fea-42dc-8db8-c0598ec0f208
# ╟─0b9a9e9d-c626-49c9-9197-bc293ef107be
# ╟─00f454b2-45ce-4b90-8c24-9918810be484
# ╟─855609da-010f-45fe-8f03-79d100abcf91
# ╟─1eeba9e0-3fd2-48d1-a09f-0e020f926187
# ╠═1b92e4d5-3aca-439c-af11-4f534244844c
# ╟─e25cf15c-1cba-44e3-8c81-07f593388857
# ╟─4064fc5f-9128-4f26-81ea-d8d9240f7819
# ╠═6727e617-d550-4b16-8607-199c523137c6
# ╠═6264dbf1-2048-4b6d-8936-859c792d6ff1
# ╟─64adb743-803d-4f54-b2b2-b762bc5bbf43
# ╟─f5b4404c-cc0b-470d-b8f3-a9310cb16682
# ╟─98273b08-d9f8-47a7-8641-d10a1b227a36
# ╠═90524705-27da-4146-8324-af44d572d698
# ╟─472375c2-3ae0-4a04-9ea1-324dc013393e
# ╟─be2e064a-7538-46c5-9202-20dfc004bf4b
# ╟─6cce86e2-cbde-4a07-9db6-de7dd6b4e10e
# ╟─6ae7b62e-0162-4354-868e-feb96a5df265
# ╠═7c08cce9-c194-465e-8934-055f2f6f84da
# ╟─ed266bdc-37ec-4c21-8698-cc9283db0aca
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
