#!/usr/bin/env python
# -*- coding: utf-8 -*-

def GetTitleData(num):
    dataList = []
    mfile = open("./m/%s.txt"%(num),'r')
    for line in mfile.readlines():
        aList = line.replace("\n",'').split("\t")
        dataList.append(aList)
    return dataList

if __name__ == "__main__":
    print GetTitleData(1)