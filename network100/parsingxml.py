#encoding='UTF-8'
#parse XML
import xml.etree.ElementTree as ET
with open('1.xml','r') as f:
	fread=f.read()
tree=ET.fromstring(fread)


