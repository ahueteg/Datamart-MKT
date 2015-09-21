# -*- coding: utf-8 -*-
from tempfile import mkstemp
from shutil import move
from os import remove, close
import re
from subprocess import call
import xml.etree.ElementTree as ET
from pandas.io.parsers import read_csv
import os

def get_time(fecha):
    timefile=r'tiempo.csv'
    df = read_csv(unicode(timefile, "utf-8"), encoding='latin-1')
    tiempo= df[df['Fecha'] == fecha]
    ix = tiempo.index[-1]
    tiempo=tiempo.loc[ix]
    return tiempo

def get_path(tiempo,path,file):
    return file.format(path, str(tiempo[u'Año_GL']), str(tiempo[u'Semana_GL']).zfill(2),str(tiempo[u'Año']), str(tiempo[u'Mes']).zfill(2),str(tiempo[u'Dia_Mes']).zfill(2))

def replace_date(file_path, subst):
    #Create temp file
    fh, abs_path = mkstemp()
    new_file = open(abs_path,'w')
    old_file = open(unicode(file_path, "utf-8"))
    for line in old_file:
        new_file.write(re.sub('\d{8}',subst,line))
    #close temp file
    new_file.close()
    close(fh)
    old_file.close()
    #Remove original file
    remove(unicode(file_path, "utf-8"))
    #Move new file
    move(abs_path, unicode(file_path, "utf-8"))

def replace_ktr(ktr,path):
    tree = ET.parse(unicode(ktr, "utf-8"))
    root = tree.getroot()
    for step in root.iter('step'):
        file=step.find('file')
        if file!=None:
            file.find('name').text=unicode(path, "utf-8")
    tree.write(unicode(ktr, "utf-8"))

dir_ktr=r'C:\Disco D\Datamart Ventas\Scripts .ktr\\'
dir_bat=r'C:\Disco D\Datamart Ventas\Scripts .bat\\'

fecha=20150920
tiempo=get_time(fecha)
file_so='{0}{1}\\Semana {2}\\{3}_{4}_{5}_QS_SellOut.txt'
file_st='{0}{1}\\Semana {2}\\{3}_{4}_{5}_QS_Inventario.txt'
path= 'Z:\Proyecto visores\Data Información Colombia\Peru\DATA Cliente\Quimica Suiza\\'
path_so= get_path(tiempo,path,file_so)
path_st= get_path(tiempo,path,file_st)

print path_so
print path_st

#if os.path.exists(unicode(path_so, "utf-8"))and os.path.exists(unicode(path_st, "utf-8")):
    #modificando ktr 4
ktr= dir_ktr + r'sell_out_quimica_suiza.ktr'
replace_ktr(ktr,path_so)
ktr= dir_ktr + r'stock_quimica_suiza.ktr'
replace_ktr(ktr,path_st)
#modificando query
#path_sql=r'D:\Python lab\update_qs_so.sql'
#replace_date(path_sql,str(tiempo[u'Fecha']))
#path_sql=r'D:\Python lab\update_qs_st.sql'
#replace_date(path_sql,str(tiempo[u'Fecha']))

#ejecutando job
call(dir_bat + r'sellout_qs_kjb.bat')
call(dir_bat + r'stock_qs_kjb.bat')
#else:
    #print "archivo no existe"