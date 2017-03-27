#coding = utf-8
#modify pathway
import pandas as pd 
gather100=pd.read_excel('gather100.xlsx')
writer=pd.ExcelWriter('gather100_pathway.xlsx')

pathways_new=[];
for pathway in gather100['Pathways']:
	tmp=pathway.split(';')[0]
	pathways_new.append(tmp)
gather100['Pathways_new']=pathways_new
gather100[['Name','No','CAS_x','Pathways','Pathways_new']].to_excel(writer,'s',index=False)
writer.save()



