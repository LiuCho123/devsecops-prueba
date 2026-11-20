FROM python:3.9-slim
WORKDIR /app
RUN apt-get update && apt-get install -y doxygen && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir flask==2.3.0
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]