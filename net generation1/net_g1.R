# redraw the graph for g1
library(igraph)
library(RColorBrewer)
edges=read.csv('edges28.csv')
nodes=read.csv('nodes28.csv')
gather100_manu=read.csv('gather100_manu.csv')
path_all=factor(gather100_manu$Pathways_new,order=T,levels=names(sort(table(gather100_manu$Pathways_new),decreasing=T)))

Set3=brewer.pal(12,"Set3")
Accent=brewer.pal(8,"Accent")
col16=c(Set3,Accent[5:8])

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
V(net)$label.cex<-0.9
E(net)$curved=0
#pdf('net.pdf')
##edge width and color
weig=abs(E(net)$weight)
colorrange=c(50,255)
A=255-(colorrange[2]-colorrange[1])*(weig-min(weig))/(max(weig)-min(weig))-colorrange[1]
E(net)$color=sapply(A,function(x)rgb(x,x,x,maxColorValue = 255))
#E(net)$color='black'
widthrange=c(1,4)
E(net)$width=widthrange[1]+(widthrange[2]-widthrange[1])*(weig-min(weig))/(max(weig)-min(weig))
##permute net , 
#sorder=sample(vcount(net))
#load('sorder.RData')
y1=sort(path_n,index.return=T)$ix
y2=sort(y1,index.return=T)$ix
g=permute(net,y2)

plot(g,layout=layout_in_circle)
path_t=table(path)
legend(x=-1.8, y=1.2, names(path_t[path_t>0]), pch=21,col="#777777", pt.bg=col16[path_t>0], pt.cex=2.2, cex=0.9, bty="n", ncol=1)

#####compare layouts
#layouts <- grep("^layout_", ls("package:igraph"), value=TRUE)[-1] 
## Remove layouts that do not apply to our graph.
#layouts <- layouts[!grepl("bipartite|merge|norm|sugiyama|tree|components|kk", layouts)]
#pdf('2.pdf')
#for (layout in layouts) {
 # print(layout)
 # l <- do.call(layout, list(net)) 
 # plot(net, edge.arrow.mode=0, layout=l, main=layout) }
 #dev.off()

#tkid <- tkplot(net) #tkid is the id of the tkplot that will open
#l <- tkplot.getcoords(tkid) # grab the coordinates from tkplot
#plot(net, layout=l)