### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ fc622634-5538-4b6d-a13e-6e8ec8faa1a5
using PlutoUI

# ╔═╡ 2e354099-fe79-416e-883f-e9578551da0c
html"""<button onClick="present()">present</button>"""

# ╔═╡ a56b33d6-46c6-422f-9af7-eabdbd871afe
md"""
# Auctions

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon

**Prerequisites**

- Game Theory

**Outcomes**

- Know the 4 main types of auctions
- Understand concept of individual valuation of an item or an outcome
- Understand why truth-telling in auctions is optimal
- 

**References**

- [Easley and Kleinberg](https://www.cs.cornell.edu/home/kleinber/networks-book/) chapter 9
"""

# ╔═╡ 1664ae08-42ee-4d6f-963a-a9748d60470f
md"""
# Intro

- An auction is a special type of economic market between a seller and many buyers
- The seller has an item or outcome that -- presumably -- the buyers want
- Rules are established for how buyers indicate their willingness to pay
"""

# ╔═╡ d3d78b0a-c79e-4228-b5cc-5a1271b34ca1
md"""
## Why/When auctions?

- When would auctions be applicable?
- In a typical buyer-seller scenario usually the value of the good for one party is known
  - The buyer knows costs of creating the good and posts a reasonable price
  - The seller knows how much they are willing to pay and will purchase if affordable
- An auction is to be used when the *valuation* of the good is either private information (I, a buyer, don't want seller to know how badly I want the good) or is unknown
"""

# ╔═╡ bdff1b48-6d6a-472b-80de-44455f89e1a8
md"""
# Types of Auctions

1. First price, ascending (*English*): what we see on TV. Auctioneer calls out higher and higher prices, bidders indicate willinness to pay, terminates when nobody outbids current highest bid
2. Descending-bid (*Dutch*): Price starts high and falls, bidders are quiet until somebody says they'll buy at current price, auction ends and bidder pays that price
3. First price, sealed-bid: everyone writes down their bid secretly and submits at the same time, highest bidder wins and pays price they wrote
4. Second price, sealed-bid (*Vickrey*): everyone writes down their bid secretly and submits at the same time, highest bidder wins and pays price of second highest bidder
"""

# ╔═╡ eb09c309-cd03-4a93-abf7-585c692d02dd
md"""
## Equivalence

- Because auctions are useful in settings with unknown valuations, we often think about how the rules of an auction lead to revealing information
- It turns out that of the 4 types of auctions we just described, only two information patterns emerge:
  1. Descending bid and first-price sealed auction: In this case nobody learns anything about buyers willingness to pay until we see the highest bidder's price and auction ends. We only ever learn the highest bidder's bid
  2. Ascending and second-price sealed: We see which buyers are willing to purchase at low prices, auction ends when one person has outbid the rest, if auction increments slowly this will be at the maximum price for second place bidder. In either case we learn second highest bidder's price, which is paid by the highest bidder (we don't get to see the highest bidder's valuation)
- For this reason, we'll study the two forms of sealed-bid auctions
"""

# ╔═╡ 9f452c90-7999-4f37-8e97-5016822d1791
md"""
# Second price, sealed bid auction

- Let's set up the second price, sealed-bid auction as a game
- Suppose there are $N$ bidders (each is a player)
- Bidder $i$ strategy is to bid an amount $b_i$, which is a function of that bidder's true valuation $v_i$
- Payoffs to player $i$ with valuation $v_i$ and bid $b_i$ are:
  - 0: if $b_i$ is not highest bid
  - equal to $v_i - b_k$: if $b_i$ is highest bid and second higest bid is $b_k$
- Ties go to bidder with lower "index" $i$ wins over $k$ if $b_i = b_k$ and $i < k$
"""

# ╔═╡ acd81dab-0e38-49d1-8e1b-f70fcabbc948
md"""
## Truth telling

- *Claim*: in a sealed-bid second price auction, it is a dominant strategy for each bidder to choose $b_i = v_i$
- To prove this we need to consider possible outcomes if $b_i <v_i$ or if $b_i > v_i$
- Call $b_i'$ the high bid and $b_i''$ the low bid and $b_k$ the second highest bid
  1. In case where $b_i'' < v_i$
      - Case $b_i$ and $b_i''$ lose: payoff 0
      - Case $b_i$ and $b_i''$ win: payoff $v_i - b_k$
      - Case $b_i$ wins, but $b_i''$ loses: new payoff 0, old payoff $v_i - b_k \ge 0$ so, bidding to low can't help, but can hurt
  2. In case where $b_i' > v_i$
      - Case $b_i$ and $b_i''$ lose: payoff 0
      - Case $b_i$ and $b_i''$ win: payoff $v_i - b_k$
      - Case $b_i$ loses, but $b_i'$ wins: old payoff 0, new payoff $v_i - b_k \le 0$. Again bidding high can't help, but can hurt
- So, in sealed-bid second price auction it is always optimal to bid true value
"""

# ╔═╡ 019e1665-52bc-4584-b104-ad0ce75e6a60
md"""
# First price, sealed bid auction

- Same notation players, valuations, and bids
- Payoffs are now:
    - 0 if $b_i$ not highest
    - equal to $v_i - b_i$ if $b_i$ is highest
- Note, bidding true value is not optimal -- you would always get $0$ payoff
- What is optimal then?
- Optimal behavior is to "shade" bid a bit lower than true value
  - How much lower depends on interaction between not bidding too close to true value (b/c that diminishes your payoffs) and not bidding too low (b/c you risk losing an otherwise profitable win).
- Actually solving for this tradeoff is complex!
"""

# ╔═╡ a571cf8a-2f51-4254-a84f-a5d011c3164f
md"""
## Considerations

- What factors might influence how much you shade your bid?
  - Number of other bidders: with many bidders, shading becomes more risky (more people that might outbid you) so you tend to bid higher
  - Distribution of bidder values: understanding how valuation of other bidders is distributed might allow you to shade more
"""

# ╔═╡ 0eab06e0-6552-46f0-98f2-0e45a0948520
md"""
## Outcomes

- For now, we will not discuss how to compute optimal bids in first-price auctions
- Instead we will talk about some outcomes:
  - The Revelation Principle: in order to derive optimal bids, we use a framework that considers small deviations to $v_i$ instead of $b_i$. We assert that the expected payoff for using a a strategy derived from a value $v_i$ is at least as high as the expected payoff for a strategy derived from any other value $v$
  - Revenue equivalence: the expected payoff to the seller is exactly the same for both first and second price auctions, when bidders follow equilibrium strategies
"""

# ╔═╡ 89d34a27-39f8-4118-b199-fd4efbf3e86a
md"""
# Twists

- There are some twists to the auction setup we've described
- One is the notion of an "all-pay auction"
  - In an all-pay auction only the highest bidder wins, but all bidders must pay their bid
  - Turns out, this style of auction also satisfies the revenue equivalence principle (under equilibrium bidding, expected seller revenue is same as in sealed first and sealed second price bid)
- Auction markets on blockchain
  - Implementing auctions via smart contracts has interesting implications
      - Transfer of ownership can be settled immediately and trustlessly
      - Participating in an auction is permisionless (anyone can be a seller or buyer)
      - Conditions for resales can be set (i.e. original seller gets x% of all subsequent sales)  -- now we have a repeated, dynamic game!
      - Onwership rights can be verified and open up 
  - This scratches the surface of some economic implications of a class of assets called NFTs or non-fungible tokens
"""

# ╔═╡ 1cf5fb22-8f40-4f96-89eb-2c4c99059493
md"""
## Dependencies
"""

# ╔═╡ 001dfef8-c2c3-4c67-96db-ad8e95f04652
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
# ╟─2e354099-fe79-416e-883f-e9578551da0c
# ╟─a56b33d6-46c6-422f-9af7-eabdbd871afe
# ╟─1664ae08-42ee-4d6f-963a-a9748d60470f
# ╟─d3d78b0a-c79e-4228-b5cc-5a1271b34ca1
# ╟─bdff1b48-6d6a-472b-80de-44455f89e1a8
# ╟─eb09c309-cd03-4a93-abf7-585c692d02dd
# ╟─9f452c90-7999-4f37-8e97-5016822d1791
# ╟─acd81dab-0e38-49d1-8e1b-f70fcabbc948
# ╟─019e1665-52bc-4584-b104-ad0ce75e6a60
# ╟─a571cf8a-2f51-4254-a84f-a5d011c3164f
# ╟─0eab06e0-6552-46f0-98f2-0e45a0948520
# ╟─89d34a27-39f8-4118-b199-fd4efbf3e86a
# ╟─1cf5fb22-8f40-4f96-89eb-2c4c99059493
# ╠═fc622634-5538-4b6d-a13e-6e8ec8faa1a5
# ╟─001dfef8-c2c3-4c67-96db-ad8e95f04652
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
