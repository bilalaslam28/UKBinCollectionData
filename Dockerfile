FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir flask gunicorn

RUN pip install --no-cache-dir \
  "git+https://github.com/robbrad/UKBinCollectionData.git#subdirectory=uk_bin_collection"

COPY app.py .

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--timeout", "120", "app:app"]
