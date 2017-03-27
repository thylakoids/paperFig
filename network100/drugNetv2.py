#coding = utf-8
#python scraping www.drugbank.ca
import pandas as pd
from selenium import webdriver
import re
import time
library_repair=pd.read_excel('data.xlsx','library_repair')
mycaslist=library_repair['CAS'][2:]
#for text
#mycaslist=pd.Series('185243-69-0',name='tryCAS')  
browser=webdriver.Chrome()
result=dict()
procesn=0
for cas in mycaslist.values:
	procesn+=1
	print '[*]Process: ',procesn
	browser.get('http://www.drugbank.ca')
	browser.find_element_by_id("query").send_keys(cas)
	browser.find_element_by_name('button').submit()
	time.sleep(5)
	if browser.title=='Search Results for drug - DrugBank':
		result[cas]={}
		continue
	#browser.implicitly_wait(30)
	interactions=[];
	try:
		#see if interactions exit
		browser.find_element_by_xpath("//*[@id='drug-interactions_length']/label/select").send_keys('100')
		page_N=0
		n=100
		while n==100:
			interactions_n=browser.find_element_by_xpath('//*[@id="drug-interactions_info"]').text
			n=int(re.findall('^Showing [0-9]* to ([0-9]*) of [0-9]* entries$',interactions_n)[0])
			print n
			n=n-page_N*100
			print n
			for i in range(1,n+1):
				xpath='//*[@id="drug-interactions"]/tbody/tr['+str(i)+']/td[1]/a'
				try:
					#see if href exit
					href=browser.find_element_by_xpath(xpath).get_attribute('href')
				except:
					print 'No a:',i+page_N*100
					href=None
				if href:
					interactions.append(re.findall('(DB[0-9]*$)',href)[0])
			page_N+=1
			try:
				browser.find_element_by_xpath('//*[@id="drug-interactions_next"]/a').click()
				print 'next page'
				time.sleep(5)
			except:
				print 'end'
	except Exception,e :
		print  Exception,":",e
		print '[no interaction]'

	name=browser.find_element_by_xpath('/html/body/main/table[1]/tbody/tr[2]/td/strong').text
	dbid=browser.find_element_by_xpath('/html/body/main/table[1]/tbody/tr[3]/td/strong').text
	result[cas]={'name':name,'id':dbid,'interactions':interactions}
	


#//*[@id="drug-interactions"]/tbody/tr[1]/td[1]/a
#//*[@id="drug-interactions"]/tbody/tr[12]/td[1]/a
#//*[@id="drug-interactions_info"]
#//*[@id="drug-interactions_length"]/label/select
writer=pd.ExcelWriter('inter100.xlsx')
df=pd.DataFrame(result)
df=df.T
df.to_excel(writer,'inter')
writer.save()