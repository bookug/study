from soaplib.core import Application
from soaplib.core.server.wsgi import Application as WSGIApplication
from django.http import HttpResponse


class DjangoSoapApp(WSGIApplication):
    """
    Generic Django view for creating SOAP web services (works with soaplib 2.0)

    Based on http://djangosnippets.org/snippets/2210/
    """

    csrf_exempt = True

    def __init__(self, services, tns):
        """Create Django view for given SOAP soaplib services and tns"""

        return super(DjangoSoapApp, self).__init__(Application(services, tns))

    def __call__(self, request):
        django_response = HttpResponse()

        def start_response(status, headers):
            django_response.status_code = int(status.split(' ', 1)[0])
            for header, value in headers:
                django_response[header] = value

        response = super(DjangoSoapApp, self).__call__(request.META, start_response)
        django_response.content = '\n'.join(response)

        return django_response