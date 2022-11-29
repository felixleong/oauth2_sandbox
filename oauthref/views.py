import json

from django.shortcuts import redirect, render
from django.urls import reverse

import requests
from authlib.integrations.django_client import OAuth

# CONF_URL = 'https://accounts.google.com/.well-known/openid-configuration'
oauth = OAuth()
oauth.register(
    name="ggauth_staging",
    # server_metadata_url=CONF_URL,
    client_kwargs={"scope": "payment introspection"},
)


def home(request):
    user = None
    token = request.session.get("token", {}).get("access_token", None)
    print(f"(II) Token = {token}")

    if token:
        resp = requests.get(
            "https://auth.dev.ggops.net/api/v2/user/me/",
            headers={"Authorization": f"Bearer {token}"},
        )
        print(f"(II) Resp status = {resp.status_code}")
        user = resp.json()

    return render(request, "home.html", context={"user": user})


def login(request):
    redirect_uri = request.build_absolute_uri(reverse("auth"))
    return oauth.ggauth_staging.authorize_redirect(request, redirect_uri)


def auth(request):
    token = oauth.ggauth_staging.authorize_access_token(request)
    request.session["token"] = token
    return redirect("/")


def logout(request):
    request.session.pop("token", None)
    return redirect("/")
