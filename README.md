# 🏢 Automação de Consulta de Boletos via WhatsApp — Condomínio Búzios

> **Problema resolvido:** Eliminar a fila de atendimento manual para emissão de segunda via de boletos em um condomínio com mais de 1.600 unidades.

## 💡 Sobre o Projeto

Desenvolvi uma solução end-to-end que permite aos **1.603 moradores** do Condomínio Búzios consultarem e receberem seus boletos instantaneamente via WhatsApp — 24 horas por dia, 7 dias por semana — apenas digitando o CPF no chat.

Antes da automação, cada consulta dependia de atendimento humano. Agora, o processo é 100% automatizado, do recebimento do CPF até o envio do link do boleto.

---

## 🛠️ Stack de Tecnologias

| Camada | Tecnologia |
|---|---|
| Infraestrutura | VPS Contabo (Debian Linux) |
| Containerização | Docker + Docker Compose |
| Orquestração de Workflow | n8n (Self-hosted) |
| Banco de Dados | PostgreSQL 16 |
| Segurança (SSL/HTTPS) | Caddy Reverse Proxy + Let's Encrypt |
| DNS Dinâmico | DuckDNS |
| Interface de Chatbot | BotConversa (WhatsApp API) |

---

## 📐 Arquitetura da Solução

```
[Morador no WhatsApp]
        │  digita o CPF
        ▼
[BotConversa]
        │  POST via Webhook
        ▼
[n8n — Orquestrador]
        │  query SQL
        ▼
[PostgreSQL — 1.603 registros]
        │  retorna nome + link do boleto
        ▼
[n8n — formata resposta]
        │  POST para API
        ▼
[BotConversa]
        │  entrega mensagem
        ▼
[Morador recebe o boleto ✅]
```

Todo o ambiente roda em containers Docker em uma VPS, com HTTPS automático gerenciado pelo Caddy.

---

## 📂 Estrutura do Repositório

```
condominio-buzios-automacao/
├── docker-compose.yml      # Infraestrutura completa (n8n + PostgreSQL + Caddy)
├── .env.example            # Variáveis de ambiente necessárias (sem senhas reais)
├── init.sql                # Script de criação e estrutura do banco de dados
├── n8n_workflow.json       # Fluxo exportado do n8n (importável)
└── README.md               # Este arquivo
```

---

## ⚙️ Como Reproduzir Este Projeto

### Pré-requisitos
- VPS com Linux (Ubuntu ou Debian)
- Docker e Docker Compose instalados
- Uma conta no [DuckDNS](https://www.duckdns.org/) para o domínio

### Passo a Passo

**1. Clone o repositório**
```bash
git clone https://github.com/seu-usuario/condominio-buzios-automacao.git
cd condominio-buzios-automacao
```

**2. Configure as variáveis de ambiente**
```bash
cp .env.example .env
nano .env   # Preencha com suas credenciais reais
```

**3. Suba os containers**
```bash
docker compose up -d
```

**4. Importe o workflow no n8n**

Acesse `https://seu-dominio.duckdns.org`, vá em **Settings → Import Workflow** e selecione o arquivo `n8n_workflow.json`.

**5. Popule o banco de dados (opcional)**
```bash
docker exec -i postgres_db psql -U $DB_USER -d $DB_NAME < init.sql
```

> O Caddy gerencia o HTTPS automaticamente via Let's Encrypt. Não é necessária nenhuma configuração manual de certificado.

---

## 🔄 Fluxo do Workflow no n8n

1. **Webhook** — Recebe o POST do BotConversa com o CPF do morador
2. **PostgreSQL** — Executa `SELECT` buscando o morador pelo CPF
3. **IF / Switch** — Trata o caso de CPF não encontrado
4. **Edit Fields** — Formata nome, unidade e link do boleto
5. **HTTP Request** — Envia a resposta formatada para a API do BotConversa

---

## 🔐 Segurança

- Senhas e credenciais gerenciadas exclusivamente via variáveis de ambiente (`.env`)
- Porta do PostgreSQL **não exposta** publicamente — acessível apenas dentro da rede Docker
- Comunicação externa protegida por **HTTPS/TLS** via Caddy + Let's Encrypt
- O arquivo `.env` está no `.gitignore` — nunca é versionado

---

## 📈 Resultado

- ✅ Atendimento automatizado 24/7 para mais de 1.600 unidades
- ✅ Zero dependência de atendimento humano para consulta de boletos
- ✅ Infraestrutura de baixo custo rodando em VPS single-node
- ✅ Dados protegidos com HTTPS e isolamento de rede Docker

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.
