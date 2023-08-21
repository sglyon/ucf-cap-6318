### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 0ab6c9a2-0b24-45a4-b5cd-5212b9d0eb01
md"""
# Opinion Spread ABM

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon


**Prerequisites**

- Agent Based Models

**Outcomes**

- Practice defining environment, agents, and rules for ABM
- Understand how these components are coded up in Julia

**References**

- https://juliadynamics.github.io/Agents.jl/stable/examples/opinion_spread/
"""

# ╔═╡ 6e83bd24-194d-4ea9-9976-2bcfbc5a9990
md"""
# Opinion Spread Model

- We have 100 agents located on a 10x10 grid
- Each agent an opinion about $M$ subjects
- For each subject there are $K$ possible opinions that could be held
- Each time period, each agent will randomly meet with one neighbor. At this meeting...
  - The agent will learn all $M$ opinions of the neighbor and count how many of these match their own. Call the number of matches $J$
  - If $J$ < $M$, then with probability $J/M$ the agent will adopt one of the neighbor's differing opinions
  - Which subject is changed is chosen randomly
- The model has stabalized (finished) when no agents changes opinions from one period to the next
"""

# ╔═╡ 5e9c0276-2b69-11ec-2c96-cdc782a9c3a2
md"""
## Model Components

- Environment: 10x10 grid
- 100 Agents, each with properties:
  - `id`: integer to uniquely identify agent
  - `pos`: (x,y) coordinate for location
  - `opinions`: vector of length $M$ holding one of $K$ possible opinions (e.g. if $M$ is 3 and $K$ is 4, then `[1, 4, 2]` would be a valid entry for `opinions`)
  - `stabalized`: boolean indicating if opinions at time $t$ are same as opinions at time $t-1$
  - `prev_opinions`: same shape as opinions, used to be able to compute `stabalized`
- Rules:
  - On each step agents randomly choose one neighbor to talk with. Agent counts number of matching opinions with this neighbor (call it $J$). If $J$ < $M$, then with probability $J$/$M$ agent will adopt a single differing opinion from the neighbor
"""

# ╔═╡ fed3d9f2-7ddc-4e90-8c09-87d5141adf08
md"""
## Code

- See accompanying file [on GitHub](https://github.com/sglyon/ucf-cap-6318/blob/df6c6340875b139da4e55c86cc79d1cb94b92e2b/notebooks/week08/opinion_spread_model.jl)
"""

# ╔═╡ Cell order:
# ╟─0ab6c9a2-0b24-45a4-b5cd-5212b9d0eb01
# ╟─6e83bd24-194d-4ea9-9976-2bcfbc5a9990
# ╟─5e9c0276-2b69-11ec-2c96-cdc782a9c3a2
# ╟─fed3d9f2-7ddc-4e90-8c09-87d5141adf08
