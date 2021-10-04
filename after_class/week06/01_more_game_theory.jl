### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 045439b3-dfba-4a9e-afab-bdc061e79ec9
using GameTheory

# ╔═╡ 4e9b6396-772f-42fd-9bdf-9e9714de4bd2
using PlutoUI

# ╔═╡ 844d6e9a-0ff1-4419-a792-ed1ab9b533b5
html"""<button onClick="present()">present</button>"""

# ╔═╡ b29a162e-2065-11ec-0189-f38d4463f095
md"""
# More Game Theory

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon

**Prerequisites**

- Intro to Game Theory

**Outcomes**

- Know how to solve for a Nash Equilibrium in mixed strategies
- Understand the concepts of a repeated game and be able to reason about equilibria in such games
- Understand how normal form and extensive form games are related

**References**

- [Easley and Kleinberg](https://www.cs.cornell.edu/home/kleinber/networks-book/) chapter 6 
"""

# ╔═╡ dbba684a-0add-4bad-b524-a6f793948722
md"""
# Review: Matching Pennies

- Recall the matching pennies game we studied last week
"""

# ╔═╡ a2663805-e7a2-4e84-bd8e-7b85c2841c75
PlutoUI.Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week06/matching_pennies.png")

# ╔═╡ b3e51ac7-bd10-4de0-83b5-acdb6899bcf2
md"""
## Properties

- Matching pennies is an example of a wider class of games
- Some of its properties are that it is
    - Zero-sum: sum of payoffs from all players is always 0. One player loses, the other wins
    - No Nash Equilibrium in Pure Strategies
    - b/c no NE in PS, beneficial to introduce randomness into actions
- Zero sum games are very common
    - Example: D-Day in WW2. US could have landed in France on Normandy or Calais. Germany could have put bulk of defenses at one of these places. Outcome largely depended on US ability to [trick Germany](https://www.history.com/news/fooling-hitler-the-elaborate-ruse-behind-d-day#:~:text=The%20most%20logical%20place%20in,Britain%20across%20the%20English%20Channel.) into putting defenses at Calais
"""

# ╔═╡ 5320cdd5-b999-44b3-b9dc-5af4dd19ded3
md"""
## Mixed Strategies

- A **pure strategy** is a selection of a single action from set of possible strategies $\sigma_i  \in S_i$
- A **mixed strategy** is a probability distribution over the set of possible strategies $\sigma_i \in \triangle(S_i) \subseteq [0,1]^{M_i}$
    - Pure strategy is a special case of a *degenerate* distribution

"""

# ╔═╡ 1567f461-6882-45fc-932a-f4bd319248d6
md"""
## Expected Payoffs

- When dealing with pure strategies we could determine payoffs by reading off an appropriate value from the payoff matrix
- With mixed strategies we have to deal with *expected payoffs*
"""

# ╔═╡ 82c6e9c1-f1d5-4d5c-a314-372ee9d0a8a5
md"""
## P1  Payoffs in Matching Pennies

- Suppose you are player 1 in matching pennies
- Suppose further that P2 is following a strategy to play H with probability $q$ and T with probability $(1-q)$
- The expected payoffs from each of P1's pure strategies are:
  - Plays H: $p_1(H | q)$: $-1 \cdot q + 1 \cdot (1-q) = 1 - 2q$ 
  - Plays T: $p_1(T | q)$: $1 \cdot 1 - 1 \cdot (1-q) = 2q - 1$ 
"""

# ╔═╡ ce08f6cd-c9d4-4339-89b7-859b102a12ef
md"""
## Indifference

- Argument: it cannot be optimal for P2 to follow the (q, 1-q) strategy unless it makes P1 *indifferent* about playing H or T
  - Why? Suppose $p_1(H | q) > p_1(T | q)$. Then P1 will always pick H, which would in turn make P2 want to change behavior to always play $H$
  - Simlar logic applies if $p_1(T | q) > p_1(H | q)$
- So, it must be that $p_1(T | q) = p_1(H | q)$
- This means $1 - 2q = 2q - 1 \Longrightarrow q = \frac{1}{2}$
"""

# ╔═╡ d6654ebf-7ae3-4361-b79a-8c0bd0890989
md"""
## Comment

- Notice that we used P1's expected payoffs to determine the mixed strategy for P2
- There are two major themes here
  1. To derive optimal behavior for one player, you must consider impact of that player's decisions on the rewards to other players
  2. P2's ability to **commit** to following the (q, 1-q) both allowed P1 to reason about payoffs AND made P1 indifferent about his/her own choice. Commitment is a major theme in advanced game theory, and one we'll revisit later in the course when we talk about blockchains and smart contracts
"""

# ╔═╡ fab17070-ec16-43df-a561-10b5e187a77b
md"""
## P1's action

- We now know (based on P1s expected payoffs) that P2 will do 50/50 split between H and T
- Now consider game from P2's perspective, taking as given that P1 will be playing H with probability $p$ and T with probability $1-p$
- **Exercise**: use P2's expected payoffs under the (p, 1-p) strategy for P1 to determine the value of $p$. What is that value? does it surprise you? Why or Why not?
"""

# ╔═╡ 638f2b0b-47dd-4dbe-85ac-245d38a637d3
md"""
# Asymmetry: NFL play choice

- Matching pennies is a particularly simple example of a zero-sum game with no equilibira in pure strategies
- The symmetry in the payoff matrix led to a "boring" outcome
- Let's consider another exapmle that doesn't have this symmetry
- Consider an american football game
- Each play
  - the offense can choose to call a run or pass play
  - The defense can choose to focus play call on defending run or defending pass
- The payoff for offensive team is how many yards they gain
- Payoff for defense is always negative and equal to "-" yards gained by offense
- Payoffs based on play calls are given below
"""

# ╔═╡ 3b2e176b-1026-4638-9378-58f4eee36e4a
# E[p_1(pass) | q)] = q * 0 + (1-q) * 10
# E[p_1(run) | q)] = q * 5 + (1-q) * 0

# set equal: (1-q)*10 = 5q ==> 10 = 15q ==> q = 10/15
# outcome: defense defends pass with prob 2/3 and run with prob 1/3

# suppose offense passes with prob p

# E[p_2(defend pass) | p] = p * 0 + (1-p) *(-5)
# E[p_2(defend run) | p] = p * (-10) + (1-p) *(-0)
# set equal: -10p = -5 + 5p ==> -15p = -5 ==> p = 1/3
# outcome: offense passes w/prob (1/3) and runs w prob (2/3)

# ╔═╡ 4aade364-1cab-40d1-ac1e-ab941e6b0abc
PlutoUI.Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week06/run_pass_game.png")

# ╔═╡ ccb2971c-2ac4-44e9-8756-a17df7db305a
md"""
## Exercise

- Given what we've learned about mixed strategies, determine the equilibrium probability that the defense chooses to defend the pass (call this $q$) and the equilibrium probability that the offense chooses a pass play (call this $p$)
"""

# ╔═╡ e1f08cac-c879-431d-bd63-70ef4e3c2c91
md"""
## Comments

- In the run/pass example we see that the higher payoff option for the offense is to pass, but that they choose it less than the lower payoff run option
- Why?
- The main idea is that the *threat* of a successful pass play causes the defense to choose to defend the pass more than 50% of the time. 
- The offense takes that strategy as given, and realizes they are better off running more than 1/2 the time
- Any deviation by the offense to pass more often than the $p$ you computed would cause the defense to always defend the pass
- This would result in a strictly worse expected payoff for the offense
"""

# ╔═╡ ae2a5e9e-0322-4336-9af7-544c6b6a281a
begin
	payoffs = zeros(2, 2, 2, 3)
	payoffs[1, 1, 1, :] .= (-1, -1, -1)
	payoffs[1, 1, 2, :] .= (10, 10, 0)
	payoffs[1, 2, 1, :] .= (10, 0, 10)
	payoffs[1, 2, 2, :] .= (10, 0, 0)
	payoffs[2, 1, 1, :] .= (0, 10, 10)
	payoffs[2, 1, 2, :] .= (0, 10, 0)
	payoffs[2, 2, 1, :] .= (0, 0, 10)
	payoffs[2, 2, 2, :] .= (0, 0, 0)
	g = NormalFormGame(payoffs)
end

# ╔═╡ 1bb09dd0-f3c1-4b8a-a69a-8fa9d61b8ddd
pure_nash(g)

# ╔═╡ 288a1ba6-83df-4dda-94e0-349aa9129338
md"""
# Dynamic Games

- So far the games we've studied have all been static
- By this we mean each participant makes exactly one choice at exactly the same time
- Game theory is far more rich than this!
- We now introduce the concept of a dynamic game
- Our treatement will focus on non-simultaneous decisions
- Study of repeated games is beyond our scope for now
"""

# ╔═╡ c758ad45-74d8-485e-927e-e7e313eac9f2
md"""
## Example: Firm Advertising

- Consider a game with two firms (1 and 2) and two new markets (A and B)
- Market A has a total of 12 profit to be gained and market B has total of 6 profit
- Both firms have to choose which market to advertise to
- Firm 1 gets to choose first
- Because of the earlier choice, firm 1 has "first mover advantage"
- If firms choose same market, firm 1 gets 2/3 of potential profit and firm 2 gets 1/3
- If they advertise to separate markets, each firm gets all potential profit in their chosen market
"""

# ╔═╡ 2355aee2-0079-4aad-a8d3-cd6df5e7cfa6
md"""
## Extensive form

- We can represent the game we just described as a tree (or directed graph, if you prefer)
- Each node represents a decision point and each branch represents a particular action being chosen
- The game tree for the advertising game is given below
"""

# ╔═╡ 1db4fd54-d43e-40a3-8c6c-13e09760017c
PlutoUI.Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week06/advertising_game_extensive.png")

# ╔═╡ eb87d3a5-d93d-4936-9282-aa2e02ff53d3
md"""
## Equilibrium via Game Tree

- We can use the extensive form representation of a dynamic game to determine the equilibrium outcome
- The approach for doing this is to start at the bottom of the tree and work our way up
- In this example we first start with Player 2 and determine what decision should be made at each decision node:
  - If on branch from P1 choosing A, P2 shoudl choose B because $p_2(B|A) > p_2(A|A)$ (6 > 4)
  - If on branch from P1 choosing B, P2 shoudl choose A because $p_2(A|B) > p_2(B|B)$ (12 > 2)
- Now that we know what P2 will do at each node, we go up the tree to P1s decision
  - P1 knows P2 will choose the opposite of P1's choice
  - So P1 realizes that $p_1(A) > p1_(B) (12 > 6)$, so P1 chooses $A$
- The equilibrium of this game is (A, B)
"""

# ╔═╡ aaee9556-a6ba-40f6-bb3a-373f8f412dbd
md"""
## Example: Market Entry

- Let's consider a similar game
- Player 2 is now an incumbant (already existing firm) and player 1 is a startup deciding to enter the market or stay out
- If P1 chooses to stay out (S), the game ends and P2 is happy
- If P1 chooses to enter (E), P2 can choose to retaliate or cooperate
- Payoffs are given in game tree below
"""

# ╔═╡ 842c1764-9fd7-4e7d-901d-1db21a105cc4
PlutoUI.Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week06/firm_entry_game.png")

# ╔═╡ f0408a75-c3d6-4c82-bb38-d7038bca59cd
md"""
## Exercise

- Apply the logic outlined above when styding advertising game to determine the equilibrium outcome of the Market Entry Game
- What does Player 1 choose to do?
- Does player 2 have to make a choice? If so, what is it?
"""

# ╔═╡ 660eeea9-2fc9-4072-ab3b-2d44a935598b
md"""
## Comparison to Normal Form

- Consider the market entry game in normal form

"""

# ╔═╡ 9aa569f0-5752-4677-a96f-c3bfeaab77bc
PlutoUI.Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week06/normal_form_entry_game.png")

# ╔═╡ ace47342-408d-4b02-8c55-0785f539d6ae
md"""
- Notice that in this normal form game there are two NE in pure strategies:
  - (S, R): An equilibrium that didn't come up in the dynamic game, because P1 got to move first and chose to enter
  - (E, C): the equilibrim we've already seen
- Key idea: taking into account timing may change equilibrium outcomes
- If P2 had the ability to **commit** to retaliate, then perhaps P1 would choose to stay out
  - Again commitment is a key concept in Game theory
  - Book talks about "if P2 could commit to having a computer play its strategies"
  - This is not just a hypothetical *if* -- smart contracts make it possible and enforce it!
"""

# ╔═╡ 7fee91dd-a4a1-4dbb-9918-47dc8497233f
md"""
## Dependencies
"""

# ╔═╡ 7851580f-1ce1-449d-affa-cbee5286ad94
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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
GameTheory = "64a4ffa8-f47c-4a47-8dad-aee7aadc3b51"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
GameTheory = "~0.1.0"
PlutoUI = "~0.7.12"
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
git-tree-sha1 = "e8a30e8019a512e4b6c56ccebc065026624660e8"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.7.0"

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
git-tree-sha1 = "31d0151f5716b655421d9d75b7fa74cc4e744df2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.39.0"

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
git-tree-sha1 = "21d56ebc9a41a410c9d2906a9f89c9cb7569e048"
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
git-tree-sha1 = "24675428ca27678f003414a98c9e473e45fe6a21"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.15"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

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
git-tree-sha1 = "9d8c00ef7a8d110787ff6f170579846f776133a9"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.4"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["Base64", "Dates", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "f35ae11e070dbf123d5a6f54cbda45818d765ad2"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.12"

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
git-tree-sha1 = "d9bcf8d82077567abc2d972dd2db4b201a7d4263"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.11"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

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
# ╟─844d6e9a-0ff1-4419-a792-ed1ab9b533b5
# ╟─b29a162e-2065-11ec-0189-f38d4463f095
# ╟─dbba684a-0add-4bad-b524-a6f793948722
# ╟─a2663805-e7a2-4e84-bd8e-7b85c2841c75
# ╟─b3e51ac7-bd10-4de0-83b5-acdb6899bcf2
# ╟─5320cdd5-b999-44b3-b9dc-5af4dd19ded3
# ╟─1567f461-6882-45fc-932a-f4bd319248d6
# ╟─82c6e9c1-f1d5-4d5c-a314-372ee9d0a8a5
# ╟─ce08f6cd-c9d4-4339-89b7-859b102a12ef
# ╟─d6654ebf-7ae3-4361-b79a-8c0bd0890989
# ╟─fab17070-ec16-43df-a561-10b5e187a77b
# ╟─638f2b0b-47dd-4dbe-85ac-245d38a637d3
# ╠═3b2e176b-1026-4638-9378-58f4eee36e4a
# ╟─4aade364-1cab-40d1-ac1e-ab941e6b0abc
# ╟─ccb2971c-2ac4-44e9-8756-a17df7db305a
# ╟─e1f08cac-c879-431d-bd63-70ef4e3c2c91
# ╠═045439b3-dfba-4a9e-afab-bdc061e79ec9
# ╠═ae2a5e9e-0322-4336-9af7-544c6b6a281a
# ╠═1bb09dd0-f3c1-4b8a-a69a-8fa9d61b8ddd
# ╟─288a1ba6-83df-4dda-94e0-349aa9129338
# ╟─c758ad45-74d8-485e-927e-e7e313eac9f2
# ╟─2355aee2-0079-4aad-a8d3-cd6df5e7cfa6
# ╟─1db4fd54-d43e-40a3-8c6c-13e09760017c
# ╟─eb87d3a5-d93d-4936-9282-aa2e02ff53d3
# ╟─aaee9556-a6ba-40f6-bb3a-373f8f412dbd
# ╟─842c1764-9fd7-4e7d-901d-1db21a105cc4
# ╟─f0408a75-c3d6-4c82-bb38-d7038bca59cd
# ╟─660eeea9-2fc9-4072-ab3b-2d44a935598b
# ╟─9aa569f0-5752-4677-a96f-c3bfeaab77bc
# ╟─ace47342-408d-4b02-8c55-0785f539d6ae
# ╟─7fee91dd-a4a1-4dbb-9918-47dc8497233f
# ╠═4e9b6396-772f-42fd-9bdf-9e9714de4bd2
# ╟─7851580f-1ce1-449d-affa-cbee5286ad94
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
