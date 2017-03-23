#gather all the infomation about the 100 drugs in a single xlsx file
import pandas as pd 
import os
library_real=pd.read_excel('data.xlsx','library_repair')
FDA=pd.read_excel('data.xlsx','FDA_1700')
#merge the two dataframe
result=library_real.merge(FDA,how='left',left_on='Name',right_on='Name')
#sort by number
result=result.sort('No')
#write
writer=pd.ExcelWriter('gather100.xlsx')
result.to_excel(writer,'repair_s',header=True,index=False,startrow=0,startcol=0) 
writer.save()
os.system('start gather100.xlsx')