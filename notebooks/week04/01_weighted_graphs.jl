### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ bc448589-2b3a-4c02-878e-c18ed75005e9
using LightGraphs, SimpleWeightedGraphs, GraphPlot, LightGraphs.LinAlg

# ╔═╡ ed69dcda-cd95-4df9-b0d1-167acd81868b
using PlutoUI

# ╔═╡ 45accdfc-1563-11ec-08ef-97bfa9e48799
md"""
# Weighted Graphs and Structural Balance

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon

**Prerequisites**

- Introduction to Graphs
- Strong and Weak Ties

**Outcomes**

- Know what a weighted graph is and how to construct them using `SimpleWeightedGraphs.jl`
- Understand the structural balance property for sets of three nodes
- Understand the structural balance theorem for a graph
- Recognize structural balance in a weighted graph

**References**

- [Easley and Kleinberg](https://www.cs.cornell.edu/home/kleinber/networks-book/) chapter 5 (especially section 5.1-5-3)
"""

# ╔═╡ dbd0708b-e72c-43f5-9b6f-615a21bc5e98
md"""
# Weighted Graphs

- So far we have considered a few types of graphs
  - Undirected graph: nodes $A$ and $B$ are connected by an edge 
  - Directed graph: connection from node $A$ to node $B$
  - Strong/weak graphs: each edge is labeled as strong or weak
- Today we extend our understanding of networks to talk about *weighted graphs*
  - Each edge is assigned a `Float64` denoting the strength of tie
  - Ties can be positive (friends) or negative (enemies)
  - Can also very in strength (+2.0 better friends than +0.2)
"""

# ╔═╡ 972d21c5-0611-481a-8814-322281be8fa3
md"""
## Weighted Adjacency Matrix

- In a simple (unweighted) graph, we used a matrix of 0's and 1's as an adjacency matrix
  - A 1 in row i column j marked an edge between i and j (or from i->j for directed)
  - A 0 marked lack of an edge
"""

# ╔═╡ 4c66a05c-068f-46ca-b8bd-aa0b944f153d
begin
	G1 = complete_graph(4)
	A1 = adjacency_matrix(G1)
end

# ╔═╡ 6b5e8df1-fbcb-423b-8c4c-7cecdc933bc3
begin
	locs_x = [1, 2, 3, 2.0]
	locs_y = [1.0, 0.7, 1, 0]
	labels1 = collect('A':'Z')[1:nv(G1)]
	gplot(G1, locs_x, locs_y, nodelabel=labels1)
end

# ╔═╡ 3dc257e1-1a28-48cd-9228-c903c1e9cdd3
md"""
- We can extend idea of adjacency matrix to include *weighted* edges
- Suppose nodes A, B, C are friends -- but A-C are **best** friends
- Also suppose that all of A, B, C consider D an enemy
- To represent this we might say weight of edges is:
  - `A-B` and `B-C`: 1.0
  - `A-C`: 2.0
  - `A-D`, `B-D`, `C-D`: -1.0
- Here's the adjacency matrix
"""

# ╔═╡ 1f250d48-5e23-4762-a008-c004ad2a07e0
A2 = [0 1 2 -1; 1 0 1 -1; 2 1 0 -1; -1 -1 -1.0 0]

# ╔═╡ 6b4d87dd-b4be-4136-a969-769ec1f8c704
md"""
- And here is how we might visualize this graph (notice the labeled edges)
"""

# ╔═╡ 812cf46e-df18-4859-b64c-4482fbf1828a
begin
	G2 = SimpleWeightedGraph(A2)
	gplot(
		G2, locs_x, locs_y,
		nodelabel=labels1, edgelabel=weight.(edges(G2)),
	)
end

# ╔═╡ 420658be-a90b-496a-8eaa-9b9d942d9f80
md"""
# Shortest Paths

- We talked previously about shortest paths for a Graph
- This was defined as the minimum number of edges needed to move from node n1 to node n2
- When we have a weighted graph things get more interesting...
- Let $w_{ab}$ represent the weight connecting nodes $A$ and $B$
- Define the shortest path between n1 and n2 as the path that minimizes $\sum w_{ab}$ for all edges `A->B` along a path
"""

# ╔═╡ 72cdbc06-73c1-450b-8670-fd806021f44b
md"""
## Example

- Consider the following directed graph
"""

# ╔═╡ 76cc9079-51ab-485c-af48-448dccdc121a
begin
	A3 = [
		0 1 5 3 0 0 0
		0 0 0 9 6 0 0
	    0 0 0 0 0 2 0
		0 0 0 0 0 4 8
		0 0 0 0 0 0 4
		0 0 0 0 0 0 1
		0 0 0 0 0 0 0
	]
	locs_x_3 = [3, 5, 1, 3, 4, 2, 3.0]
	locs_y_3 = [1, 2, 2, 3, 4, 4, 5.0]
	labels3 = collect('A':'Z')[1:size(A3, 1)]
	G3 = SimpleWeightedDiGraph(A3)
	gplot(G3, locs_x_3, locs_y_3, nodelabel=labels3, edgelabel=weight.(edges(G3)))
end

# ╔═╡ e8e6e56a-fb85-4aca-9287-8fa16cbeff3d
md"""
- We wish to travel from node A to node G at minimum cost
- The shortest path (ignoring weights)  is A-D-G
- Taking into account weights we have 3 + 8 = 11
- There are two other paths that lead to lower cost (total of 8)
  - `A-C-F-G` has cost 5 + 2 + 1 = 8
  - `A-D-F-G` has cost 3 + 4 + 1 = 8
- For this small graph, we could find these paths by hand
- For a larger one, we will need an algorithm...
"""

# ╔═╡ 02a9938d-267f-444c-838f-87209c16db18
md"""
## Shortest path algorithm

- Let $J(v)$ be the minimum cost-to-go from node $v$ to node G
- Suppose that we know $J(v)$ for each node $v$, as shown below for our example graph
  - Note $J(G) = 0$
"""

# ╔═╡ bc42e89e-6f98-44b9-bb4b-49ba272d24bd
Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week04/graph_costs.png")

# ╔═╡ e6a5520c-14b5-47e5-9321-e5962fa9128d
md"""
- With $J(v)$ in hand, the following algorithm will find the cost-minimizing path from $A$ to $G$:
  1. Start with $v = A$
  2. From current node $v$ move to any node that solves $\min_{n \in F_v} w_{vn} + J(n)$, where $F_v$ is the set of nodes that can be reached from $v$. 
  3. Update notation to set $v = n$
  3. Repeat steps 2-3 (making note of which we visit) until $v = G$
"""

# ╔═╡ a3922e9d-7d70-403e-ae02-14854810de2c
md"""
## Exercise: Traversing Cost-Minimizing Path

- Let's implement the algorithm above
- Below I have started a function called `traverse_graph`
- Your task is to complete it until you get that the minimum cost path has a cost of 8 and length(4)
"""

# ╔═╡ 23eea7e4-3b75-4f64-a9d0-b6a86625db0a
J3 = [8, 10, 3, 5, 4, 1, 0]

# ╔═╡ ff14f217-55f4-46ec-bc31-33621102d9e3
[2^i for i in 1:3]

# ╔═╡ 89f0aadd-c8dc-41dd-ba42-1be3a4790614
weights(G3)

# ╔═╡ da34599b-5a87-4e32-a90f-61cc5294a18d
function traverse_graph(
		G::SimpleWeightedDiGraph, 
		J::AbstractArray, 
		start_node::Int, end_node::Int
	)
	path = Int[start_node]
	cost = 0.0
	W = weights(G)
	
	# TODO: step1, initialize v
	v = start_node  # CHANGE ME
	num = 0
	while v != end_node && num < nv(G)  # prevent infinite loop
		num +=1
		F_v = neighbors(G, v)
		
		# TODO: step 2, compute costs for all n in F_v
		costs = [W[v,n] + J[n] for n in F_v]  # CHANGE ME
		
		n = F_v[argmin(costs)]
		
		# TODO: how should we update cost?
		cost += W[v,n]   # CHANGE ME
		
		push!(path, n)
		
		# TODO: step 3 -- update v
		v = n  # CHANGE ME
	end
	path, cost
end

# ╔═╡ 2daeca75-78c2-4e69-be22-46d7877f3eed
traverse_graph(G3, J3, 1, 7)

# ╔═╡ 26c90ff4-fe3b-472d-8342-4ee8e4b0e596
md"""
## But what about $J(v)$

- The shortest path algorithm we presented above sounds simple, but assumed we know $J(v)$ 
- How can we find it?
- If you stare at the following equation long enough, you'll be convinced that $J$ satisfies
$$J(v) = \min_{n \in F_v} w_{vn} + J(n)$$
- This is known as the *Bellman equation*
- It is a restriction that $J$ must satisfy
- We'll use this restriction to compute $J$
"""

# ╔═╡ 5a58ce89-1884-4309-8828-db5e2229f395
md"""
## Computing J: Guess and Iterate

- We'll present the standard algorithm for computing $J(v)$
- This is an iterative method
- Let $i$ represent the iteration we are on and $J_i(v)$ be the guess for $J(v)$ on iteration $i$
- Algorithm
  1. Set $i=0$, and $J_i(v) = 0 \forall v$
  2. Set $J_{i+1}(v) = \min_{n \in F_v} w_{vn} + J_i(n) \forall n$
  3. Check if $J_{i+1}$ and $J_i$ are equal for all $v$ -- if not set $i = i+1$ and see repeat steps 2-3
- This algorithm converges to $J$ (we won't prove it here...)
"""

# ╔═╡ f998df9e-ab7e-4212-9ea8-fb915031f6d6
md"""
## Implementation

- Let's now implement the algorithm!
- We'll walk you through our implementation
"""

# ╔═╡ 650e0c6e-6aed-4991-a19d-9323f6a63fa7
cost(W, J, n, v) = W[v, n] + J[n]

# ╔═╡ 93351673-6b2f-4e9d-8ea3-ea6d66d99e82
function compute_J(G::SimpleWeightedDiGraph, dest_node::Int)
	N = nv(G)
	# step 1. start with zeros
	i = 0
	Ji = zeros(N)
	
	next_J = zeros(N)
	
	W = weights(G)
	
	done = false
	while !done
		i += 1
		for v in 1:N
			if v == dest_node
				next_J[v] = 0
				continue
			end
			F_v = neighbors(G, v)
			costs = [W[v,n] + Ji[n] for n in F_v]
			next_J[v] = minimum(costs)
		end
		done = all(next_J .≈ Ji)
		copy!(Ji, next_J)
	end
	Ji		
end

# ╔═╡ d24e82f4-9c57-4149-8a1f-08df047a34f1
compute_J(G3, 7)

# ╔═╡ 5cfbc13b-cee3-436b-8925-532861aae82f
md"""
## Exercise: Shortest Path

- Let's now combine the two functions to compute a shortest path (and associated cost) for a graph
- Your task is to fill in the function below and get the test to pass
"""

# ╔═╡ 8421a19b-b583-4e4a-a0e3-36657e6bb714
"""
Given a weighted graph `G`, enumerate a shortest path between `start_node` and `end_node`
"""
function shortest_path(G::SimpleWeightedDiGraph, start_node::Int, end_node::Int)
	J = compute_J(G, end_node)
	traverse_graph(G, J, start_node, end_node)
end

# ╔═╡ 26551afc-3a4b-4c86-9695-4e9815e99c84
md"""
# Structural Balance

- We now shift our discussion to the notion of whether or not a network is balanced
- For this discussion we will use weighted graphs, where weights are one of
  - 1: if nodes are friends (also called `+`)
  - 0: if they don't know eachother
  - -1: if nodes are enemies (also called `-`)
- We won't consider strength of ties right now
- We will also limit discussion to complete graphs (cliques) where all nodes are connected to all other nodes
"""

# ╔═╡ 3ab5c326-51cb-4388-94c1-85290d604433
md"""
## Balance in Triangles

- To start thinking about balance, consider the possible configurations of `+` and `-` edges in a triangle
- There are 4 options as shown below
"""

# ╔═╡ b6940214-f927-4449-9bba-c1494579c077
Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week04/balance_in_triangles.png")

# ╔═╡ c0921a88-96b0-4b9b-8d74-0769d7aac958
md"""
- In (a) all people are friends -- this is happy and balanced
- In (c) A-B are friends with a common enemy C -- nobody has reason to change alliances => balanced
- In (b) A is friends with B and C, but they are enemies -- B and C may try to flip A against other => not balanced
- In (d) all are enemies -- two parties have incentive to team up against common enemy => not balanced
"""

# ╔═╡ 5bcdab44-a7f4-486f-bb55-a4a38835333f
md"""
## Balance In Graphs

- This definition of balance in triangles can be extended to graphs
- A complete graph G satisfies the **Structural Balance Property** if for *every* set of three nodes, exactly one or three of the edges is labeled `+`
"""

# ╔═╡ 25f61333-7837-4800-affe-6d1447486b3f
md"""
## Implications: Balance Theorem

- One implication of the Structural Balance Property is the **Balance Theorem**
> If a labeled complete graph is balanced, then either all pairs of nodes are friends, or else the nodes can be divided into two groups, X and Y , such that every pair of nodes in X like each other, every pair of nodes in Y like each other, and everyone in X is the enemy of everyone in Y .
- Notice the strength of the statement: either all `+` or two mutually exclusive groups of friends that are all enemies with other group

"""

# ╔═╡ 8481d3ce-548d-4fc0-a04d-a9d172981c9d
md"""
## Proving Balance Theorem

- We will provide some intuition for how to prove the Balance Theorem, which will help us understand why it is true
- Consider a complete Graph `G`
- Two alternative cases:
  1. Everyone is friends: satisfies theorem by definition
  2. There are some `+` and some `-` edges: need to prove
- For case 2, we must be able to split G into $X$ and $Y$ where the following hold
  1. Every node in $X$ is friends with every other node in $X$
  2. Every node in $Y$ is friends with every other node in $Y$
  3. Every node in $X$ is enemies with every node in $Y$
"""

# ╔═╡ 23adeae5-4ef7-493a-a9b1-caafcedef4e4
md"""
## Proof by construction

- Start with complete, balanced graph $G$ (our only assumption!)
- We will prove the balance theorem by constructing sets $X$ and $Y$ and verifying that the members of these sets satisfy the 3 properties outlined above
- To start, pick any node $A \in G$
- Divide all other nodes that are friends with $A$ into $X$ and enemies into $Y$
- Because $G$ is complete, this is all nodes
"""

# ╔═╡ c3ffb80b-00d4-41de-b287-8fd3178ce454
md"""
### Condition 1: $\forall B, C \in X B => C = +$

- Let $B, C \in X$
- We know $A => B = +$ and $A => C = +$
- Because graph is balanced, this triangle must have 1 or 3 +
- There are already 2, so it must be that $B => C = +$
- B, C were arbitrary, so this part is proven
"""

# ╔═╡ 4dbfda3d-5173-40e7-b821-832143a0e8f6
md"""
### Condition 2: $\forall D, E \in Y \; D => E = +$

- Let $D, E \in Y$
- We know $A => D = -$ and $A => E = -$
- Because graph is balanced, this triangle must have 1 or 3 +
- There no + and only one option left, so it must be that $D => E = +$
- D, E were arbitrary, so this part is proven
"""

# ╔═╡ e76cf8d2-33f4-4d9f-b633-ff9106f2fd10
md"""
### Condition 3: $\forall B \in X$ and $E \in Y \; B => E = -$

- Let $B \in X$ and $D \in Y$
- We know $A => D = -$ and $A => B = +$
- Because graph is balanced, this triangle must have 1 or 3 +
- There is one + (A=>B) and only one option left, so it must be that $B => D = -$
- B, D were arbitrary, so this part is proven
"""

# ╔═╡ ee98c8fc-5757-4274-9082-359748b7c322
md"""
### Summary

- We've just proven that for any complete, balanced graph $G$; we can partition $G$ into sets $X$ and $Y$ that satisfy the group structure of all friends or two groups of friends
- This has interesting implications for fields like social interactions, international relations, and online behavior
"""

# ╔═╡ 950208e3-bfc4-430e-abdb-49f5b3aa5695
md"""
## Application: International Relations

- Consider the evolution of alliances in Europe between 1872 and 1907 as represented in the graphs below
"""

# ╔═╡ 112986d2-be85-46a7-abff-6a04f0f071b7
Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week04/balance_international_relations.png")

# ╔═╡ 1f55f146-ad22-4b87-bb79-94b069c1652d
md"""
## Dependencies
"""

# ╔═╡ 4a623bd1-bed5-455c-a50e-67bc6c0d1c90
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

# ╔═╡ 8eff8daa-de71-4c37-abdb-e2f1199c215c
default_checks("traverse_graph", traverse_graph(G3, J3, 1, 7), ([1,3,6,7], 8.0))

# ╔═╡ 4234ddd1-1a81-4ba8-b000-d2ce5492a5e1
default_checks("shortest_path", shortest_path(G3, 1, 7), ([1, 3, 6, 7], 8.0))

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
PlutoUI = "~0.7.9"
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
# ╟─45accdfc-1563-11ec-08ef-97bfa9e48799
# ╟─dbd0708b-e72c-43f5-9b6f-615a21bc5e98
# ╟─972d21c5-0611-481a-8814-322281be8fa3
# ╠═bc448589-2b3a-4c02-878e-c18ed75005e9
# ╠═4c66a05c-068f-46ca-b8bd-aa0b944f153d
# ╠═6b5e8df1-fbcb-423b-8c4c-7cecdc933bc3
# ╟─3dc257e1-1a28-48cd-9228-c903c1e9cdd3
# ╟─1f250d48-5e23-4762-a008-c004ad2a07e0
# ╟─6b4d87dd-b4be-4136-a969-769ec1f8c704
# ╠═812cf46e-df18-4859-b64c-4482fbf1828a
# ╟─420658be-a90b-496a-8eaa-9b9d942d9f80
# ╟─72cdbc06-73c1-450b-8670-fd806021f44b
# ╠═76cc9079-51ab-485c-af48-448dccdc121a
# ╟─e8e6e56a-fb85-4aca-9287-8fa16cbeff3d
# ╟─02a9938d-267f-444c-838f-87209c16db18
# ╟─bc42e89e-6f98-44b9-bb4b-49ba272d24bd
# ╟─e6a5520c-14b5-47e5-9321-e5962fa9128d
# ╟─a3922e9d-7d70-403e-ae02-14854810de2c
# ╠═23eea7e4-3b75-4f64-a9d0-b6a86625db0a
# ╠═ff14f217-55f4-46ec-bc31-33621102d9e3
# ╠═89f0aadd-c8dc-41dd-ba42-1be3a4790614
# ╠═da34599b-5a87-4e32-a90f-61cc5294a18d
# ╠═2daeca75-78c2-4e69-be22-46d7877f3eed
# ╟─8eff8daa-de71-4c37-abdb-e2f1199c215c
# ╟─26c90ff4-fe3b-472d-8342-4ee8e4b0e596
# ╟─5a58ce89-1884-4309-8828-db5e2229f395
# ╟─f998df9e-ab7e-4212-9ea8-fb915031f6d6
# ╠═650e0c6e-6aed-4991-a19d-9323f6a63fa7
# ╠═93351673-6b2f-4e9d-8ea3-ea6d66d99e82
# ╠═d24e82f4-9c57-4149-8a1f-08df047a34f1
# ╟─5cfbc13b-cee3-436b-8925-532861aae82f
# ╠═8421a19b-b583-4e4a-a0e3-36657e6bb714
# ╟─4234ddd1-1a81-4ba8-b000-d2ce5492a5e1
# ╟─26551afc-3a4b-4c86-9695-4e9815e99c84
# ╟─3ab5c326-51cb-4388-94c1-85290d604433
# ╟─b6940214-f927-4449-9bba-c1494579c077
# ╟─c0921a88-96b0-4b9b-8d74-0769d7aac958
# ╟─5bcdab44-a7f4-486f-bb55-a4a38835333f
# ╟─25f61333-7837-4800-affe-6d1447486b3f
# ╟─8481d3ce-548d-4fc0-a04d-a9d172981c9d
# ╟─23adeae5-4ef7-493a-a9b1-caafcedef4e4
# ╟─c3ffb80b-00d4-41de-b287-8fd3178ce454
# ╟─4dbfda3d-5173-40e7-b821-832143a0e8f6
# ╟─e76cf8d2-33f4-4d9f-b633-ff9106f2fd10
# ╟─ee98c8fc-5757-4274-9082-359748b7c322
# ╟─950208e3-bfc4-430e-abdb-49f5b3aa5695
# ╟─112986d2-be85-46a7-abff-6a04f0f071b7
# ╟─1f55f146-ad22-4b87-bb79-94b069c1652d
# ╠═ed69dcda-cd95-4df9-b0d1-167acd81868b
# ╟─4a623bd1-bed5-455c-a50e-67bc6c0d1c90
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
