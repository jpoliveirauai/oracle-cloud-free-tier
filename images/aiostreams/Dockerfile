# Utiliza a imagem oficial do AIOStreams como base
FROM dyrectorio/aiostreams:latest

# Instala curl para podermos rodar o healthcheck de forma nativa
USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/list/apt/lists/*
USER node

# Define o Healthcheck para garantir que o serviço está respondendo na porta padrão (Ex: 3000)
# Ajuste a porta se você alterou a porta padrão do AIOStreams
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
  CMD curl -f http://localhost:3000/ || exit 1

EXPOSE 3000