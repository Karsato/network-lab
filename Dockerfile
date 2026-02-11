FROM gns3/gns3-server:latest
RUN apt-get update && apt-get install -y dynamips && rm -rf /var/lib/apt/lists/*
