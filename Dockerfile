FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y git chromium chromium-driver \
  && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_PATH=/usr/bin/chromedriver

# Clone the full repo
RUN git clone --depth 1 https://github.com/robbrad/UKBinCollectionData.git /tmp/ukbc

# Copy the actual source package directly into our app
RUN cp -r /tmp/ukbc/uk_bin_collection /app/uk_bin_collection

# Install dependencies
RUN pip install --no-cache-dir flask gunicorn requests beautifulsoup4 \
  lxml selenium webdriver-manager dateparser \
  && rm -rf /tmp/ukbc

COPY app.py .

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--timeout", "120", "app:app"]
