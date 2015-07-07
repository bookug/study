#coding=utf-8

from suds.client import Client

# client = Client('http://127.0.0.1:8000/my-soap-service/service/?wsdl')
client = Client('http://110.64.91.121:44443/ws?wsdl')

# print client

# client.options.cache.clear()
# result = client.service.getPlayerList(20)
result = client.service.getRank(11)
print result
# print result.Record[1].name

# print result.Record[1].username