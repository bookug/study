#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = "Runner Coder"
from django.http import HttpResponse,Http404
from django.shortcuts import render_to_response
import os
import xueba.settings

#获取题目信息
def GetTitleData(num):
    dataList = []
    mfile = open("./shudu/m/%s.txt"%(num),'r')
    for line in mfile.readlines():
        aList = line.replace("\n",'').split("\t")
        dataList.append(aList)
    return dataList

#获取答案
def GetAnswer(num):
    dataList = []
    mfile = open("./shudu/answer/a%s.txt"%(num),'r')

    for line in mfile.readlines():
        aList = line.replace("\n",'').split("\t")
        dataList.extend(aList)
    return [int(d) for d in dataList]

def index(req):
    t = req.REQUEST.get('t')
    dataList = GetTitleData(t)

    #dataList = os.getcwd()
    return render_to_response("./shudu/index.html",{"dataList":dataList,'titleNum':t,"nextTitleNum":int(t) + 1,"beforeTitleNum":int(t) - 1})#HttpResponse(dataList)
    #return HttpResponse(xueba.settings.TEMPLATE_DIRS)

def getDataList(req):
    content = ""
    d = req.REQUEST.get('dataList')
    titleNum = req.REQUEST.get("titleNum")
    answerDataList = GetAnswer(titleNum)
    dataList = [int(data) for data in d.split(",")]
    if dataList == answerDataList:
        content = "success"
    print dataList
    print answerDataList
    return HttpResponse(content)
