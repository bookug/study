#coding=utf-8
from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.template import Context
from django.views.decorators.csrf import csrf_exempt
import simplejson
from server.models import Rank
from django.template import RequestContext
from server.soap import DjangoSoapApp
from soaplib.core.model.primitive import Boolean, String, Integer
from soaplib.core.service import DefinitionBase, rpc
from soaplib.core.model.clazz import Array, ClassModel
from suds.client import Client

def mainPage(request):
    return render_to_response('main.html', context_instance=RequestContext(request))    

def gamePage(request):
    return render_to_response('sudoku.html', context_instance=RequestContext(request))    

@csrf_exempt
def add_record(request):
    if request.method == 'POST':
        name = request.POST.get('name', '')
        time = request.POST.get('time', '')
        # print name
        # print time
        time = int(time)
        rank_list = Rank.objects.all().order_by('time')
        local_rank = 1
        for record in rank_list:
            if record.time < time:
                local_rank += 1
        try:
            client = Client('http://110.64.91.121:44443/ws?wsdl', timeout=2)
            remove_rank = client.service.getRank(time)
        except:
            remove_rank = 0
        newRank = Rank(name=name, time=time)
        newRank.save()
        json = {'state':'1', 'content':'成功提交'}
    else:
        json = {'state':'0', 'content':'无法储存到数据库'}
    if remove_rank:
        json = {'state':'1', 'content':'成功提交', 'local_rank':local_rank, 'total_rank':remove_rank + local_rank}
    else:
        json = {'state':'1', 'content':'成功提交', 'local_rank':local_rank}
    JsonData = simplejson.dumps(json, ensure_ascii=False)
    return HttpResponse(JsonData)

@csrf_exempt
def get_rank_list(request):
    rank_list = Rank.objects.all().order_by('time')[0:20]
    return_list = []
    for row in rank_list:
        return_list.append({"name":row.name, "time":row.time})
    json = {"state":"1", "rank_list":return_list}
    return HttpResponse(simplejson.dumps(json, ensure_ascii=False))

@csrf_exempt
def get_total_rank_list(request):
    try:
        local_rank_list = Rank.objects.all().order_by('time')[0:20]
        client = Client('http://110.64.91.121:44443/ws?wsdl', timeout=2)
        # client.options.cache.clear()
        result = client.service.getPlayerList(20)
        remove_rank_list = result
        return_list = []
        local_rank_list_index = 0
        remove_rank_list_index = 0
        for i in range(0,20):
            if local_rank_list_index < len(local_rank_list) and remove_rank_list_index < len(remove_rank_list):
                if(local_rank_list[local_rank_list_index] < remove_rank_list[remove_rank_list_index]):
                    return_list.append({"name":local_rank_list[local_rank_list_index].name, "time":local_rank_list[local_rank_list_index].time})
                    local_rank_list_index += 1
                else:
                    return_list.append({"name":remove_rank_list[remove_rank_list_index].name, "time":remove_rank_list[remove_rank_list_index].time})
                    remove_rank_list_index += 1
            elif local_rank_list_index >= len(local_rank_list) and remove_rank_list_index < len(remove_rank_list):
                return_list.append({"name":remove_rank_list[remove_rank_list_index].name, "time":remove_rank_list[remove_rank_list_index].time})
                remove_rank_list_index += 1
            elif local_rank_list_index < len(local_rank_list) and remove_rank_list_index >= len(remove_rank_list):
                return_list.append({"name":local_rank_list[local_rank_list_index].name, "time":local_rank_list[local_rank_list_index].time})
                local_rank_list_index += 1
        json = {"state":"1", "rank_list":return_list}
    except:
        json = {"state":"0"}
    return HttpResponse(simplejson.dumps(json, ensure_ascii=False))


class Record(ClassModel):
    __namespace__ = "record"
    time = Integer
    name = String

class MySOAPService(DefinitionBase):
    # @rpc(String, String, _returns=Boolean)
    # def Test(self, f1, f2):
    #     return True
    # @rpc(String, _returns=String)
    # def HelloWorld(self, name):
    #     return 'Hello %s!' %name
    # @rpc(Integer, _returns=Array(String))
    # def getTopList(self, number):
    #     top_list = ['dudu','cc','aa']
    #     return top_list
    @rpc(Integer, _returns=Array(Record))
    def getTopList(self, number):
        top_list = []
        rank_list = Rank.objects.all().order_by('time')[0:number]
        for rank in rank_list:
            record = Record()
            record.name = rank.name
            record.time = rank.time
            top_list.append(record)
        return top_list

    @rpc(Integer, _returns=Integer)
    def getRank(self, time):
        rank_list = Rank.objects.all().order_by('time')
        rank = 1
        for record in rank_list:
            if record.time < time:
                rank += 1
        return rank

my_soap_service = DjangoSoapApp([MySOAPService], 'bin')
