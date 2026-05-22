
# Desafio de Projeto: Cluster Swarm
## DIO - Formação Docker Fundamentals

Este repositório contém a solução automatizada para a criação de um cluster **Docker Swarm** utilizando **Vagrant** e **VirtualBox**. O ambiente é composto por 3 máquinas virtuais Linux (Ubuntu 22.04), provisionadas de forma totalmente automatizada para instalar o Docker, configurar o cluster Swarm e realizar o deploy de uma infraestrutura com serviços web (Nginx) e banco de dados (MySQL) distribuídos estrategicamente entre os nós.

---

## 🛠️ Arquitetura do Cluster

O ambiente foi desenhado para simular um cenário real de alta disponibilidade e segregação de funções, estruturado da seguinte forma:

| Máquina | IP Fixo | Função no Swarm | Label do Nó | Serviço Implantado |
| :--- | :--- | :--- | :--- | :--- |
| **master** | `10.10.10.100` | Manager (Líder) | *Nenhum* | Orquestração do Cluster |
| **node1** | `10.10.10.101` | Worker | `tipo=web` | Servidor Web (**Nginx**) |
| **node2** | `10.10.10.102` | Worker | `tipo=banco` | Banco de Dados (**MySQL**) |

---

## 📂 Estrutura do Repositório

Para rodar o projeto, certifique-se de manter os seguintes arquivos na mesma pasta raiz:

* **`Vagrantfile`**: Arquivo de configuração que define o provisionamento das MVs no VirtualBox (recursos de CPU, memória, IPs estáticos e ordem de inicialização).
* **`docker.sh`**: Script executado em todas as máquinas para instalar o Docker Engine e suas dependências.
* **`master.sh`**: Script exclusivo do nó `master`. Inicializa o Swarm, gera o token de autenticação, cria o arquivo `docker-compose.yml`, aguarda a conexão dos nós, aplica os rótulos (*labels*) e faz o deploy da stack.
* **`worker.sh`**: Script executado nos nós trabalhadores (`node1` e `node2`). Ele possui uma lógica de sincronismo que aguarda o token da master ser gerado antes de tentar ingressar no cluster.

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
Antes de iniciar, você precisará ter instalado em sua máquina física:

1.  [Vagrant](https://developer.hashicorp.com/vagrant/downloads)

### Passo a Passo

1. **Clone este repositório:**
   ``
   git clone [https://github.com/SEU-USUARIO/NOME-DO-REPOSITORIO.git](https://github.com/SEU-USUARIO/NOME-DO-REPOSITORIO.git)
   cd NOME-DO-REPOSITORIO
``
    Inicie o provisionamento:
    Basta executar o comando abaixo. O Vagrant baixará a imagem base do Ubuntu (box da Bento) e configurará as três máquinas sequencialmente:
    ``
    vagrant up
   ``

    Nota: O processo pode levar alguns minutos na primeira execução dependendo da sua conexão com a internet.
    Verifique o andamento:
    O script da master possui um intervalo de segurança de 15 segundos (sleep 15) para garantir que os nós node1 e node2 concluam suas conexões antes de distribuir os serviços.

## 🔍 Validando o Ambiente

Após o terminal ser liberado e o deploy ser concluído, você pode validar o funcionamento do cluster acessando a máquina gerenciadora:

Acesse o nó Master via SSH:
```
    vagrant ssh master
```
Verifique o status dos nós do cluster:
```
   docker node ls
```    
Você deverá ver os 3 nós listados, com a master marcada como Leader.

Confirme onde os serviços foram alocados:
```
    docker stack ps minha_infra
```
O retorno deste comando mostrará o container do Nginx (web) rodando estritamente no node1 e o container do MySQL (db) rodando estritamente no node2.

Teste de Acesso Web:
Abra o navegador no seu sistema operacional físico e acesse o endereço do node1:

    [http://10.10.10.101](http://10.10.10.101)

A página padrão de boas-vindas do Nginx deverá ser exibida.

## 🛑 Comandos Úteis de Gerenciamento

Caso precise parar ou reiniciar o laboratório, utilize os comandos do Vagrant na pasta do projeto:

* Pausar as MVs (sem perder dados): vagrant halt

* Ligar as MVs novamente: vagrant up

* Destruir o laboratório por completo (limpar espaço): vagrant destroy -f

## 🎓 Conclusão e Aprendizados

Este projeto prático consolida os fundamentos abordados na Formação Docker Fundamentals da DIO, exemplificando conceitos vitais como:

* Provisionamento de infraestrutura como código (IaC) com Vagrant.

* Orquestração nativa de containers com Docker Swarm.

* Uso de restrições de implantação (placement constraints) baseadas em metadados (node labels).

* Resolução de concorrência e sincronismo em scripts de automação de redes de computadores.
