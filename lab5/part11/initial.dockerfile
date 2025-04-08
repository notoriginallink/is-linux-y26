FROM python:latest
COPY . /app
WORKDIR /app
RUN pip install flask
CMD ["python", "app.py"]
