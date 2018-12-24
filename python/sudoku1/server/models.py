#coding=utf-8
from django.db import models

class Rank(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=30L)
    time = models.IntegerField()
    class Meta:
        db_table = 'rank'
