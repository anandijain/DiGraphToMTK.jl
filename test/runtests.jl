using DiGraphToMTK, Graphs, Symbolics, ModelingToolkit
SE = Graphs.SimpleGraphs.SimpleEdge

@parameters t
D = Differential(t)

vertex_names = [:S, :E, :I, :R, :H, :D]
sts = only.([@variables $x(t) for x in vertex_names])
S, E, Ii, R, H, Dd = sts

ges = SE.([1 => 2, 2 => 3, 3 => 4, 3 => 5, 5 => 6])
edge_weights = [
    Ii * S,
    E,
    Ii,
    Ii,
    H
]

g = SimpleDiGraph(6)
[add_edge!(g, e) for e in ges]
ps = only.([@parameters $p for p in [Symbol(:p, i) for i in 1:ne(g)]])
eqs = digraph_to_eqs(g, D, sts, ps, edge_weights)
@named sys = ODESystem(eqs)
ssys = structural_simplify(sys)
sys2 = substitute(ssys, parameters(ssys) .=> 1)

true_sys = eval(quote
    var"##iv#534" = (@variables(t))[1]
    var"##sts#535" = (collect)(@variables(S(t), E(t), Ii(t), R(t), H(t), D(t)))
    var"##eqs#537" = [(~)((Differential(t))(S), (*)(-1 // 1, Ii, S))
        (~)((Differential(t))(E), (+)((*)(-1 // 1, E), (*)(Ii, S)))
        (~)((Differential(t))(Ii), (+)((*)(-2 // 1, Ii), E))
        (~)((Differential(t))(R), Ii)
        (~)((Differential(t))(H), (+)((*)(-1 // 1, H), Ii))
        (~)((Differential(t))(D), H)]
    var"##defs#538" = (Dict)()
    var"##iv#539" = (@variables(t))[1]
    (ODESystem)(var"##eqs#537", var"##iv#539", var"##sts#535", []; defaults=var"##defs#538", name=:PetriNet, checks=false)
end)


@test ModelingToolkit.isisomorphic(true_sys, sys2)


#old and bad
# vertex_names = [:S, :E, :I, :R, :H, :D, :Id]
# sts = only.([@variables $x(t) for x in vertex_names])
# S, E, Ii, R, H, Dd, Id = sts

# ges = SE.([1 => 2, 2 => 3, 3 => 4, 3 => 5, 3 => 6, 5 => 6, 5 => 4])
# g = SimpleDiGraph(7)
# [add_edge!(g, e) for e in ges]
# ps = only.([@parameters $p for p in [Symbol(:p, i) for i in 1:ne(g)]])
# eqs = digraph_to_eqs(g, D, sts, ps)
# @named sys = ODESystem(eqs)
# ssys = structural_simplify(sys)

# # seirhd with extra state for undetected infections 
# g2es = SE.([1 => 2, 2 => 3, 3 => 4, 3 => 6, 3 => 7, 7 => 4, 7 => 5, 7 => 6, 5 => 6, 5 => 4])
# g2 = SimpleDiGraph(7)
# [add_edge!(g2, e) for e in g2es]
# ps2 = only.([@parameters $p for p in [Symbol(:p, i) for i in 1:ne(g2)]])
# eqs2 = digraph_to_eqs(g2, D, sts, ps2)
# @named sys2 = ODESystem(eqs2)
# ssys2 = structural_simplify(sys2)
