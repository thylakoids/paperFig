library(igraph)
nodes=read.csv('nodes.csv')
edges=read.csv('edges.csv')

net1=graph_from_data_frame(d=edges,vertices=nodes,directed=F)
#compute node degrees and use that to set node size
deg1 <- degree(net1, mode="all")
nodes=nodes[deg1>0,]


net=graph_from_data_frame(d=edges,vertices=nodes,directed=F)
deg<- degree(net, mode="all")
V(net)$size <- deg/3
V(net)$frame.color <- "white"
V(net)$color <- "orange"
#V(net)$label.cex<-1
E(net)$curved=0.1
#pdf('net.pdf',width=1920,height=1080)
par(mfrow=c(1,2))
plot(net,layout=layout_with_fr)
clp <- cluster_label_prop(net)
plot(clp, net)

library('visNetwork') 
visNetwork(nodes, edges, width="100%", height="400px", main="Network!")
