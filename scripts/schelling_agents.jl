using Agents, InteractiveDynamics, GLMakie

mutable struct SchellingAgent <: AbstractAgent
    id::Int             # The identifier number of the agent
    pos::NTuple{2, Int} # The x, y location of the agent on a 2D grid
    is_happy::Bool      # whether the agent is happy in its position. (true = happy)
    group::Int          # The group of the agent, determines mood as it interacts with neighbors 0: blue, 1: orange
end


function agent_step!(agent::SchellingAgent, model)
	  want = model.wanted_neighbors
	  have = 0
	  for n in nearby_agents(agent, model)
		    have += 1
	  end
	  agent.is_happy = have >= want
	  if !agent.is_happy
		    move_agent_single!(agent, model)
	  end
	  return
end


function init_schelling(;num_agents_per_group=250)
	  environment = GridSpace((25, 25), periodic=false)
	  properties = Dict(:wanted_neighbors => 4)
	  model = ABM(SchellingAgent, environment; properties)

	  id = 0
	  for group in 1:2, i in 1:num_agents_per_group
		    agent = SchellingAgent(id+=1, (1, 1), false, group)
		    add_agent_single!(agent, model)
	  end
	  model
end


groupcolor(a) = a.group == 1 ? :blue : :orange
groupmarker(a) = a.group == 1 ? :circle : :rect


function interactive_example()
	  model = init_schelling()
	  adata = [(:is_happy, sum)]
	  alabels = ["n_happy"]
	  parameter_range = Dict(:wanted_neighbors => 0:8)
	  abm_data_exploration(
		    model, agent_step!, dummystep, parameter_range;
		    ac = groupcolor, am = groupmarker, as = 10,
		    adata, alabels
	  )
end
