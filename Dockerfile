FROM condaforge/miniforge3:23.3.1-0

WORKDIR /app

# — copie o conda + pacotes já instalados no stage de build
COPY --from=builder /opt/conda /opt/conda
ENV PATH=/opt/conda/bin:$PATH \
    PYTHONUNBUFFERED=1 \
    PORT=${PORT:-8000}

COPY backend ./backend

EXPOSE ${PORT}

# use nproc para gerar dinamicamente o número de workers = número de núcleos
CMD ["bash","-lc","uvicorn backend.app.main:app --host 0.0.0.0 --port ${PORT} --workers $(nproc)"]
