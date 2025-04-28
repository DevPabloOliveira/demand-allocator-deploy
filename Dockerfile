# ──────────────────────────────────────────────────────────────────────────
# STAGE 1 – BUILD (instala dependências com micromamba)
# ──────────────────────────────────────────────────────────────────────────
FROM mambaorg/micromamba:1.5.7-bullseye AS builder

# Ativa o micromamba automaticamente no PATH
ENV MAMBA_ROOT_PREFIX=/opt/conda \
    MAMBA_DOCKERFILE_ACTIVATE=1

WORKDIR /build

# Copia o seu environment.yml e instala tudo
COPY environment.full.yml .
RUN micromamba install -y -n base -f environment.full.yml \
 && micromamba clean --all --yes

# ──────────────────────────────────────────────────────────────────────────
# STAGE 2 – RUNTIME (só o runtime leve, com Python já instalado)
# ──────────────────────────────────────────────────────────────────────────
FROM mambaorg/micromamba:1.5.7-bullseye

# Define variáveis de ambiente
ENV MAMBA_ROOT_PREFIX=/opt/conda \
    PATH=/opt/conda/bin:$PATH \
    PYTHONUNBUFFERED=1 \
    PORT=${PORT:-8000}

WORKDIR /app

# Copia o ambiente já montado no builder
COPY --from=builder /opt/conda /opt/conda

# Copia o código da API e do frontend
COPY backend   ./backend
COPY frontend  ./frontend

# Copia o entrypoint que monta API + UI e dispara o Uvicorn
COPY entrypoint.py .
RUN chmod +x entrypoint.py

# Abre a porta definida em PORT
EXPOSE ${PORT}

# Ao subir, executa o entrypoint.py
CMD ["./entrypoint.py"]
