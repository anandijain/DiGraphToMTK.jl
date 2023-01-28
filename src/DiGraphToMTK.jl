module DiGraphToMTK
using Graphs, Symbolics
SE = Graphs.SimpleGraphs.SimpleEdge

function digraph_to_eqs(g, D, sts, ps, edge_weights)
    d = Dict(sts .=> Num(0))
    for (i, e) in enumerate(edges(g))
        d[sts[e.src]] -= ps[i] * edge_weights[e.src]
        d[sts[e.dst]] += ps[i] * edge_weights[e.src]
    end
    eqs = []
    for (k, v) in d
        push!(eqs, D(k) ~ v)
    end
    eqs
end

export digraph_to_eqs

end # module DiGraphToMTK
