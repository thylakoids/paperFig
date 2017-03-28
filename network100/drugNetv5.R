library(igraph)
library(RColorBrewer)
nodes=read.csv('nodes.csv')
edges=read.csv('edges.csv')
gather100_manu=read.csv('gather100_manu.csv')
path_all=factor(gather100_manu$Pathways_new,order=T,levels=names(sort(table(gather100_manu$Pathways_new),decreasing=T)))
Set3=brewer.pal(12,"Set3")
Accent=brewer.pal(8,"Accent")
col16=c(Set3,Accent[5:8])

net1=graph_from_data_frame(d=edges,vertices=nodes,directed=F)
net2 <- simplify(net1, remove.multiple = T, remove.loops = T) 
#compute node degrees and use that to set node size
deg1 <- degree(net2, mode="all")
nodes=nodes[deg1>0,]
#



net=graph_from_data_frame(d=edges,vertices=nodes,directed=F)
net<- simplify(net, remove.multiple = T, remove.loops = T) 
deg<- degree(net, mode="all")
V(net)$size <- 7+8*(deg-min(deg))/max(deg)
V(net)$frame.color <- "white"
#sign color to nodes
path=factor(V(net)$Pathways_new,order=T,levels=levels(path_all))
path_n=as.numeric(path)
V(net)$color<-col16[path_n]
#V(net)$color <- "orange"
V(net)$label.cex<-0.8
E(net)$curved=0.01
#pdf('net.pdf')
plot(net,layout=layout_nicely)
path_t=table(path)
legend(x=-2, y=1, names(path_t[path_t>0]), pch=21,col="#777777", pt.bg=col16[path_t>0], pt.cex=2.2, cex=0.9, bty="n", ncol=1)
#clp <- cluster_label_prop(net)
#plot(clp, net)

#library('visNetwork') 
#visNetwork(nodes, edges, width="100%", height="400px", main="Network!")

#####compare layouts
#layouts <- grep("^layout_", ls("package:igraph"), value=TRUE)[-1] 
## Remove layouts that do not apply to our graph.
#layouts <- layouts[!grepl("bipartite|merge|norm|sugiyama|tree", layouts)]
#pdf('1.pdf')
#for (layout in layouts) {
#  print(layout)
#  l <- do.call(layout, list(net)) 
#  plot(net, edge.arrow.mode=0, layout=l, main=layout) }
 # dev.off()