FROM python:3.11-slim

WORKDIR /app

RUN pip install uk-bin-collection flask gunicorn

COPY app.py .

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
