### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ b5399892-25e6-11ec-015f-8582c58e6432
md"""
# Agent Based Models

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon



**Prerequisites**

- None 😏

**Outcomes**

- Understand what a model is
- Know the difference between what we call equation based models and agent based models
- Understand the key building blocks of agent based models
- Learn the key components of the Schelling segregation model

**References**

- [Cioffi-Revilla](https://www.springer.com/gp/book/9783319501307) Chapter 10
- [https://journal.sohostrategy.com/what-does-an-agent-based-model-look-like-dc1fbc17f2f5](https://journal.sohostrategy.com/what-does-an-agent-based-model-look-like-dc1fbc17f2f5)
- [https://journal.sohostrategy.com/what-is-abm-abms-f52ff2f1f712](https://journal.sohostrategy.com/what-is-abm-abms-f52ff2f1f712)
- [https://towardsdatascience.com/agent-based-modeling-will-unleash-a-new-paradigm-of-machine-learning-ff6d3b1ac940?source=search_post---------3](https://towardsdatascience.com/agent-based-modeling-will-unleash-a-new-paradigm-of-machine-learning-ff6d3b1ac940?source=search_post---------3)
"""

# ╔═╡ bfe02e2d-7a85-47ad-9a8e-ed8506c7beb0
md"""
# Why Models?

- Many topics of interest for social scientists are either unethical or unreasonable to study in a laboratory
  - Impact on communities of upsurge in illicit drug usage (can't give people drugs to see impact)
  - Flow of traffic given a new infrastructure updates (too costly to experiment with)
  - Impact of new tarrifs in international trading relationships (too costly to coorindate legislation and implement)
- For this reason, we as social scientists turn to *models* to study our problems
- A model is a probability distribution over outcomes
- I'll repeat for emphasis: a model is a probability distribution over outcomes
"""

# ╔═╡ 2714f12f-321c-4672-8359-49132e4d0f5b
md"""
## Types of Models

- A model is a mathematical object: equations, rules, distributional assumptions.
- At its heart, a model is a simplification of some real-world system or phenonmenom
  - Much complexity is abstracted away (or not included directly in model)
  - Key aspects relevant for study are modeled explicitly (e.g. trading response to tarrifs)
- For our purposes, we will think of models as belonging to one of two families
  - Equation based models
  - Agent based models

> This is a simplification and not a perfect classification (because equation based models have agents and agent based models have equations), but we will be able to draw useful distinctions with this classification.
"""

# ╔═╡ 6991818f-eab3-4c3d-bc8d-a0984f739b3e
md"""
## Equation Based Models

- An equation based model describes the decision making setting for each agent using mathematical equations
- Typically, these are posed as (constrained) optimization problems
- A set of equaitons is also developed that describe interaction between agents
- These equations can feature random variables and will require specification of model parameters
- Most models I study and develop in my economics research are equation based
- Pros:
  - Allow precise specification of assumptions, incentives, and outcomes
  - Have wide toolbox of numerical optimization, and statistical fitting to "solve" model
- Cons:
  - Optimization and calibration of parameters can be very difficult
  - Often subject to the "curse of dimensionality", which limits size and complexity of model
"""

# ╔═╡ 258514e7-53e0-4f29-b759-d025c6d61cf9
md"""
## Agent Based Models (ABMs)

- An agent based model describes rules for how individual agents respond to their environment
- There are usually many agents, each with a set of properties
- One common property is the *type* of the agent: usually drawn from a small/finite set (buyer-seller, parent-child-teacher, sheep-wolf)
- All agents of the same type have the same set of additional properties
- Each agent has a *state* at each time step $t$
- The *rules* are equations that specify how the state of an agent is updated between periods $t$ and $t+1$
  - Rules are common for all agents of a type, but vary based on that agent's state and property values
  - Rules will often have random variables as well as parameters
  - Rules often include notion of "neighboring" agents
- Pros:
  - Focus on how an individual should respond in a given state without *requiring* optimization
  - Because rules are typically mathematically simple, can have many many agents
- Cons:
  - Often lacks notion of equilibrium (could be a feature)
  - Not very "reusable" -- to study specific topic you usually have to create whole new model
  - Sometimes [too many parameters](https://math.stackexchange.com/questions/2970219/was-von-neumann-right-that-with-four-parameters-you-can-fit-an-elephant): need for careful calibration
"""

# ╔═╡ 49124b12-3f88-4afe-ad78-4da8d563b2a2
md"""
# ABMs

- For the next few lectures we'll focus on agent base models
- We'll start by outlining the main components of an ABM
- Then we'll talk about how we could represent them in Julia using the Agents.jl library
  - This will require a step up in our Julia skills, so we'll spend some time covering these concepts in greater detail
- Finally we'll see a few examples of ABMs in practice

> NOTE: Most of the study of the Julia skills and ABM examples are not in this notebook
"""

# ╔═╡ 69859737-35e0-4354-b585-174d115a48c9
md"""
# ABM components

- ABMs are made up of 3 distinct components:
  1. Agents
  2. Environment
  3. Rules
"""

# ╔═╡ 60a4477f-1c35-4b0c-ae81-965f7e2c3bfd
md"""
## Agents

- Have state at discrete time steps $t$ (state is value of properties, some properties might be fixed)
- Always aware of its own state
- Autonomous: can make a decisions independent of other agents
- Reactive: can respond to changes in environment or state of other agents
- Proactive: can behave in a way to achieve a goal
- Communicate: can make some attributes visible to other agents

"""

# ╔═╡ e34bd171-8706-4107-9850-a823ed5b8906
md"""
## Environments

- One of two types
  1. Natural Environments: biophysical landscapes and settings 
  2. Artifical environments: classrooms, economic markets, parks, transportation streets, buildings, etc.
- Agents reside within an environment
- Properties of environment can be fixed (size, dimensions) or varying (weather, congestion, unused capacity)
- Agents can observe and potentially respond to properties of the environment
"""

# ╔═╡ 1dbd7a97-41df-4ffe-805a-b6c3f9d8b9a5
md"""
## Rules

- Rules are the key feature that makes ABMs dynamic
- Types of rules:
  - Inter-agent: how agents communicate and respond to one another (e.g. information spread)
  - Agent-environment rules: How an agent responds to an environment (e.g. avoid park if raining), or how an agent's decisions and behaviors impact environment (e.g. more cars => more pollution)
  - Intra-environmental rules: cause and effect mechanisms within the environment (e.g. more rain => more vegetation)
"""

# ╔═╡ ae06a603-fd9d-4b78-95ab-835586db9239
md"""
# ABMs in Julia

- We need a way to represent these three components in Julia
- Agents: represent as a Julia struct
    - Struct fields record agent properties
    - Our custom agent type can have `methods` that ascribe behavior to agents
- Environments: either explicitly as Julia struct or implicitly in the update rules
- Rules: julia functions
    - Key function is `step!` which will allow our agents to make decisions and have the environment and agent properties update in response
"""

# ╔═╡ 5571b5e9-6f6a-466b-8929-36468e46c927
md"""
# Schelling Segregation Model

- We will work on learning how to represent our agents, rules, and environment in Julia
- To make that discussion more concrete, it will be helpful to have a model to implement
- The "hello world" of ABMs may just be the Schelling segregation model
- References include [QuantEcon](https://julia.quantecon.org/multi_agent_models/schelling.html) and [Agents.jl](https://juliadynamics.github.io/Agents.jl/stable/examples/schelling/#Schelling's-segregation-model) tutorial

"""

# ╔═╡ 6ff1ebd5-ae4b-41ca-8a9e-8b9d7d2cfc0f
md"""
## Schelling's Work

- Thomas Schelling won a nobel price in economics for his study of racial segregation
- At the heart of his study, was a model proposed in 1969 for how racial segregation can occur in urban areas
- One theme of this work (and ABMs in general) is that local interactions (like decisions of individual agents) can lead to surprising aggregate results
"""

# ╔═╡ 06326c63-8139-4e8d-ba5f-bcc289188cf6
md"""
## The Model

- Environment: 25x25 grid of single family dwellings
- Agents with properties:
  - location (x,y) coordinate for current home
  - type: orange or blue. Fixed over time. 250 of each
  - happiness: 0 if less than $N$ of neighbors are of same type, 1 otherwise
- Rules:
  - Agents choose to move to unoccupied grid point if unhappy

> Note neighbors for a particular cell are the the 8 other cells surrounding the cell of interest. Corner or edge cells have less than 8 neighbors
"""

# ╔═╡ Cell order:
# ╟─b5399892-25e6-11ec-015f-8582c58e6432
# ╟─bfe02e2d-7a85-47ad-9a8e-ed8506c7beb0
# ╟─2714f12f-321c-4672-8359-49132e4d0f5b
# ╟─6991818f-eab3-4c3d-bc8d-a0984f739b3e
# ╟─258514e7-53e0-4f29-b759-d025c6d61cf9
# ╟─49124b12-3f88-4afe-ad78-4da8d563b2a2
# ╟─69859737-35e0-4354-b585-174d115a48c9
# ╟─60a4477f-1c35-4b0c-ae81-965f7e2c3bfd
# ╟─e34bd171-8706-4107-9850-a823ed5b8906
# ╟─1dbd7a97-41df-4ffe-805a-b6c3f9d8b9a5
# ╟─ae06a603-fd9d-4b78-95ab-835586db9239
# ╠═5571b5e9-6f6a-466b-8929-36468e46c927
# ╟─6ff1ebd5-ae4b-41ca-8a9e-8b9d7d2cfc0f
# ╠═06326c63-8139-4e8d-ba5f-bcc289188cf6
