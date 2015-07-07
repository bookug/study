from django.conf.urls import patterns, include, url
import shudu.views
# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'xueba.views.home', name='home'),
    # url(r'^xueba/', include('xueba.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    url(r'^index$',shudu.views.index),
    url(r'^getDataList$',shudu.views.getDataList),
    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
)
