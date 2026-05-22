#!/bin/bash
echo "--- Inicializando Swarm na Master ---"
docker swarm init --advertise-addr 10.10.10.100

# Disponibiliza o comando de junção na pasta compartilhada
docker swarm join-token worker | grep "docker swarm join" > /vagrant/swarm-join-command.sh
#!/bin/bash
chmod +x /vagrant/swarm-join-command.sh

cat << 'EOF' > /home/vagrant/docker-compose.yml
version: '3.8'
services:
  web:
    image: nginx:latest
    ports: ["80:80"]
    deploy:
      replicas: 1
      placement:
        constraints: [- node.labels.tipo == web] # Direcionado ao node1

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: "senha_super_segura"
      MYSQL_DATABASE: "meu_sistema"
    ports: ["3306:3306"]
    deploy:
      replicas: 1                                # Reduzido para 1 réplica
      placement:
        constraints: [- node.labels.tipo == banco] # Direcionado ao node2
EOF
chown vagrant:vagrant /home/vagrant/docker-compose.yml

echo "--- Aguardando os nós se registrarem... ---"
sleep 15 

docker node update --label-add tipo=web node1
docker node update --label-add tipo=banco node2

docker stack deploy -c /home/vagrant/docker-compose.yml web_infra
