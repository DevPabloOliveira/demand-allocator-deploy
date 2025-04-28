# === STAGE 1: BUILD ===
FROM condaforge/miniforge3:23.3.1-0 AS builder

# garante que /opt/conda/bin (onde está o micromamba) fique no PATH
ENV PATH=/opt/conda/bin:$PATH

WORKDIR /app

# copia o yml do seu ambiente
COPY environment.full.yml .

# instala tudo e limpa caches
RUN micromamba install -y -f environment.full.yml \
 && micromamba clean --all --yes

# === STAGE 2: RUNTIME ===
FROM condaforge/miniforge3:23.3.1-0

# de novo, garantir PATH
ENV PATH=/opt/conda/bin:$PATH \
    PYTHONUNBUFFERED=1 \
    PORT=${PORT:-8000}

WORKDIR /app

# copia TODO o conda (*) do builder
COPY --from=builder /opt/conda /opt/conda

# copia seu código
COPY backend ./backend
COPY start-backend.sh .

# torna seu script executável
RUN chmod +x start-backend.sh

# expõe a porta que o Railway injeta
EXPOSE ${PORT}

# entrypoint
CMD ["bash", "-lc", "./start-backend.sh"]
