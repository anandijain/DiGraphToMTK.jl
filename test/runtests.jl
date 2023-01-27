using DiGraphToMTK, Graphs, Symbolics, ModelingToolkit

@parameters t
D = Differential(t)

vertex_names = [:S, :E, :I, :R, :H, :D, :Id]
sts = only.([@variables $x(t) for x in vertex_names])

# seirhd 
ges = SE.([1 => 2, 2 => 3, 3 => 4, 3 => 5, 3 => 6, 5 => 6, 5 => 4])
g = SimpleDiGraph(7)
[add_edge!(g, e) for e in ges]
eqs = digraph_to_eqs(g, D, sts)
@named sys = ODESystem(eqs)
ssys = structural_simplify(sys)

# seirhd with extra state for undetected infections 
g2es = SE.([1 => 2, 2 => 3, 3 => 4, 3 => 6, 3 => 7, 7 => 4, 7 => 5, 7 => 6, 5 => 6, 5 => 4])
g2 = SimpleDiGraph(7)
[add_edge!(g2, e) for e in g2es]
eqs2 = digraph_to_eqs(g2, D, sts)
@named sys2 = ODESystem(eqs2)
ssys2 = structural_simplify(sys2)
