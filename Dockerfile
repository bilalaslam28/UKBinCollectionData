FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y git chromium chromium-driver \
  && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_PATH=/usr/bin/chromedriver

RUN pip install --no-cache-dir flask gunicorn

RUN pip install --no-cache-dir \
  "git+https://github.com/robbrad/UKBinCollectionData.git"

COPY app.py .

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--timeout", "120", "app:app"]
