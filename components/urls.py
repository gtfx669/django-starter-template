from django.urls import path, include
    urlpatterns = [
        path('components/', include('components.urls')),
    ]