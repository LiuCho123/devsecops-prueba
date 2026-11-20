FROM python:3.9-slim
WORKDIR /app
RUN pip install --no-cache-dir pipenv pip-audit
COPY Pipfile requirements.txt app.py ./
RUN pipenv install --system --skip-lock
EXPOSE 5000
CMD ["python", "app.py"]