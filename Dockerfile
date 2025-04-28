# syntax=docker/dockerfile:1

####################################################
# Stage 1: builder — instala o conda + dependências
####################################################
FROM condaforge/miniforge3:23.3.1-0 AS builder

WORKDIR /app

# Copia só o arquivo de ambiente e instala tudo via micromamba
COPY environment.full.yml .
RUN micromamba install -y -f environment.full.yml \
    && micromamba clean --all --yes

# (Opcional) aqui você poderia copiar e pré-construir assets do frontend
# COPY frontend/package.json frontend/yarn.lock ./
# RUN yarn install && yarn build

####################################################
# Stage 2: runtime — só o que precisamos para rodar
####################################################
FROM condaforge/miniforge3:23.3.1-0

# Puxa o conda já instalado no estágio “builder”
COPY --from=builder /opt/conda /opt/conda

# Ajusta o PATH e outras variáveis
ENV PATH=/opt/conda/bin:$PATH \
    PYTHONUNBUFFERED=1 \
    PORT=${PORT:-8000}

WORKDIR /app

# Copia só o backend (e o script de startup)
COPY backend ./backend
COPY start-backend.sh .

# Garante permissão de execução
RUN chmod +x start-backend.sh

# Expõe a porta que o Railway vai lhe passar via $PORT
EXPOSE ${PORT}

# Comando final para subir o Uvicorn usando todos os cores disponíveis
# (nproc retorna número de cores)
CMD ["bash","-lc","./start-backend.sh"]
