### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 0df288f6-f666-4dac-8478-fe87405cb7d7
using PlutoUI

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
Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week04/prisoners_dilemma.png")

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
- Fow now we will utilize the implementation of these algorithms in the Games.jl package
- Let's load it up and create a version of our prisoner's dilemma game:
"""

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
Resource("https://github.com/sglyon/ucf-cap-6318/raw/Fall21/notebooks/week04/marketing_game.png")

# ╔═╡ 4672d3bf-be6b-4aaf-81d7-cb9c63ab21e7
md"""
### Strategies

- Firm 1 has a dominant strategy: low-priced. They will always play this strategy
- Firm 2 is less clear:
  - If firm 1 were to choose the upscale market, they would be better off choosing low-priced
  - however, when firm 1 chooses low-priced, firm 2 best response is upscale
- How to find equilbirum?
"""

# ╔═╡ 6403deb0-a750-4ea0-b01d-349d611080a4
md"""
### Iterated Deletion of Dominated Strategies

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
### Application to Marketing Game

- Applying this algorithm we start with $S_1^0 = \{1, 2\} \; S_2^0 = \{1, 2\}$
- We see form firm 1 it is optimal to play strategy `1` for any choice of firm 2, which causes us to delete `2`. Now we have $S_1^1 = \{1 \} \; S_2^1 = \{1, 2\}$
- Now firm 2 takes into account that 1 will play `1` -- only best response is to play `2` and we get $S_1^2 = \{1 \} \; S_2^2 = \{2\}$
- We are done!
- The unique Nash Equilibrium is for firm 1 to take the low-price segment and firm 2 to take the upscale segment
"""

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
- We'll come back to that in a future lesson...
"""

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
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

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
# ╟─f3ae8777-5019-4623-b76e-b5330ed6c90f
# ╟─dc95963f-743f-4c80-b1a4-333600025ecf
# ╟─4672d3bf-be6b-4aaf-81d7-cb9c63ab21e7
# ╟─6403deb0-a750-4ea0-b01d-349d611080a4
# ╟─26bc68c0-9222-4f8a-9650-f5ff99195447
# ╟─524454d8-a432-419f-ac1d-3854488143dd
# ╠═491161df-057d-44a9-87fb-2fd00b890c59
# ╟─9b3a2bad-fc37-4d30-bade-60f5ae3a4ca8
# ╟─43230dbf-99dc-4e42-a67d-6f0a29c811ad
# ╟─a5527042-a497-4ae1-a30d-731b49e0c1f5
# ╟─a2665085-5129-4df6-92dc-0314e141cb65
# ╠═dfd01a7d-f00e-4692-8f05-aa0094843236
# ╠═0df288f6-f666-4dac-8478-fe87405cb7d7
# ╟─4d94f431-b9e6-4c34-bbd3-50ecea752aab
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
