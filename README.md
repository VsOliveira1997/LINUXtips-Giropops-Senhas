# Rodando uma aplicação flask+redis sem utilizar docker compose

## 🔧 Dockerfile

1 - Primeiro ponto é ter um dockerfile para poder buildar a imagem do aplicação. Nesse caso vou utilizar um dockerfile para o flask

```bash
  FROM python:3.10-slim

  RUN python -m pip install virtualenv
  
  RUN virtualenv giropops_env
  
  RUN . /giropops_env/bin/activate
  
  WORKDIR /app
  
  COPY . /app
  
  RUN python -m pip install --upgrade pip
  
  RUN pip install --no-cache-dir -r /app/requirements.txt
  
  ENV REDIS_HOST=*Vou explicar nos topicos a frente*
  
  EXPOSE 5000
  
  CMD ["flask" ,"run","--host=0.0.0.0"]
```

2 - Agora é só criar uma network com 
    
```bash
  docker network create <nome>
```


3 - Depois de criar a network docker vamos fazer o run da nossa imagem redis, utilizando o seguinte comando.

```bash
  docker run -d --network <nome> -p 6379:6379 redis
```

4 - Agora vamos descobrir qual o ip do nosso container redis

```bash
 docker network inspect <nome-utilizado-na-criação>
```
Quando rodar o comando aparecerá algo assim:

```bash
 [
    {
        "Name": "giro",
        "Id": "d12fdbb2782115ef5ff16c84e7973d5ecfbe88bfdd5487cce07c0c70f3094545",
        "Created": "2024-10-10T20:54:45.514223959Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.20.0.0/16",
                    "Gateway": "172.20.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "6034c16cebff7ea8777c77d62eeafa683b30579bc3359fa9e1b9cc54d4ca1439": {
                "Name": "affectionate_williams",
                "EndpointID": "404fd5735ad4466cf7ab8078fd77cc603db9fd74ab75a1a4ebbc62039e7f60d1",
                "MacAddress": "02:42:ac:14:00:02",
                "IPv4Address": "172.20.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

O que precisamos pegar nesse json é o 

```bash
   "IPv4Address": "172.20.0.2/16",
```

*No minha maquina local esse é o ip, se eu fizer o mesmo teste em outra maquina será outro ip. Então provavelmente na sua maquina será outro ip.*

Agora copia o 172.20.0.2 sem o "/16" e cola no nosso dockerfile

ENV REDIS_HOST=*Vou explicar nos topicos a frente*

```bash
  ENV REDIS_HOST=172.20.0.2
```
Salva e siga o proximo passo.

5 - Agora vamos buildar nosso Dockerfile.

```bash
  docker build -t <nome-da-sua-imagem>1.0 .
```

6 - Ultimo passo é só rodar a nossa imagem e ser feliz ;D

```bash
  docker run -d --network <nome-da-network> --name <nome-do-container> -p <porta> <nome-da-sua-imagem>
```


