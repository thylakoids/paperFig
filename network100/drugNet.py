#encoding='UTF-8'
####not working for full database, quit
#parse XML
#1.xml for test
import pandas as pd
import xml.etree.ElementTree as ET
tree=ET.parse('1.xml')
root=tree.getroot()
newtree=ET.ElementTree('newtree')
newroot=ET.Element('druglib')
newtree._setroot(newroot)

#library_repair=pd.read_excel('data.xlsx','library_repair')
#mycaslist=library_repair['CAS']
mycaslist=pd.Series(['143831-71-4','185243-69-0'],name='tryCAS')
i=0
for drug_element in root:
	tmp_cas=drug_element.find('cas-number')
	if   tmp_cas.text in mycaslist.values:
		tmp_drugbankid=drug_element.find('drugbank-id')
		if  not 'primary' in tmp_drugbankid.keys():
			raise Exception('wrong id!',tmp_cas.text)
		tmp_name=drug_element.find('name')
		tmp_druginter=drug_element.find('drug-interactions')
		a=ET.Element('drug')
		a.append(tmp_cas)
		a.append(tmp_name)
		a.append(tmp_drugbankid)
		a.append(tmp_druginter)
		newroot.append(a)
		#root[i].append(tmp_drugbankid)
		#root[i].append(tmp_name)
		#root[i].append(tmp_cas)
		#root[i].append(tmp_druginter)
	i+=1
	print '[*]Process ',1.0*i/len(root)
newtree.write('2.xml')


