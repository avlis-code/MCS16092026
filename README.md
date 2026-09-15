# Atividade — Provisionamento de Software

**Manutenção e Configuração de Software · Aula 07**
Instituto Federal de Brasília — Campus Taguatinga
Técnico em Manutenção em Suporte em Informática

## Objetivo

Construir um script de instalação automatizada — em **Windows (.bat)** e em **Linux (.sh)** — capaz de instalar um conjunto padrão de aplicativos em várias estações, registrando um relatório (log) de cada execução.

Este repositório contém os dois scaffolds (`provisionamento.bat` e `provisionamento.sh`) já com o roteiro em comentários — **não há código pronto**. O código, vocês montam, usando as "Peças" apresentadas em aula.

---

## Antes de começar: instalar e configurar o Git

Isso é feito **uma vez, em cada estação**, antes de qualquer outro passo — o Git não pode se autoinstalar por um script, porque é a própria ferramenta que baixa o script.

**1. Instalar o Git**

Windows:
```bat
winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements
```

Linux:
```bash
sudo apt update
sudo apt install -y git
```

**2. Configurar sua identidade** (também uma vez por estação — sem isso, o `git commit` falha)
```bash
git config --global user.name "Nome do Grupo"
git config --global user.email "grupo@escola.local"
```

---

## Passo a passo da atividade

1.**Faça um Fork deste repositório** utilizando sua conta do GitHub
2. **Clone este repositório** em cada estação sob responsabilidade do grupo:
   ```bash
   git clone <url-do-seu-repositório>
   cd <pasta-do-repositório>
   ```
3. **Abra o scaffold correspondente ao sistema da estação** (`provisionamento.bat` ou `provisionamento.sh`) e monte o script, substituindo cada comentário pelo código real — usando as Peças vistas em aula (variáveis, laço, condicional, log, contadores, e os dois requisitos do seu grupo).
4. **Preencha a lista de apps** do seu grupo (veja a tabela abaixo).
5. **Rode o script** na estação. Ele deve gerar um arquivo `log_<nome-da-estação>.txt`.
6. **Envie o relatório** para este repositório:
   ```bash
   git add log_<nome-da-estação>.txt
   git commit -m "Provisionamento da estação <nome-da-estação>"
   git push
   ```
7. **Repita os passos 4 e 5 em cada estação** sob responsabilidade do grupo — cada uma gera e envia o seu próprio log, sem conflito com as demais.

---

## Configuração do seu grupo

> Preencher com a linha correspondente ao grupo deste repositório.

| Grupo | Apps exigidos | Requisito 1 | Requisito 2 |
|---|---|---|---|
| A | VLC, 7-Zip, GIMP | Idempotência — não reinstalar o que já está presente | Nova tentativa — tentar de novo antes de desistir |
| B | VLC, 7-Zip, LibreOffice | Verificar privilégio — recusar rodar sem admin/root | Nova tentativa — tentar de novo antes de desistir |
| C | GIMP, LibreOffice, 7-Zip | Idempotência — não reinstalar o que já está presente | Verificar privilégio — recusar rodar sem admin/root |

**Regra comum aos três grupos:** um dos apps da lista tem o identificador (winget) ou nome de pacote (apt) errado, de propósito. O script precisa registrar a falha e seguir para o próximo app — nunca travar por completo.

---

## Como provar que cada requisito foi cumprido

Não basta o código existir no script — o log final (ou uma captura de tela do terminal) precisa mostrar o comportamento acontecendo de verdade.

O padrão vale para qualquer requisito: **provoquem deliberadamente** a situação que testa a regra, rodem o script, e guardem a evidência (uma linha do log, ou uma captura de tela do momento em que aconteceu). Cada grupo decide, para os seus dois requisitos, qual é a melhor forma de demonstrar isso.

---

## Estrutura esperada do repositório, ao final

```
.
├── README.md
├── provisionamento.bat
├── provisionamento.sh
├── log_<estacao-1>.txt
├── log_<estacao-2>.txt
└── ...
```

## Dúvidas

Qualquer erro inesperado durante a montagem ou execução do script — chamem o professor antes de tentar resolver sozinhos.
