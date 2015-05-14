#! /usr/bin/python 
#coding=utf-8

from Tkinter import *
import datetime
import time

root = Tk()
root.title(unicode('chating with XXX','eucgb2312_cn'))

#send-button event
def sendmessage():
	#add one line above chating-content, show sender and time 
	msgcontent = unicode('I:','eucgb2312_cn') + time.strftime("%Y-%m-%d %H:%M:%S",time.localtime()) + '\n '
	text_msglist.insert(END, msgcontent, 'green')
	text_msglist.insert(END, text_msg.get('0.0', END))
	text_msg.delete('0.0', END)

#create several frames as container
frame_left_top = Frame(width=380, height=270, bg='white')
frame_left_center = Frame(width=380, height=100, bg='white')
frame_left_bottom = Frame(width=380, height=20)
frame_right = Frame(width=170, height=400, bg='white')

#create elements needed
text_msglist    = Text(frame_left_top)
text_msg      = Text(frame_left_center);
button_sendmsg   = Button(frame_left_bottom, text=unicode('send','eucgb2312_cn'), command=sendmessage)

#create a green tag
text_msglist.tag_config('green', foreground='#008B00')

#use grid to set the position of containers
frame_left_top.grid(row=0, column=0, padx=2, pady=5)
frame_left_center.grid(row=1, column=0, padx=2, pady=5)
frame_left_bottom.grid(row=2, column=0)
frame_right.grid(row=0, column=1, rowspan=3, padx=4, pady=5)
frame_left_top.grid_propagate(0)
frame_left_center.grid_propagate(0)
frame_left_bottom.grid_propagate(0)

#put elements into frame
text_msglist.grid()
text_msg.grid()
button_sendmsg.grid(sticky=E)

#main event loop
root.mainloop()

