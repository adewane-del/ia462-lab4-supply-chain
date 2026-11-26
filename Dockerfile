# IA 462 Lab 4 - digest-pinned base image (Week 8 slide: pin, don't float)
FROM python:3.11-slim@sha256:61e01f72680f86a5279ad510818ab7b2ee9f049822589d4e34e33e044360356c

LABEL maintainer="student@emich.edu"
LABEL description="IA 462 Lab 4 - Supply-Chain-Hardened App"

# Patch OS package flagged by Trivy (libzstd1 CVE fix)
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends libzstd1 && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd --system appgroup && \
    useradd  --system --gid appgroup --home /app --shell /usr/sbin/nologin appuser

WORKDIR /app
COPY --chown=appuser:appgroup requirements.lock ./requirements.txt
# Remove build-only tools (their bundled copies of jaraco.context/wheel were flagged)
RUN pip install --no-cache-dir --require-hashes -r requirements.txt && \
    pip uninstall -y setuptools wheel
COPY --chown=appuser:appgroup app/ ./app/

USER appuser
EXPOSE 5000
CMD ["python3", "app/app.py"]
