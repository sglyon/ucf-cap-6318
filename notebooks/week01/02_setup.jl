### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 9ee575d0-6528-4ac0-86f4-f2a70e2f663a
using PlutoUI

# ╔═╡ 03157e90-0419-11ec-22b3-e9623f0d0324
md"""
# Environment Setup

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon

**Prerequisites**

- Laptop or personal computer with internet connection

**Outcomes**

- Install Julia and Pluto.jl
- Install Git
- Setup GitHub Account

**References**

- Materials Repository: https://github.com/UCF-CAP-6318/lecture-materials (private)
- QuantEcon lectures
    - [Setting up Julia](https://julia.quantecon.org/getting_started_julia/getting_started.html)
    - [Git, GitHub, Version Control](https://julia.quantecon.org/more_julia/version_control.html)
    - [Julia tools and editors](https://julia.quantecon.org/more_julia/tools_editors.html)
"""

# ╔═╡ 906fa8f6-9759-42d2-9651-a8b72ee39d74
md"""
# Step 1: Install Julia

- The first step is to install Julia


"""

# ╔═╡ 1c56ac32-02d8-4a36-ab0a-75fc25a4dbff
md"""
### Task: Install Julia

Download and install Julia, from [download page](http://julialang.org/downloads/) , accepting all default options
"""

# ╔═╡ d66120b2-99a1-4d2a-96af-fbf1795f080b
md"""
# Step 2: Install Pluto.jl

- With Julia installed we are now ready to install some Julia packages
- The first package we'll be using is called Pluto
- This is a package that will provide us a web browser based notebook environment for editing

"""

# ╔═╡ d3aedaeb-bd9f-45a6-ba35-72f8fe3ceec5
md"""
### Task: Install Pluto

Launch the Julia REPL (by typing `julia` from the Linux/OSX terminal prompt or using the start menu on Windows)

At the `juila>` prompt, type `]`

Prompt will switch to `(@v1.6) pkg> `

Once there type `add Pluto` and press enter

Pluto.jl will be downloaded and installed on your machine
"""

# ╔═╡ 04351877-f545-48c6-9ede-77a275428dd2
md"""
### Task: Start Pluto

At the `juila>` prompt (press backspace to exit Pkg mode if needed), type `using Pluto`

Then run the command: `Pluto.run()`

A web browser should pop open with the Pluto.jl interface (should look similar to below)
"""


# ╔═╡ dc37a6c4-92d6-4e4b-965c-57c2959a7b41
PlutoUI.LocalResource("./pluto_jl_homepage.png")

# ╔═╡ f1c6b5cc-d0dd-492c-8d75-4918a04e850e
md"""
# Step 3: Install git

- Git is a powerful version control system
- We'll use it to manage files througout this course

"""

# ╔═╡ 43b51783-8cdd-4f4f-bca5-b417f4394d65
md"""
### Task: Install Git

Choose one of the following:

1. For command line/terminal users: follow the instructions [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git/) to install git
2. For App/GUI users: download [GitHub Desktop](https://desktop.github.com/)


*Note*: I am not an expert in GitHub Desktop, but have heard it is very nice. If you use GitHub Desktop I may be less helpful to solve problems than if you use the standard command line version
"""

# ╔═╡ 9e374c19-a32e-40c3-a870-6f79cb755c7a
md"""
# Step 4: Setup GitHub Account

- GitHub is a website where people can collaborate on code or projects stored in git repositories
- You will use GitHub to submit all homework assignments
- To use GitHub for more than browsing, you need an account
- Let's create one now!

"""

# ╔═╡ 9bd94b97-c2e9-430b-8548-7294afb16390
md"""
### Task: Setup GitHub

**NOTE**: if you already have an account, you can skip this step

Go to the [signup page](https://github.com/signup?ref_cta=Sign+up&ref_loc=header+logged+out&ref_page=%2F&source=header-home) and create an account

"""

# ╔═╡ 0761532a-b912-462d-84dc-4171dbb8db5a
md"""
### Task: Share GitHub username

After creating an account, email me (spencer.lyon@ucf.edu) your GitHub `username`!
"""

# ╔═╡ 1dfafbf0-c44c-491e-aa68-6e1fb43e0405
md"""
# Dependencies
"""

# ╔═╡ 067f19f7-1a7d-4c6a-9300-d0ad6f1ca0d8
html"""<button onClick="present()">present</button>"""

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
git-tree-sha1 = "adcd36e8ba9665c88eb0bd156d4e2a19f9b0d889"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.0"

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
# ╟─03157e90-0419-11ec-22b3-e9623f0d0324
# ╟─906fa8f6-9759-42d2-9651-a8b72ee39d74
# ╟─1c56ac32-02d8-4a36-ab0a-75fc25a4dbff
# ╟─d66120b2-99a1-4d2a-96af-fbf1795f080b
# ╟─d3aedaeb-bd9f-45a6-ba35-72f8fe3ceec5
# ╟─04351877-f545-48c6-9ede-77a275428dd2
# ╟─dc37a6c4-92d6-4e4b-965c-57c2959a7b41
# ╟─f1c6b5cc-d0dd-492c-8d75-4918a04e850e
# ╟─43b51783-8cdd-4f4f-bca5-b417f4394d65
# ╟─9e374c19-a32e-40c3-a870-6f79cb755c7a
# ╟─9bd94b97-c2e9-430b-8548-7294afb16390
# ╟─0761532a-b912-462d-84dc-4171dbb8db5a
# ╟─1dfafbf0-c44c-491e-aa68-6e1fb43e0405
# ╟─067f19f7-1a7d-4c6a-9300-d0ad6f1ca0d8
# ╟─9ee575d0-6528-4ac0-86f4-f2a70e2f663a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
