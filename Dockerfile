# ──────────────────────────────────────────────
# STAGE 1 – BUILD  (tem o micromamba já instalado)
# ──────────────────────────────────────────────
FROM mambaorg/micromamba:1.5.7-bullseye AS builder

# onde o micromamba está
ENV PATH="/opt/conda/bin:${PATH}"

WORKDIR /build
COPY environment.full.yml .
RUN micromamba install -y -n base -f environment.full.yml \
 && micromamba clean --all --yes

# ──────────────────────────────────────────────
# STAGE 2 – RUNTIME
# ──────────────────────────────────────────────
FROM condaforge/miniforge3:23.3.1-0

ENV PATH="/opt/conda/bin:${PATH}" \
    PYTHONUNBUFFERED=1 \
    PORT=${PORT:-8000}

WORKDIR /app
COPY --from=builder /opt/conda /opt/conda

COPY backend   ./backend
COPY frontend  ./frontend
COPY start.sh  .

RUN chmod +x start.sh

EXPOSE ${PORT}
CMD ["bash", "-lc", "./start.sh"]
