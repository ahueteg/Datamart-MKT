# -*- coding: utf-8 -*-
from tempfile import mkstemp
from shutil import move
from os import remove, close

def replace(file_path, pattern, subst):
    #Create temp file
    fh, abs_path = mkstemp()
    new_file = open(abs_path,'w')
    old_file = open(file_path)
    for line in old_file:
        new_file.write(line.replace(pattern, subst))
    #close temp file
    new_file.close()
    close(fh)
    old_file.close()
    #Remove original file
    remove(file_path)
    #Move new file
    move(abs_path, file_path)

path=r'Z:\Proyecto visores\Data Información Colombia\Peru\DATA Cliente\KeyMark\2015\Semana 21\Semana 21\2015_21_KeyMark_Inventario.txt'
replace(unicode(path, "utf-8"),'	','|')
