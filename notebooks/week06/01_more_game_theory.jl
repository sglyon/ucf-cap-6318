### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

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
- So, it must be that $p_1(T | q) > p_1(H | q)$
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
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.12"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

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
git-tree-sha1 = "9d8c00ef7a8d110787ff6f170579846f776133a9"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.4"

[[PlutoUI]]
deps = ["Base64", "Dates", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "f35ae11e070dbf123d5a6f54cbda45818d765ad2"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.12"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╟─844d6e9a-0ff1-4419-a792-ed1ab9b533b5
# ╠═b29a162e-2065-11ec-0189-f38d4463f095
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
# ╟─4aade364-1cab-40d1-ac1e-ab941e6b0abc
# ╟─ccb2971c-2ac4-44e9-8756-a17df7db305a
# ╟─e1f08cac-c879-431d-bd63-70ef4e3c2c91
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
