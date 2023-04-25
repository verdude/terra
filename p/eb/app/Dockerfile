from python
workdir /app
copy app/small.pex /app
expose 8080
cmd ["./small.pex", "app:app", "-p", "8080", "--host", "0.0.0.0"]
