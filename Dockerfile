# ──────────────────────────────────────────────
# STAGE 1 – BUILD (tem o micromamba já instalado)
# ──────────────────────────────────────────────
FROM mambaorg/micromamba:1.5.7-bullseye AS builder

# garante que o micromamba esteja no PATH
ENV PATH="/opt/conda/bin:${PATH}"

WORKDIR /build

# copia o environment.yml
COPY environment.full.yml .

# instala as dependências e limpa caches
RUN micromamba install -y -n base -f environment.full.yml \
 && micromamba clean --all --yes

# ──────────────────────────────────────────────
# STAGE 2 – RUNTIME
# ──────────────────────────────────────────────
FROM condaforge/miniforge3:23.3.1-0

# ajusta PATH e variáveis de ambiente
ENV PATH="/opt/conda/bin:${PATH}" \
    PYTHONUNBUFFERED=1 \
    PORT=${PORT:-8000}

WORKDIR /app

# copia todo o conda do builder
COPY --from=builder /opt/conda /opt/conda

# copia o backend e frontend
COPY backend   ./backend
COPY frontend  ./frontend

# copia o entrypoint que monta UI + API
COPY entrypoint.py .

# copia o script de inicialização com permissão de execução
COPY --chmod=755 start.sh .

# expõe a porta injetada pelo Railway
EXPOSE ${PORT}

# entrypoint único
CMD ["bash","-lc","./start.sh"]
