### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ a10456c2-4a42-4bd3-891f-e23ba5adda78
# TEST CASES BELOW
using Test, PlutoUI

# ╔═╡ 17c68646-2600-11ec-0aa3-55160a8e0c43
md"""
# Types in Julia

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon



**Prerequisites**

- Julia Basics

**Outcomes**

- Understand how functions and methods work in Julia
- Be able to define custom types and implement methods
- Know when to define a type and what its fields should be

**References**

- [https://docs.julialang.org/en/v1/manual/types/](https://docs.julialang.org/en/v1/manual/types/)
"""

# ╔═╡ 9daf2f65-0aca-475e-8401-8390650ebea1
md"""
# Types in Julia

- Julia is both very expressive and runtime efficient
- This is made possible because of the underlying compiler technology
- The main strategy for user interaction with the compiler is by defining custom types and methods that operate on those types
- Types and multiple dispatch go hand in hand and are key to effective Julia
"""

# ╔═╡ 5911c764-feea-4904-9b1c-8cb54eaeeff7
md"""
## What is a type?

- Each piece of data in a program resides in memory (RAM) on the host computer
- We often assign names to data, which we call variables (in `x = "hello"`, `x` is a variable)
- At its most basic level, a variable is composed of
  1. An arrangment of 0's and 1's called bits
  2. An address to where in memory the data is recorded
  3. A `Symbol` representing the name we gave the data
- A **type** in Julia represents what kind of object is represented at a certain memory address
- Julia uses this type information to enable syntax (e.g. the `$` in a string to interpolate or the `.` access for an objects fields) and ultimiately decide what behaviors are defined to operate on the data
"""

# ╔═╡ d3dbcaf1-0276-4354-85cc-3576c6728b1d
md"""
## Organizing types

- In Julia types are organized into a hierarchy
- At the top of the hierarcy is `Any` -- all objects are instances of `Any`
- At the bottom of the hierarchy is `Union{}` -- no objects are instances of `Union{}`
- In between these endpoints we have a rich family of types
- Each type can have at most one parent type (if not specified, default parent is `Any`)
- Types can actually come in a few different flavors...
"""

# ╔═╡ 0be108b4-bb12-4cab-ae1d-39782a82cc53
md"""
## Types of Types

- Abstract Types: cannot be created directly, but serve as nodes in a type hierarchy. Help us organize types into families and provide shared behavior for all members of the family
- Primitive types: provided to us by Julia and represent a collection of bits (e.g. `Float64`, `Bool`, and `Int8`). We *could* create them, but we won't. We won't say anything else about them here
- Composite Types: types that contain additional data called fields. An instance can be treated as a single value. This is what we typically define and use

> NOTE: all objects in Julia are instances of either primitive or composite types, and can be related to one another by sharing common abstract type ancestors
"""

# ╔═╡ cf05c2e7-c1db-45e3-9705-7ab4fc4d5448
md"""
## Abstract Types

- Abstract types help organize composite types into families
- For example, the number system in Julia looks like this
```julia
abstract type Number end
abstract type Real     <: Number end
abstract type AbstractFloat <: Real end
abstract type Integer  <: Real end
abstract type Signed   <: Integer end
abstract type Unsigned <: Integer end
```
- Note:
  - `Number`'s parent type is `Any`
  - `Real` is a special kind of `Number` and can be broken into two subgroups: `AbstractFloat` and `Integer`
"""

# ╔═╡ c0b9475b-5fb7-416c-a50f-c7c0ca0a4bfd
md"""
## Why Abstract Types?

- We said before we can't create an instance of abstract types...
- So, why do we have them?
- The primary reason to have abstract types is to introduced shared functionality via methods defined on the abstract type
- Example: suppose you needed to define a function `isint` to determine if an object is an integer
  - Without abstract types, you could have a long sequence of checks for if a variable is any integer type:  
"""

# ╔═╡ a93e3607-4a66-476e-b8ed-0bfb12c492f3
function isint1(x)
	for T in [
		Int8, UInt8, Int16, UInt16, 
		Int32, UInt32, Int64, UInt64, 
		Int128, UInt128
	]
		if isa(x, T)
			return true
		end
	end
	return false
end


# ╔═╡ 2117eda0-e242-4b83-b353-acf7a2d0ee94
isint1(10), isint1(1.0), isint1(UInt128(234901324987213))

# ╔═╡ 2da92364-844b-4711-a306-14dd9e4b4ff4
md"""
- With abstract types we can define two methods:
"""

# ╔═╡ dc6d68ab-946e-4b81-9ba7-fe5cb9128be2
isint(x) = false

# ╔═╡ 0b3fa12e-2ef9-4e8f-a24f-67ef07287d12
isint(x::Integer) = true

# ╔═╡ c512e6e9-6583-4fe9-bdd0-ed2090025465
md"""
- This has many benefits
  - Much simpler to write/reason about
  - More "fool proof": what if we forgot one of the "UIntXX" types?
  - More "future proof": what if a new type of integer gets introduced (e.g. `UInt256` like is widely used in blockchain data!)
  - Pushes work into the compiler:
"""

# ╔═╡ 14d4970c-c1e8-43b3-af7d-24bf12ef5c16
@code_lowered isint1("hello")

# ╔═╡ 23e90743-9540-42c6-a94f-145f59dbfa87
@code_lowered isint1(UInt128(12341234123423134))

# ╔═╡ edf9a559-b56c-4710-97cf-0aadc3e3f514
md"""
## Composite Types

- Abstract types are very useful when used in conjunction with multiple dispatch (defining multiple methods of function with same name, but varying code depending on argument types)
- However, most often we create types to hold collections of related data together
- We do this using composite types
- A composite type can be created as follows:
```julia
struct Name <: AbstractParentType
    field1::Field1Type
	# more fields
end
```
- Note that the `<: AbstractParentType` is optional, as are types on all fields
"""

# ╔═╡ 9bdc9434-39c6-4935-b403-d1708132dd57
md"""
## Composite Types: Examples
"""

# ╔═╡ cf5ed4d6-ffa0-420a-835d-128881754895
struct Foo
   bar
   baz::Int
   qux::Float64
end

# ╔═╡ 6696fef9-d75a-4cd9-a087-c22e41500aff
foo = Foo("Hello, world.", 23, 1.5)

# ╔═╡ e094e749-a648-4c22-93f5-aead84735894
typeof(foo)

# ╔═╡ f53a82bb-aac5-489c-82ac-be08121f7ffe
Foo((), 23.5, 1)

# ╔═╡ f968c9ed-eb4b-4112-8d41-eb30c7006704
fieldnames(Foo)

# ╔═╡ e9ecb859-03ee-4ad2-8447-409e9b8d702f
foo.bar

# ╔═╡ 3d176328-3f5a-4f55-8d5a-5ec20e59604e
foo.baz

# ╔═╡ 671178b6-2f3f-4c68-a158-47d33599639e
foo.qux

# ╔═╡ cc3df711-2cdd-44ad-9c83-ab111d564f0b
md"""
## Composite Types and Dispatch

- Above we saw an example of defining multiple methods of `isint`, using an abstract type to route dispatch
- We can also use composite types
"""

# ╔═╡ 5a91d2cc-e617-4fc3-bd25-7158b4e286be
isint(x::Foo) = isint(x.bar)

# ╔═╡ 5a102b59-93e3-407d-b099-c8c79b29f92e
isint(10), isint(1.0), isint(UInt128(234901324987213))

# ╔═╡ 5a46392a-c6a3-48b6-91aa-dbd7a2d2a853
@code_lowered isint("hello")

# ╔═╡ 9384a0a0-8404-4af9-a9e1-187128109ae2
@code_lowered isint(UInt128(12341234123423134))

# ╔═╡ e707aa4a-98f8-46bf-a427-1ef4c310cf00
isint(foo)

# ╔═╡ 01544320-40d2-4e21-8607-576a87a6fc46
@code_lowered isint(foo)

# ╔═╡ ae75f67b-2c33-4e4b-b4e1-ab86cdc8f0a3
foo, isint(foo)

# ╔═╡ 3b6f2f15-a06e-492c-9c46-3ff1dd47a40c
isint(Foo(1, 23, 1.5))

# ╔═╡ 9126de09-8d07-4872-8349-7972f59c4ca0
md"""
## Exercises

- Create an abstract type called `Person`
- Create two composite subtypes of `Person` called `Friend` and `Foe`
  - Each of these should have fields `name` and `height_inches`
  - For friend you should also have a field `favorite_color`
  - MAKE SURE TO ADD TYPES FOR ALL FIELDS
- Create a third composite subtype of `Person` called `Stranger`, but without any fields
- Suppose we are trying to decide who to invite to a dinner party. Our rule is that friends should get a definite yes. Enemies a definite no. Strangers a 50%/50% toss up. However, if our spouse says we should invite a person, the answer is always yes
  - Create a function `should_invite_to_party` that implements that logic
  - HINT: you will need 4 methods. 3 of these have only one argument, the 4th has two

- In the cell at the bottom we have written a test case. You will know you've done this correctly when all the tests pass
"""

# ╔═╡ bf0e8b24-37fb-4fed-9e59-fd15eab75585
begin
	
	abstract type Person end
	
	mutable struct Friend <: Person
		name::String
		height_inches::Int
		favorite_color::String
	end
	
	struct Foe <: Person
		name::String
		height_inches::Int
	end
	
	struct Stranger <: Person end
	
	should_invite_to_party(::Friend) = true
	should_invite_to_party(::Foe) = false
	should_invite_to_party(::Stranger) = rand() < 0.5
	should_invite_to_party(::Person, spouse_says::Bool) = spouse_says
end

# ╔═╡ 2e7c6756-6785-4424-92ef-27f2512c7596
function tests()
	@testset "people" begin
	
		@test fieldnames(Friend) == (:name, :height_inches, :favorite_color)
		@test fieldnames(Foe) == (:name, :height_inches)
		@test fieldnames(Stranger) == tuple()

		jim = Friend("Jim", 64, "blue")
		dwight = Foe("Dwight", 61)
		creed = Stranger()

		@test jim isa Person
		@test dwight isa Person
		@test creed isa Person

		@test should_invite_to_party(jim) 
		@test !should_invite_to_party(dwight)
		@test should_invite_to_party(dwight, true)
		
		creed_invites = map(i->should_invite_to_party(creed), 1:100)
		@test any(creed_invites)
		@test any(map(!, creed_invites))

		creed_invites_spouse = map(i->should_invite_to_party(creed, true), 1:100)
		@test all(creed_invites_spouse)	
	end
end

# ╔═╡ deb18595-8059-4912-8ba0-518c68ab23ca
with_terminal(tests) 

# ╔═╡ 01277f31-0932-4a12-bd9b-3ee314f2ba22
friends = [Friend(string(('A':'Z')[i]), 40+i, "green") for i in 1:26]

# ╔═╡ 41fcaa6b-614b-49bd-a79a-96feeb4a76ac
should_invite_to_party.(friends)

# ╔═╡ 6cfff0a2-462a-49ea-be4b-31476b9d089f
friend = friends[1]

# ╔═╡ 7a817587-49f8-490f-b72a-20ee255a1b5f
friend.name = "Santa Claus"

# ╔═╡ 83f24847-77da-4112-b742-d4d32f68ae3e
friend

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
PlutoUI = "~0.7.14"
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
git-tree-sha1 = "a8709b968a1ea6abc2dc1967cb1db6ac9a00dfb6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.5"

[[PlutoUI]]
deps = ["Base64", "Dates", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "d1fb76655a95bf6ea4348d7197b22e889a4375f4"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.14"

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

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═17c68646-2600-11ec-0aa3-55160a8e0c43
# ╟─9daf2f65-0aca-475e-8401-8390650ebea1
# ╟─5911c764-feea-4904-9b1c-8cb54eaeeff7
# ╟─d3dbcaf1-0276-4354-85cc-3576c6728b1d
# ╟─0be108b4-bb12-4cab-ae1d-39782a82cc53
# ╟─cf05c2e7-c1db-45e3-9705-7ab4fc4d5448
# ╟─c0b9475b-5fb7-416c-a50f-c7c0ca0a4bfd
# ╠═a93e3607-4a66-476e-b8ed-0bfb12c492f3
# ╠═2117eda0-e242-4b83-b353-acf7a2d0ee94
# ╟─2da92364-844b-4711-a306-14dd9e4b4ff4
# ╠═dc6d68ab-946e-4b81-9ba7-fe5cb9128be2
# ╠═0b3fa12e-2ef9-4e8f-a24f-67ef07287d12
# ╠═5a102b59-93e3-407d-b099-c8c79b29f92e
# ╟─c512e6e9-6583-4fe9-bdd0-ed2090025465
# ╠═14d4970c-c1e8-43b3-af7d-24bf12ef5c16
# ╠═5a46392a-c6a3-48b6-91aa-dbd7a2d2a853
# ╠═23e90743-9540-42c6-a94f-145f59dbfa87
# ╠═9384a0a0-8404-4af9-a9e1-187128109ae2
# ╟─edf9a559-b56c-4710-97cf-0aadc3e3f514
# ╠═9bdc9434-39c6-4935-b403-d1708132dd57
# ╠═cf5ed4d6-ffa0-420a-835d-128881754895
# ╠═6696fef9-d75a-4cd9-a087-c22e41500aff
# ╠═e094e749-a648-4c22-93f5-aead84735894
# ╠═f53a82bb-aac5-489c-82ac-be08121f7ffe
# ╠═f968c9ed-eb4b-4112-8d41-eb30c7006704
# ╠═e9ecb859-03ee-4ad2-8447-409e9b8d702f
# ╠═3d176328-3f5a-4f55-8d5a-5ec20e59604e
# ╠═671178b6-2f3f-4c68-a158-47d33599639e
# ╠═e707aa4a-98f8-46bf-a427-1ef4c310cf00
# ╠═01544320-40d2-4e21-8607-576a87a6fc46
# ╟─cc3df711-2cdd-44ad-9c83-ab111d564f0b
# ╠═5a91d2cc-e617-4fc3-bd25-7158b4e286be
# ╠═ae75f67b-2c33-4e4b-b4e1-ab86cdc8f0a3
# ╠═3b6f2f15-a06e-492c-9c46-3ff1dd47a40c
# ╟─9126de09-8d07-4872-8349-7972f59c4ca0
# ╠═bf0e8b24-37fb-4fed-9e59-fd15eab75585
# ╠═a10456c2-4a42-4bd3-891f-e23ba5adda78
# ╠═2e7c6756-6785-4424-92ef-27f2512c7596
# ╠═deb18595-8059-4912-8ba0-518c68ab23ca
# ╠═01277f31-0932-4a12-bd9b-3ee314f2ba22
# ╠═41fcaa6b-614b-49bd-a79a-96feeb4a76ac
# ╠═6cfff0a2-462a-49ea-be4b-31476b9d089f
# ╠═7a817587-49f8-490f-b72a-20ee255a1b5f
# ╠═83f24847-77da-4112-b742-d4d32f68ae3e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
