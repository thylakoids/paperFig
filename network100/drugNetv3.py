#coding = utf-8
#gather the drug name
import pandas as pd
library_repair=pd.read_excel('data.xlsx','library_repair')
mynamelist=library_repair['Name']
result=''
for name in mynamelist:
	result+=name+';'

