# replaced python:3.11-slim : Debian-based image (several CVEs caught by Trivy)
FROM python:3.11-alpine 

WORKDIR /app

COPY requirements.txt .

# upgrades alpine packages to latest versions (to fix zlib vuln)
RUN apk update && apk upgrade

# upgrade setuptools - contains vulns in packages (jaraco.context & wheel)
RUN pip install --upgrade pip setuptools wheel

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py"]