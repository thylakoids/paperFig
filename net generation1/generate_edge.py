#generation edges from data.excel for later R vis
#for 100 and 28
import pandas as pd
flag='28'
beta100=pd.read_excel('data.xlsx','beta'+flag,header=None)
beta100=beta100[[3,4,0,1,2]]
beta100.columns=['from','to','weight','fromn','ton']
beta100_p=beta100.ix[beta100['weight']!=0,]
#edges
beta100_p.to_csv('edges'+flag+'.csv',index=False)
#nodes
gather100_manu=pd.read_excel('data.xlsx','gather100_manu')
gather100_manu=gather100_manu.set_index('Name_new')
nodes=pd.Series(beta100_p[['from','to']].values.ravel()).unique()
nodes_plus=gather100_manu.ix[nodes,]
nodes_plus.index.name='id'
print flag
print len(nodes_plus)
nodes_plus.to_csv('nodes'+flag+'.csv')




