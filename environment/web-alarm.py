#!/usr/bin/python2
import web

urls = ('/', 'index')

class index:
    def GET(self):
        return "Hello, world!"

    def POST(self):
        data = web.data()
        print
        print 'HTTP POST RECEIVED:'
        print data
        print
        if 'CRITICAL' in data:
               print "Alert Received: Critical Alarm received"
        elif 'WARN' in data:
               print "Alert Received: Warm Alarm received"
        elif 'INFO' in data:
               print "Alert Received: Info Alarm received"
        elif 'OK' in data:
               print "Alert Received: Alarm cleared"
	else:
	       print "Alert Received but I  don't understand the data"

        return #'OK'



if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()
