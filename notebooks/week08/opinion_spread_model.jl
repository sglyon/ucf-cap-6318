using Agents
using InteractiveDynamics # plotting agents
using GLMakie # for static plotting

## Agents
mutable struct Citizen <: AbstractAgent
    id::Int
    pos::Dims{2}
    stabilized::Bool
    opinion::Array{Int,1}
    prev_opinion::Array{Int,1}
end

function create_model(; dims=(10, 10), nsubjects=3, opinions_per_subject=4)
    space = GridSpace(dims)
    properties = Dict(:nsubjects => nsubjects)
    model = AgentBasedModel(
        Citizen,
        space,
        scheduler=Schedulers.randomly,
        properties=properties,
    )
    for pos in positions(model)
        add_agent!(
            pos,
            model,
            false,
            rand(model.rng, 1:opinions_per_subject, nsubjects),
            rand(model.rng, 1:opinions_per_subject, nsubjects),
        )
    end
    return model
end

## Rules
function adopt!(agent, model)
    neighbor = rand(model.rng, collect(nearby_ids(agent, model)))
    matches = model[neighbor].opinion .== agent.opinion
    nmatches = count(matches)
    if nmatches < model.nsubjects && rand(model.rng) < nmatches / model.nsubjects
        switchId = rand(model.rng, findall(x -> x == false, matches))
        agent.opinion[switchId] = model[neighbor].opinion[switchId]
    end
end

function update_prev_opinion!(agent, model)
    for i in 1:(model.nsubjects)
        agent.prev_opinion[i] = agent.opinion[i]
    end
end

function is_stabilized!(agent, model)
    if agent.prev_opinion == agent.opinion
        agent.stabilized = true
    else
        agent.stabilized = false
    end
end

function agent_step!(agent, model)
    update_prev_opinion!(agent, model)
    adopt!(agent, model)
    is_stabilized!(agent, model)
end

## Running the model
rununtil(model, s) = count(a -> a.stabilized, allagents(model)) == length(positions(model))

function main_stability_plot()
    model = create_model(nsubjects=3, opinions_per_subject=4)
    agentdata, _ = run!(model, agent_step!, dummystep, rununtil, adata=[(:stabilized, count)])
    f = Figure(resolution=(600, 400))
    ax =
        f[1, 1] = Axis(
            f,
            xlabel="Generation",
            ylabel="# of stabilized agents",
            title="Population Stability",
        )
    lines!(ax, 1:size(agentdata, 1), agentdata.count_stabilized, linewidth=4, color=:blue)
    f
end

function animation()
    opinions_per_subject = 3
    ac(agent) = GLMakie.RGB((agent.opinion[1:3] ./ opinions_per_subject)...)
    model = create_model(nsubjects=3, opinions_per_subject=opinions_per_subject)

    abm_video(
        "opinion.mp4",
        model,
        agent_step!;
        ac=ac,
        am='■',
        as=20,
        framerate=20,
        frames=265,
        title="Opinion Spread",
    )
end
