#coding=utf-8

from django.conf.urls import patterns, include, url
from server.views import *

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'sudoku.views.home', name='home'),
    # url(r'^sudoku/', include('sudoku.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
    # url(r'^ajax_getFromDatabase/',ajax_getFromDatabase),
    # url(r'^ajax_addtoList/',ajax_addtoList),
    url(r'^$', mainPage),
    url('^game/', gamePage),
    url(r'^add_record/', add_record),
    url(r'^get_rank_list/', get_rank_list),
    url(r'^get_total_rank_list/', get_total_rank_list),
    url(r'^my-soap-service/service', 'server.views.my_soap_service'),
    url(r'^my-soap-service/service.wsdl', 'server.views.my_soap_service'),
)
