from os import environ

from django.conf import settings
from django.core.wsgi import get_wsgi_application
from django.views.generic import View
from django.http import JsonResponse
from django.urls import path

from ytdl_hook import get_info_for

settings.configure(
    DEBUG=environ.get('DEBUG'),
    ALLOWED_HOSTS=['*'],
    ROOT_URLCONF=__name__,
    CACHES={
        'default': {
            'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
            'TIMEOUT': 60 * 60 * 2,
        }
    }
)


class VideoInfoView(View):
    def get(self, request):
        return JsonResponse(get_info_for(self.request.GET.get('url')))


urlpatterns = [
    path('', VideoInfoView.as_view()),
]


application = get_wsgi_application()


if __name__ == '__main__':
    import sys

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)

