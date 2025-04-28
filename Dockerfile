# ──────────────────────────────────────────────
# STAGE 1 – BUILD (micromamba já vem instalado)
# ──────────────────────────────────────────────
FROM mambaorg/micromamba:1.5.7-bullseye AS builder

ENV PATH="/opt/conda/bin:${PATH}"

WORKDIR /build

# Copia e instala as dependências do ambiente
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

# Copia o runtime do conda já preparado
COPY --from=builder /opt/conda /opt/conda

# Copia o código-fonte
COPY backend   ./backend
COPY frontend  ./frontend

# Copia o entrypoint e o script de start (já executáveis)
COPY --chmod=0755 entrypoint.py start.sh ./

# Expõe a porta em que a aplicação vai escutar
EXPOSE ${PORT}

# Usa o entrypoint para montar API + UI e rodar o Uvicorn
ENTRYPOINT ["./entrypoint.py"]