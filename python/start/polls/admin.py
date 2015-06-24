from django.contrib import admin

# Register your models here.
from polls.models import Poll, Choice

class ChoiceInline(admin.TabularInline):
	model = Choice
	extra = 3

class PollAdmin(admin.ModelAdmin):
	fields = ['pub_date', 'question']
	#fieldsets = [
	#		(None,					{'fields':['question']}),
	#		('Data information',	{'fileds':['pub_date'], 'classes':['collapse']}),
	#		]
	list_display = ('question', 'pub_date', 'was_published_recently')
	list_filter = ['pub_date']
	search_fields = ['question']
	inlines = [ChoiceInline]

admin.site.register(Poll, PollAdmin)
#admin.site.register(Choice)

