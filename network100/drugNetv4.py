#coding = utf-8
#interactions between each other
#generating nodes.csv and edges.csv
import pandas as pd 
result=pd.read_excel('inter100ddi.xlsx')
gather100=pd.read_excel('gather100_manu.xlsx')



result2=result.dropna()
drugs=result2['id']
inters=result2['interactions']
for i in range(len(inters)):
	inter=inters[i]
	newinter=[]
	inter=inter.strip('[]')
	inter=inter.split(',')
	for tmp in inter:
		tmp=tmp.strip(" u'")
		#print tmp
		if tmp in drugs.values:
			newinter.append(tmp)
	inters[i]=newinter
result2.index.name='cas'


##map cas to name
gather100.index=gather100.CAS_x
result2=result2[['id','interactions']].join(gather100[['Name_new','Pathways_new']])
##save to inter100v2.xlsx
writer=pd.ExcelWriter('inter100v2.xlsx')
result2.to_excel(writer,'inter')
writer.save()

### nodes
nodes=result2[['Name_new','id','Pathways_new']]
nodes.columns=['id','drugbankid','Pathways_new']
nodes['cas']=nodes.index
nodes.to_csv('nodes.csv',index=False)
## edges
result3=result2.copy()
result3.index=result3.id
result3=result3.drop('id',axis=1)
e_from=[]
e_to=[]
for id in result3.index:
	inters=result3.ix[id,'interactions']
	if inters:
		for inter in inters:
			e_from.append(result3.ix[id,'Name_new'])
			e_to.append(result3.ix[inter,'Name_new'])
edges=pd.DataFrame({'from':e_from,'to':e_to})
edges.to_csv('edges.csv',index=False)






