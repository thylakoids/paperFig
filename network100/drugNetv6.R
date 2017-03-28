library(igraph)

nodes=read.csv('nodes.csv')
edges=read.csv('edges.csv')

net1=graph_from_data_frame(d=edges,vertices=nodes,directed=F)
net2 <- simplify(net1, remove.multiple = T, remove.loops = T) 
#compute node degrees and use that to set node size
deg1 <- degree(net2, mode="all")
nodes=nodes[deg1>0,]
#
net=graph_from_data_frame(d=edges,vertices=nodes,directed=F)
net<- simplify(net, remove.multiple = T, remove.loops = T) 


library('network')
links=as_edgelist(net,names=T)
net3 <- network(edges,  vertex.attr=nodes, matrix.type="edgelist", 
                loops=F, multiple=F, ignore.eval = F)