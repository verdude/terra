from python:3.11
workdir /app
copy app/small.pex /app
expose 8080
cmd ["./small.pex", "app:app", "--port", "8080", "--host", "0.0.0.0"]
