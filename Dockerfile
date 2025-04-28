# ---------- STAGE 1  :  build do ambiente -----------------
    FROM condaforge/miniforge3:23.3.1-0 AS builder
    ENV PATH=/opt/conda/bin:$PATH
    WORKDIR /build
    
    COPY environment.full.yml .
    RUN micromamba install -y -f environment.full.yml \
     && micromamba clean --all --yes
    
    # ---------- STAGE 2  :  imagem de runtime -----------------
    FROM condaforge/miniforge3:23.3.1-0
    ENV PATH=/opt/conda/bin:$PATH \
        PYTHONUNBUFFERED=1 \
        PORT=${PORT:-8000}
    
    WORKDIR /app
    
    # copia todo o env já pronto
    COPY --from=builder /opt/conda /opt/conda
    
    # copia **backend e frontend**
    COPY backend   ./backend
    COPY frontend  ./frontend
    
    # script de arranque
    COPY start.sh .
    RUN chmod +x start.sh
    
    # deixa o Python encontrar os dois pacotes
    ENV PYTHONPATH=/app/backend:/app/frontend
    
    EXPOSE ${PORT}
    CMD ["bash","./start.sh"]
    