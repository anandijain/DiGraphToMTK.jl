module DiGraphToMTK
using Graphs, Symbolics
SE = Graphs.SimpleGraphs.SimpleEdge

function make_rhs(g, v, sts, ps, edge_idx_d)
    ins = inneighbors(g, v)
    ines = SE.(ins, (v,))
    ieidx = map(x -> edge_idx_d[x], ines)
    plus_terms = ps[ieidx] .* sts[ins]

    outs = outneighbors(g, v)
    outes = SE.((v,), outs)
    oeidx = map(x -> edge_idx_d[x], outes)
    min_terms = ps[oeidx] .* sts[outs]

    sum(plus_terms) - sum(min_terms)
end


function digraph_to_eqs(g, D, sts, ps)
    @assert length(ps) == ne(g)
    edge_idx_d = Dict(collect(edges(g)) .=> 1:ne(g))
    [D(sts[v]) ~ make_rhs(g, v, sts, ps, edge_idx_d) for v in vertices(g)]
end

export digraph_to_eqs

end # module DiGraphToMTK
