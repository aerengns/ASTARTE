from django.urls import path
from . import views
from rest_framework.authtoken import views as auth_views

urlpatterns = [
    path('reports/report/<int:report_id>', views.ReportDetail.as_view()),
    path('reports/farm/<int:farm_id>', views.ReportList.as_view()),
    path('farms', views.FarmList.as_view()),
    path('farms/<int:farm_id>', views.FarmDetail.as_view()),
    path('api-token-auth/', auth_views.obtain_auth_token),
    path('get_credentials/', views.GetTokenCredentials.as_view()),
    path('get_heatmap/<str:heatmap_type>', views.GetDynamicHeatmap.as_view())
]
