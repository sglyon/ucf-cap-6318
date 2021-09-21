### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 6c44053d-8f87-4dd6-86db-f3de18cf3578
using GameTheory

# ╔═╡ 0df288f6-f666-4dac-8478-fe87405cb7d7
using PlutoUI

# ╔═╡ a957fb7d-6353-4b34-8697-b9372e476b8a
html"""<button onClick="present()">present</button>"""

# ╔═╡ e02a30fc-158d-11ec-2b91-ff616d46d9bf
md"""
# Introduction to Game Theory

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon

**Prerequisites**

- Julia basics

**Outcomes**

- Understand the basic structure of a Game
- Be able to identify any Nash Equilibria in pure strategies for a normal form game
- Understand how normal form and extensive form games are related

**References**

- [Easley and Kleinberg](https://www.cs.cornell.edu/home/kleinber/networks-book/) chapter 6 
"""

# ╔═╡ a6337952-501f-40d4-8d7d-91df1161275f
md"""
# Game Theory

- Computational social science analyzes the connectedness of natural, social, and technological systems
- **Graph theory** (networks) has helped us understand how the *structure* of relationships influence outcomes
- We now turn to how behaviors, incentives, and strategies influence choices (and thus outcomes)
- The study of how entities make strategic choices in settings where outcomes depend on individual choices and the choices of others is called **game theory**
- Game theory is a very rich topic at the intersection of mathematics and economics
- We will study key concepts, but will not cover them in detail or exhaustively
"""

# ╔═╡ 26c601b4-07f0-44b1-bffe-00f7de1689ea
md"""
## What is a Game?

- A game is a description of a strategic environment composed of three elements:
  1. A finite set of $N$ players
  2. For each player $i$, a set of feasible actions $S_i$
     - Define $\Sigma = \times_i S_i$ as action space  and $\sigma$ as typical element
  3. For each player $i$, a payoff function $p_i:\Sigma \rightarrow \mathbb{R}$
- To help with notation we'll focus on two player games (N=2)
- We'll also start by considering that each player has a discrete set of actions (WLOG call them $1 \dots M_i$ for player i$)
- Basic concepts and definitions can be naturally extended to cases where $N>2$
"""

# ╔═╡ a506a11a-b75d-421a-81a0-d7ce3dd9c907
md"""
# Example: Prisoner's Dilemma

- A very famous example of a game is called the prisoner's dilemma
- Story: two robbery suspects brought in for questioning
- Investigator immediately separates them and gives both the same deal
> If you confess and your partner doesn't, you go free and he gets 10 years. If you both confess you each get 4 years, and if neither confesses you each get 1 year.
- The payoffs for this game can be summarized as follows:
"""

# ╔═╡ d5095d4a-25b6-44f5-97d6-fa76ac870680
Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week05/prisoners_dilemma.png")

# ╔═╡ 972dcf68-6b37-45a7-9413-61a3a089c213
md"""
- Each table entry has two items 
- In terms of our definition of a game we have...
  - N = 2 players
  - Strategys: $S_i = \{\text{not confess}, \text{ confess} \}$ for both players
  - Payoffs $p_i$ as specified in the table
"""

# ╔═╡ bfb77fb1-2e33-4baf-aad5-1ef8282bddd2
md"""
## Payoffs as matrices

- A common representation of payoffs for a single player is a matrix called the **payoff** matrix $P_i \in \mathbb{R}^{M_1 \times M_2}$ 
- The row i, column j element gives the payoff when player i chooses the $i$th action in $S_1$ and player j chooses the $j$th action in $S_2$
- For the Prisoner's Dilemma game above, we have
"""

# ╔═╡ 471c57b9-a8d9-4cf5-b401-58a29587d0f9
begin 
	pd_p1 = [-1 -10; 0 -4]
	pd_p2 = [-1 0 ;-10 -4]
end

# ╔═╡ bab2dbea-d538-43c6-bbee-c7c54997ad49
md"""
## Best Responses

- What would happen in the Prisoner's dilemma game?
- You may think that these partners in crime would like to stick together and get a total of 1 year each by not confessing
- However, that doesn't happen
- The investigator knows game theory and rigged the game against them...
"""

# ╔═╡ c74e47c5-1afb-4d3a-9344-48db12cad6ce
md"""
### What should Suspect 1 Do?

- Let's consider suspect 1
"""

# ╔═╡ f47f7d66-19c9-469f-a6c9-4abd91c7c555
pd_p1

# ╔═╡ e5b129b2-c1d1-43ab-b258-12c070573db5
md"""
- Suppose suspect 1 believes suspect 2 will not confess
  - Suspect 1 now faces the first column of `pd_p1` and sees he's better of confessing and getting 0 years instead of -1
- What if supsect 1 believes suspect 2 will confess?
  - 1 now faces second column and prefers -4 to a -10, so he still chooses to confess
- In either case, suspect 1's **best response** is to confess
- Because confess is always a best response, we call it a dominating strategy (in this strictly dominating because it is always strictly better than not confess)
"""

# ╔═╡ 68a2be6e-255d-47b1-aa58-fcbf4b7fb6e2
md"""
## How about Suspect 2?

- If we look closely as supsect 2's payoffs we see his game is symmetric to suspect 1's:
"""

# ╔═╡ 4fa2dfc2-99e6-43a6-aad9-76ae86ea3f46
pd_p2

# ╔═╡ c5b7c676-68e6-4c40-ae73-a62a99465b51
md"""
- No matter what suspect 1 chooses, suspect 2's best response is to confess
- The rational outcome is that both players confess and spend 4 years together in prison
"""

# ╔═╡ 487bd475-a276-41db-8ca8-aa4ca01e6b66
md"""
## Nash Equilibrium

- How did this happen? How is it a *rational* outcome i.e. an *equilibrium*?
- A famous concept in game theory is called Nash equilbirum (after famous economist John Nash)
- Definition: A strategy $\sigma$ is a Nash equilibrium if $\sigma_i$ is a best response to $\sigma_{-i}$ (everyone else's actions)
- Intuition: A strategy is an Nash equilibrium if *after* taking into account every one else's strategies, each player does not want to change their own
"""

# ╔═╡ b88dd9fd-1105-43b3-b00a-ebc7ab1d17da
md"""
## Computing Nash Equilibria

- There are various algorithms that we can use for computing Nash equilibria
- Fow now we will utilize the implementation of these algorithms in the GameTheory.jl package
- Let's load it up and create a version of our prisoner's dilemma game:
"""

# ╔═╡ 12f6aa12-e924-4435-903d-5d6c25b63196
p1 = Player(pd_p1)

# ╔═╡ 12cfea9d-7eb3-4dbb-9992-71d2ab99268f
md"""
- GameTheory.jl requires that payoff matrices are always specified from the perspective of the current player
- This means that we need to "reorient" suspect 2's payoffs such that his actions are noted on the rows
- Becuase this is a symmetric game, suspect 2's payoffs from suspect 2's perspective looks exactly the same as suspect 1's payoffs from suspect 1's perspective
- We can construct our `NormalFormGame` with two copies of the `p1` player above
"""

# ╔═╡ 1717c87f-c70b-4f77-afd2-9fb431487115

pd_g = NormalFormGame([p1, p1])

# ╔═╡ 87b7614f-5009-416c-9574-01853cd4dca4
md"""
- We can now ask GameTheory.jl to compute the nash Equilibria for us
- We'll use the `pure_nash` function to do this (we'll talk about what "pure" means soon)
"""

# ╔═╡ 6e6a34d9-b8cf-4cff-8421-65b4c5c6feff
pd_eq = pure_nash(pd_g)

# ╔═╡ b56dc651-f6c2-452a-8086-a8a075a9057c
md"""
- As we said before, the only equilibrium outcome to this game is that they both confess
- We can see the payoffs each player gets in equilibrium by "indexing" into the game using the strategy array
- The two expressions below are equivalent in this case
"""

# ╔═╡ ba6c46c1-ef35-4088-896a-1f4fad525823
pd_g[pd_eq[1]...]

# ╔═╡ 4763c377-d83e-4a94-9ce1-34d5bd20e4b6
# ↑ Equivalent to ↓
pd_g[2, 2]

# ╔═╡ f3ae8777-5019-4623-b76e-b5330ed6c90f
md"""
# Non symmetric games

- Not all games are symmetric like the prisoner's dilemma
- Consider the following game
  - Two players (firms) and two strategies each (sell low price or upscale goods)
  - 60% of total spending comes from people who prefer low prices
  - Firm 1 more popular, so when they compete in same segment, firm 1 gets 80% of market
- Below you find the payoff matrix in units of "% of total possible profit"
"""

# ╔═╡ dc95963f-743f-4c80-b1a4-333600025ecf
Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week05/marketing_game.png")

# ╔═╡ 4672d3bf-be6b-4aaf-81d7-cb9c63ab21e7
md"""
## Strategies

- Firm 1 has a dominant strategy: low-priced. They will always play this strategy
- Firm 2 is less clear:
  - If firm 1 were to choose the upscale market, they would be better off choosing low-priced
  - however, when firm 1 chooses low-priced, firm 2 best response is upscale
- How to find equilbirum?
"""

# ╔═╡ 6403deb0-a750-4ea0-b01d-349d611080a4
md"""
## Iterated Deletion of Dominated Strategies

- An algorithm that can help find the solution to this game is called *iterated deletion of dominated strategies*
- The algorithm proceeds as follows:
  - Set iteration $n = 0$
  - Let $S_i^n$ be set of remaining actions for player $i$ on iteration $n$. Start $S_i^0 = S_i$
  - On iteration $n$, for each player $i$ remove from $S_i^n$ any strategies that are dominated by other strategies in $S_i^n$ (taking into account $S_{-i}^n$). Call surviving strategies $S_i^{n+1}$
  - Repeat for all players $i$
  - Repeat until one of two conditions is met:

1. Each player has only one remaining strategy: $|S_i^{n+1}| = 1 \forall i$ -- this is NE
2. One or more players has an empty strategy set
"""

# ╔═╡ 26bc68c0-9222-4f8a-9650-f5ff99195447
md"""
## Application to Marketing Game

- Applying this algorithm we start with $S_1^0 = \{1, 2\} \; S_2^0 = \{1, 2\}$
- We see form firm 1 it is optimal to play strategy `1` for any choice of firm 2, which causes us to delete `2`. Now we have $S_1^1 = \{1 \} \; S_2^1 = \{1, 2\}$
- Now firm 2 takes into account that 1 will play `1` -- only best response is to play `2` and we get $S_1^2 = \{1 \} \; S_2^2 = \{2\}$
- We are done!
- The unique Nash Equilibrium is for firm 1 to take the low-price segment and firm 2 to take the upscale segment
"""

# ╔═╡ 5661a32f-6a29-444a-a0a1-09c586aeb30f
md"""
## Exercise

- Construct the Marketing Game using GameTheory.jl
- Verify that the only pure strategy nash equilibrium is [1, 2]
- HINT: don't forget to write player 2's payoffs from player 2's perspective!
"""

# ╔═╡ f36aef20-2901-4327-a99f-74e7547a0dc5
begin
	p1_market = Player([0.0 0; 0 0])
	p2_market = Player([0.0 0; 0 0])
	g_market = NormalFormGame([p1_market, p2_market])
end

# ╔═╡ 524454d8-a432-419f-ac1d-3854488143dd
md"""
# Matching Pennies

- Consider the payoff matrices for another famous game called Matching Pennies 
"""

# ╔═╡ 491161df-057d-44a9-87fb-2fd00b890c59
begin
	pennies_p1 = [-1 1; 1 -1]
	pennies_p2 = [1 -1; -1 1]
	
	pennies_p1, pennies_p2
end

# ╔═╡ 9b3a2bad-fc37-4d30-bade-60f5ae3a4ca8
md"""
- Question: how many players are there?
- How many strategies does player 1 have? Player 2?
"""

# ╔═╡ 43230dbf-99dc-4e42-a67d-6f0a29c811ad
md"""
## More Questions

- Does player 1 have a dominating strategy?
- How about player 2?
- What is player 1's best response when 2 chooses `T`? What about when 2 chooses `H`?
"""

# ╔═╡ a5527042-a497-4ae1-a30d-731b49e0c1f5
md"""
## Pure Strategies

- Choosing a strategy outright is called playing a **pure strategy**
- Neither player will always choose `H` or `T` no matter what the other player does
- We can say that there is no Nash Equilibrium in pure strategies 
- However, for all games we will consider (and most games in general) there is always a Nash equilibrium...
"""

# ╔═╡ a2665085-5129-4df6-92dc-0314e141cb65
md"""
## Mixed Strategies

- Sometimes players will not be able to play pure strategies in eqiulibrium
- In these cases they will need to *randomize* their behavior
- A **mixed strategy** is a probability distribution over strategies
- For example, in the matching pennies game, a mixed strategy is to play `H` with probabilty 0.5 and `T` with probability 0.5
- It turns out that both players playing this mixed strategy is the unique Nash Equilibrium of the matching pennies game
"""

# ╔═╡ 14f1c355-13ad-406c-a99e-fe8e47f5dc9c
md"""
## Mixed Strategies with GameTheory.jl

- GameTheory.jl can compute mixed strategy nash equilibria for us
- To do that we'll use the `support_enumeration` method (support enumeration is the name of an algorithm for computing **all** NE of a game, in pure or mixed strategies)
"""

# ╔═╡ ca795238-7d27-4253-8a8e-12d23a1bb243
md"""
## Bimatrix

- Before we have GameTheory compute our mixed strategy NE, we'll show one other way to create a `NormalFormGame` -- with a payoff **bimatrix**
- For an $N$ player game with $N_i$ strategies for each player, a bimatrix is an $N_1 \times N_2 \times \cdots \times N_N \times N$ array of payoffs
- For our game, we need a 2x2x2 array
  - last 2 represents 2 players
  - first two 2's represent 2 actions per player
"""

# ╔═╡ 0dadfdfa-d0fb-49ae-8750-10583ed40498
begin
	pennies_bimatrix = zeros(2, 2, 2)
	pennies_bimatrix[1, 1, :] = [-1, 1]
	pennies_bimatrix[1, 2, :]  = [1, -1]
	pennies_bimatrix[2, 1, :] = [1, -1]
	pennies_bimatrix[2, 2, :] = [-1, 1]
	pennies_g = NormalFormGame(pennies_bimatrix)
end

# ╔═╡ b428e1eb-875b-4cf9-90de-a1cdefbd12f4
md"""
- Notice how when using a bimatrix we can directly read the cells of the normal form game
  - The (H,H) cell is in position [1,1] and has payoffs [-1, 1]
  - The (T, H) cell is in position [2, 1] and has payoffs [1, -1]
  - etc.
- This can make it easier to specify payoffs because we don't have to worry about "player N payoffs from player N's perspective"
"""

# ╔═╡ bb17a2e2-c2a6-4c1b-b32d-70e9e132fd38
support_enumeration(pennies_g)

# ╔═╡ 973fd4d6-60d1-4e8e-af9b-394c010058ed
md"""
## Exercise

- Try `support_enumeration` with the other two games we've worked with
  - What does it give you with the prisoner's dilemma?
  - What does it give you with the marketing game?
"""

# ╔═╡ 2177d863-d400-4093-a556-336c5300b1eb
# TODO: your code AND explanation here

# ╔═╡ dfd01a7d-f00e-4692-8f05-aa0094843236
md"""
## Dependencies
"""

# ╔═╡ 4d94f431-b9e6-4c34-bbd3-50ecea752aab
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
				" is not quite right"
			])))
			else
				correct()
			end
		end
	end
	nothing
end

# ╔═╡ 1a8dbea1-3c4b-4d61-9333-ef04b4ca4904
default_checks("p2_market[1, 2]", p2_market.payoff_array[1, 2], 0.6)

# ╔═╡ d88f8c6c-1fdc-40a7-9971-42bb67f766a9
default_checks("market game NE", pure_nash(g_market), [(1, 2)])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
GameTheory = "64a4ffa8-f47c-4a47-8dad-aee7aadc3b51"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "485ee0867925449198280d4af84bdb46a2a404d0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.0.1"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "f87e559f87a45bece9c9ed97458d3afe98b1ebb9"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.1.0"

[[ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "b8d49c34c3da35f220e7295659cd0bab8e739fed"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.1.33"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "61adeb0823084487000600ef8b1c00cc2474cd47"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.2.0"

[[BinaryProvider]]
deps = ["Libdl", "Logging", "SHA"]
git-tree-sha1 = "ecdec412a9abc8db54c0efc5548c64dfce072058"
uuid = "b99e7846-7c00-51b0-8f62-c81ae34c0232"
version = "0.5.10"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "f2aff60a12e4fcb8575fe3044c618b058eddbd93"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.5.0"

[[Clp]]
deps = ["BinaryProvider", "CEnum", "Clp_jll", "Libdl", "MathOptInterface", "SparseArrays"]
git-tree-sha1 = "3df260c4a5764858f312ec2a17f5925624099f3a"
uuid = "e2554f3b-3117-50c0-817c-e040a3ddf72d"
version = "0.8.4"

[[Clp_jll]]
deps = ["Artifacts", "CoinUtils_jll", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "METIS_jll", "MUMPS_seq_jll", "OpenBLAS32_jll", "Osi_jll", "Pkg"]
git-tree-sha1 = "5e4f9a825408dc6356e6bf1015e75d2b16250ec8"
uuid = "06985876-5285-5a41-9fcb-8948a742cc53"
version = "100.1700.600+0"

[[CodecBzip2]]
deps = ["Bzip2_jll", "Libdl", "TranscodingStreams"]
git-tree-sha1 = "2e62a725210ce3c3c2e1a3080190e7ca491f18d7"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.7.2"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[CoinUtils_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "9b4a8b1087376c56189d02c3c1a48a0bba098ec2"
uuid = "be027038-0da8-5614-b30d-e42594cb92df"
version = "2.11.4+2"

[[Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "4866e381721b30fac8dda4c8cb1d9db45c8d2994"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.37.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[DSP]]
deps = ["FFTW", "IterTools", "LinearAlgebra", "Polynomials", "Random", "Reexport", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "2a63cb5fc0e8c1f0f139475ef94228c7441dc7d0"
uuid = "717857b8-e6f2-59f4-9121-6e50c889abd2"
version = "0.6.10"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

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

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "7220bc21c33e990c14f4a9a319b1d242ebc5b269"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.3.1"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns"]
git-tree-sha1 = "3676697fd903ba314aaaa0ec8d6813b354edb875"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.23.11"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "a32185f5428d3986f47c2ab78b1f216d5e6cc96f"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.5"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[ExprTools]]
git-tree-sha1 = "b7e3d17636b348f005f11040025ae8c6f645fe92"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.6"

[[FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "463cb335fa22c4ebacfd1faba5fde14edb80d96c"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.5"

[[FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "502b3de6039d5b78c76118423858d981349f3823"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.9.7"

[[FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "8b3c09b56acaf3c0e581c66638b85c8650ee9dca"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.8.1"

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "NaNMath", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "b5e930ac60b613ef3406da6d4f42c35d8dc51419"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.19"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GMP_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "781609d7-10c4-51f6-84f2-b8444358ff6d"

[[GameTheory]]
deps = ["Clp", "Combinatorics", "LRSLib", "LightGraphs", "LinearAlgebra", "MathOptInterface", "Parameters", "Polyhedra", "QuantEcon", "Random"]
git-tree-sha1 = "c9f505c3cc03f6bd94f45d940a3e559629dfd877"
repo-rev = "master"
repo-url = "https://github.com/QuantEcon/GameTheory.jl"
uuid = "64a4ffa8-f47c-4a47-8dad-aee7aadc3b51"
version = "0.1.0"

[[GenericLinearAlgebra]]
deps = ["LinearAlgebra", "Printf", "Random"]
git-tree-sha1 = "eddbb6ee8fe2c3244a2c973874a3179c3c4d3ac5"
uuid = "14197337-ba66-59df-a3e3-ca00e7dcff7a"
version = "0.2.6"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "15ff9a14b9e1218958d3530cc288cf31465d9ae2"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.3.13"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "60ed5f1643927479f845b0135bb369b031b541fa"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.14"

[[IfElse]]
git-tree-sha1 = "28e837ff3e7a6c3cdb252ce49fb412c8eb3caeef"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.0"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[Intervals]]
deps = ["Dates", "Printf", "RecipesBase", "Serialization", "TimeZones"]
git-tree-sha1 = "323a38ed1952d30586d0fe03412cde9399d3618b"
uuid = "d8418881-c3e1-53bb-8760-2df7ec849ed5"
version = "1.5.0"

[[IrrationalConstants]]
git-tree-sha1 = "f76424439413893a832026ca355fe273e93bce94"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.0"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

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

[[JSONSchema]]
deps = ["HTTP", "JSON", "URIs"]
git-tree-sha1 = "2f49f7f86762a0fbbeef84912265a1ae61c4ef80"
uuid = "7d188eb4-7ad8-530c-ae41-71a32a6d4692"
version = "0.3.4"

[[JuMP]]
deps = ["Calculus", "DataStructures", "ForwardDiff", "JSON", "LinearAlgebra", "MathOptInterface", "MutableArithmetics", "NaNMath", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "57c17a221a55f81890aabf00f478886859e25eaf"
uuid = "4076af6c-e467-56ae-b986-b466b2749572"
version = "0.21.5"

[[LRSLib]]
deps = ["Libdl", "LinearAlgebra", "Markdown", "Polyhedra", "lrslib_jll"]
git-tree-sha1 = "c629c4f1c9471198819999f0c6f337146b21d7a7"
uuid = "262c1cb6-76e2-5873-868b-19ece3183cc5"
version = "0.7.2"

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "f27132e551e959b3667d8c93eae90973225032dd"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.1.1"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "34dc30f868e368f8a17b728a1238f3fcda43931a"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.3"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[METIS_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "2dc1a9fc87e57e32b1fc186db78811157b30c118"
uuid = "d00139f3-1899-568f-a2f0-47f597d42d70"
version = "5.1.0+5"

[[MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "5455aef09b40e5020e1520f551fa3135040d4ed0"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2021.1.1+2"

[[MUMPS_seq_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "METIS_jll", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "a1d469a2a0acbfe219ef9bdfedae97daacac5a0e"
uuid = "d7ed1dd3-d0ae-5e8e-bfb4-87a502085b8d"
version = "5.4.0+0"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MathOptInterface]]
deps = ["BenchmarkTools", "CodecBzip2", "CodecZlib", "JSON", "JSONSchema", "LinearAlgebra", "MutableArithmetics", "OrderedCollections", "SparseArrays", "Test", "Unicode"]
git-tree-sha1 = "575644e3c05b258250bb599e57cf73bbf1062901"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "0.9.22"

[[MathProgBase]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9abbe463a1e9fc507f12a69e7f29346c2cdc472c"
uuid = "fdba3010-5040-5b88-9595-932c9decdf73"
version = "0.7.8"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Mocking]]
deps = ["ExprTools"]
git-tree-sha1 = "748f6e1e4de814b101911e64cc12d83a6af66782"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.2"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "3927848ccebcc165952dc0d9ac9aa274a87bfe01"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.2.20"

[[NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "144bab5b1443545bc4e791536c9f1eacb4eed06a"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.1"

[[NLopt]]
deps = ["MathOptInterface", "MathProgBase", "NLopt_jll"]
git-tree-sha1 = "d80cb3327d1aeef0f59eacf225e000f86e4eee0a"
uuid = "76087f3c-5699-56af-9a33-bf431cd00edd"
version = "0.6.3"

[[NLopt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "2b597c46900f5f811bec31f0dcc88b45744a2a09"
uuid = "079eb43e-fd8e-5478-9966-2cf3e3edb778"
version = "2.7.0+0"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "c0e9e582987d36d5a61e650e6e543b9e44d9914b"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.7"

[[OpenBLAS32_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ba4a8f683303c9082e84afba96f25af3c7fb2436"
uuid = "656ef2d0-ae68-5445-9ca0-591084a874a2"
version = "0.3.12+1"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Optim]]
deps = ["Compat", "FillArrays", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "7863df65dbb2a0fa8f85fcaf0a41167640d2ebed"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.4.1"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[Osi_jll]]
deps = ["Artifacts", "CoinUtils_jll", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "6a9967c4394858f38b7fc49787b983ba3847e73d"
uuid = "7da25872-d9ce-5375-a4d3-7a845f58efdd"
version = "0.108.6+2"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse", "Test"]
git-tree-sha1 = "95a4038d1011dfdbde7cecd2ad0ac411e53ab1bc"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.10.1"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

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

[[Polyhedra]]
deps = ["GenericLinearAlgebra", "GeometryBasics", "JuMP", "LinearAlgebra", "MutableArithmetics", "RecipesBase", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "44a43bb5290049cf15f840b6ec52c8c11a2568cf"
uuid = "67491407-f73d-577b-9b50-8179a7c68029"
version = "0.6.16"

[[Polynomials]]
deps = ["Intervals", "LinearAlgebra", "OffsetArrays", "RecipesBase"]
git-tree-sha1 = "0b15f3597b01eb76764dd03c3c23d6679a3c32c8"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "1.2.1"

[[PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Primes]]
git-tree-sha1 = "afccf037da52fa596223e5a0e331ff752e0e845c"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[QuantEcon]]
deps = ["DSP", "DataStructures", "Distributions", "FFTW", "LightGraphs", "LinearAlgebra", "Markdown", "NLopt", "Optim", "Pkg", "Primes", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "Test"]
git-tree-sha1 = "4e2dc3044303aa2cbf6e321cb9af3982f6774e6a"
uuid = "fcd29c91-0bd7-5a09-975d-7ac3f643a60c"
version = "0.16.2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

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

[[SpecialFunctions]]
deps = ["OpenSpecFun_jll"]
git-tree-sha1 = "d8d8b8a9f4119829410ecd706da4cc8594a1e020"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "0.10.3"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "a8f30abc7c64a39d389680b74e749cf33f872a70"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.3.3"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8cbbc098554648c84f79a463c9ff0fd277144b6c"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.10"

[[StatsFuns]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "46d7ccc7104860c38b11966dd1f72ff042f382e4"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.10"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

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
git-tree-sha1 = "1162ce4a6c4b7e31e0e6b14486a6986951c73be9"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.2"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TimeZones]]
deps = ["Dates", "Future", "LazyArtifacts", "Mocking", "Pkg", "Printf", "RecipesBase", "Serialization", "Unicode"]
git-tree-sha1 = "6c9040665b2da00d30143261aea22c7427aada1c"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.5.7"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

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

[[lrslib_jll]]
deps = ["Artifacts", "GMP_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "de24a5e08e56a124508077e4bbaacd76a5bffe3e"
uuid = "3873f7d0-7b7c-52c3-bdf4-8ab39b8f337a"
version = "0.3.1+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─a957fb7d-6353-4b34-8697-b9372e476b8a
# ╟─e02a30fc-158d-11ec-2b91-ff616d46d9bf
# ╟─a6337952-501f-40d4-8d7d-91df1161275f
# ╟─26c601b4-07f0-44b1-bffe-00f7de1689ea
# ╟─a506a11a-b75d-421a-81a0-d7ce3dd9c907
# ╟─d5095d4a-25b6-44f5-97d6-fa76ac870680
# ╟─972dcf68-6b37-45a7-9413-61a3a089c213
# ╟─bfb77fb1-2e33-4baf-aad5-1ef8282bddd2
# ╠═471c57b9-a8d9-4cf5-b401-58a29587d0f9
# ╟─bab2dbea-d538-43c6-bbee-c7c54997ad49
# ╟─c74e47c5-1afb-4d3a-9344-48db12cad6ce
# ╠═f47f7d66-19c9-469f-a6c9-4abd91c7c555
# ╟─e5b129b2-c1d1-43ab-b258-12c070573db5
# ╟─68a2be6e-255d-47b1-aa58-fcbf4b7fb6e2
# ╠═4fa2dfc2-99e6-43a6-aad9-76ae86ea3f46
# ╟─c5b7c676-68e6-4c40-ae73-a62a99465b51
# ╟─487bd475-a276-41db-8ca8-aa4ca01e6b66
# ╟─b88dd9fd-1105-43b3-b00a-ebc7ab1d17da
# ╠═6c44053d-8f87-4dd6-86db-f3de18cf3578
# ╠═12f6aa12-e924-4435-903d-5d6c25b63196
# ╟─12cfea9d-7eb3-4dbb-9992-71d2ab99268f
# ╠═1717c87f-c70b-4f77-afd2-9fb431487115
# ╟─87b7614f-5009-416c-9574-01853cd4dca4
# ╠═6e6a34d9-b8cf-4cff-8421-65b4c5c6feff
# ╟─b56dc651-f6c2-452a-8086-a8a075a9057c
# ╠═ba6c46c1-ef35-4088-896a-1f4fad525823
# ╠═4763c377-d83e-4a94-9ce1-34d5bd20e4b6
# ╟─f3ae8777-5019-4623-b76e-b5330ed6c90f
# ╟─dc95963f-743f-4c80-b1a4-333600025ecf
# ╟─4672d3bf-be6b-4aaf-81d7-cb9c63ab21e7
# ╟─6403deb0-a750-4ea0-b01d-349d611080a4
# ╟─26bc68c0-9222-4f8a-9650-f5ff99195447
# ╟─5661a32f-6a29-444a-a0a1-09c586aeb30f
# ╠═f36aef20-2901-4327-a99f-74e7547a0dc5
# ╟─1a8dbea1-3c4b-4d61-9333-ef04b4ca4904
# ╟─d88f8c6c-1fdc-40a7-9971-42bb67f766a9
# ╟─524454d8-a432-419f-ac1d-3854488143dd
# ╠═491161df-057d-44a9-87fb-2fd00b890c59
# ╟─9b3a2bad-fc37-4d30-bade-60f5ae3a4ca8
# ╟─43230dbf-99dc-4e42-a67d-6f0a29c811ad
# ╟─a5527042-a497-4ae1-a30d-731b49e0c1f5
# ╟─a2665085-5129-4df6-92dc-0314e141cb65
# ╟─14f1c355-13ad-406c-a99e-fe8e47f5dc9c
# ╟─ca795238-7d27-4253-8a8e-12d23a1bb243
# ╠═0dadfdfa-d0fb-49ae-8750-10583ed40498
# ╟─b428e1eb-875b-4cf9-90de-a1cdefbd12f4
# ╠═bb17a2e2-c2a6-4c1b-b32d-70e9e132fd38
# ╟─973fd4d6-60d1-4e8e-af9b-394c010058ed
# ╠═2177d863-d400-4093-a556-336c5300b1eb
# ╟─dfd01a7d-f00e-4692-8f05-aa0094843236
# ╠═0df288f6-f666-4dac-8478-fe87405cb7d7
# ╟─4d94f431-b9e6-4c34-bbd3-50ecea752aab
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
