# ──────────────────────────────────────────────
# STAGE 1 – BUILD  (usa micromamba para instalar todo o conda)
# ──────────────────────────────────────────────
FROM mambaorg/micromamba:1.5.7-bullseye AS builder

# ativa o base do micromamba
ENV MAMBA_DOCKERFILE_ACTIVATE=1 \
    PATH="/opt/conda/bin:${PATH}"

WORKDIR /build

# instala dependências
COPY environment.full.yml .
RUN micromamba install -y -n base -f environment.full.yml \
 && micromamba clean --all --yes

# ──────────────────────────────────────────────
# STAGE 2 – RUNTIME
# ──────────────────────────────────────────────
FROM mambaorg/micromamba:1.5.7-bullseye

ENV PATH="/opt/conda/bin:${PATH}" \
    PYTHONUNBUFFERED=1 \
    PORT=${PORT:-8000}

WORKDIR /app

# copia todo o conda do builder
COPY --from=builder /opt/conda /opt/conda

# copia código da API e do frontend
COPY backend   ./backend
COPY frontend  ./frontend

# copia o entrypoint e o script de inicialização
COPY entrypoint.py .
COPY start.sh        .

RUN chmod +x start.sh

# expõe a porta que o Railway define
EXPOSE ${PORT}

# entrypoint único: inicia a API + UI
CMD ["./start.sh"]
