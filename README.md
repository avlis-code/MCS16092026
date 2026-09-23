# Atividade — Provisionamento de Software

**Manutenção e Configuração de Software · Aula 07**
Instituto Federal de Brasília — Campus Taguatinga

## Objetivo

Construir um script de instalação automatizada — em **Windows (.bat)** e em **Linux (.sh)** — capaz de instalar um conjunto padrão de aplicativos em várias estações, registrando um relatório (log) de cada execução.

Este repositório contém os dois scaffolds (`provisionamento.bat` e `provisionamento.sh`) já com o roteiro em comentários — **não há código pronto**. O código, vocês montam, usando as "Peças" de referência mais abaixo.

---

## Passo 1 — Fazer o fork deste repositório

Antes de qualquer comando, cada grupo precisa da sua própria cópia deste repositório:

1. Abra a página deste repositório no GitHub.
2. Clique em **Fork** (canto superior direito).
3. Confirme — isso cria uma cópia inteira do repositório na conta (ou organização) do grupo.

**Feito isso uma única vez, por grupo** — não por estação. Todas as estações do grupo vão clonar esse mesmo fork.

---

## Passo 2 — Instalar e configurar o Git em cada estação

Isso é feito em **cada estação**, antes de qualquer outro passo — o Git não pode se autoinstalar por um script, porque é a própria ferramenta que baixa o script.

**Instalar o Git**

Windows:
```bat
winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements
```

Linux:
```bash
sudo apt update
sudo apt install -y git
```

**Configurar sua identidade** (também uma vez por estação — sem isso, o `git commit` falha com erro de identidade)
```bash
git config --global user.name "Nome do Grupo"
git config --global user.email "grupo@escola.local"
```

---

## Passo 3 — Clonar o FORK do seu grupo

Usem a URL do **fork de vocês** (feito no Passo 1) — não a do repositório original. Reparem no nome de usuário/organização na URL antes de clonar.

```bash
git clone <url-do-fork-do-seu-grupo>
cd <pasta-do-repositorio>
```

---

## Passo 4 — Montar o script, usando as Peças abaixo

Abram o scaffold correspondente ao sistema da estação (`provisionamento.bat` ou `provisionamento.sh`) e substituam cada comentário pelo código real, na ordem indicada. As peças a seguir são a referência completa — copiem e adaptem (nome do app, nome da variável).

### Peça 1 — Variáveis

Windows:
```bat
set app=htop
set LOGFILE=log.txt
echo %app%
```
Linux:
```bash
app="htop"
LOGFILE="log.txt"
echo "$app"
```

### Peça 2 — Lista de apps e o laço for

Windows:
```bat
set apps=vlc 7zip git
for %%A in (%apps%) do (
    echo %%A
)
```
Linux:
```bash
apps=(vlc 7zip git)
for app in "${apps[@]}"; do
    echo "$app"
done
```

### Peça 3 — Condicional (decidir com base no resultado)

Windows:
```bat
if !errorlevel! neq 0 (
    echo Falhou
) else (
    echo OK
)
```
Linux:
```bash
if [ $? -ne 0 ]; then
    echo "Falhou"
else
    echo "OK"
fi
```

### Peça 4 — Escrevendo no log

Windows:
```bat
echo [OK] %%A >> %LOGFILE%
echo [FALHA] %%A >> %LOGFILE%
```
Linux:
```bash
echo "[OK] $app" >> "$LOGFILE"
echo "[FALHA] $app" >> "$LOGFILE"
```

### Peça 5 — Contadores (sucesso/falha)

Windows:
```bat
set /a ok_count+=1
set /a fail_count+=1
```
Linux:
```bash
ok_count=$((ok_count+1))
fail_count=$((fail_count+1))
```
> Declarem `ok_count` e `fail_count` como `0` antes do laço começar (Peça 1) — senão a primeira soma não tem de onde partir.

### Peça 6 — Um cuidado, não uma sintaxe

Um comando que falha **não interrompe** o `for` sozinho — isso já é o comportamento padrão, em bash e em batch. A pegadinha é o oposto: **não usem `set -e`** no início do script `.sh` — isso faria o script abortar no primeiro erro, quebrando exatamente a resiliência que a atividade pede.

### Peça 7 — Verificar privilégio

Windows:
```bat
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Precisa ser Admin.
    exit /b 1
)
```
Linux:
```bash
if [ "$EUID" -ne 0 ]; then
    echo "Precisa ser root."
    exit 1
fi
```
Essa verificação entra **antes** do laço de instalação, não dentro dele.

### Peça 8 — Verificar se já está instalado (idempotência)

Windows:
```bat
winget list --id %%A -e >nul 2>&1
if %errorlevel% equ 0 (
    echo Ja instalado.
) else (
    REM instalar normalmente
)
```
Linux:
```bash
if dpkg -l | grep -qw "$app"; then
    echo "Já instalado."
else
    sudo apt install -y "$app"
fi
```
Essa verificação entra **dentro** do laço, antes de instalar.

### Peça 9 — Tentar de novo antes de desistir

Windows (não usem `goto` aqui — é instável quando aninhado dentro de outro `for`; usem um `for /L` aninhado):
```bat
set sucesso=0
for /L %%R in (1,1,2) do (
    if "!sucesso!"=="0" (
        winget install --id %%A -e --silent --accept-package-agreements --accept-source-agreements
        if !errorlevel! equ 0 set sucesso=1
    )
)
```
Linux:
```bash
t=0
ok=1
while [ $t -lt 2 ] && [ $ok -ne 0 ]; do
    sudo apt install -y "$app"
    ok=$?
    t=$((t+1))
done
```

---

### Exemplo completo montado (referência — não é a resposta dos grupos)

Isto é o resultado de juntar só as Peças 1 a 5 — o esqueleto comum a qualquer script, com apps diferentes dos usados pelos grupos. **Os dois requisitos do seu grupo (Peça 7, 8 ou 9, conforme a tabela) ainda precisam ser adicionados por vocês**, no ponto indicado pelos comentários do scaffold — este exemplo não os inclui de propósito.

Linux:
```bash
#!/bin/bash

LOGFILE="log_$(hostname).txt"
echo "Início: $(date)" > "$LOGFILE"

apps=(curl tree htopz)
ok_count=0
fail_count=0

sudo apt update

for app in "${apps[@]}"; do
    sudo apt install -y "$app"
    if [ $? -ne 0 ]; then
        echo "[FALHA] $app" >> "$LOGFILE"
        fail_count=$((fail_count+1))
    else
        echo "[OK] $app" >> "$LOGFILE"
        ok_count=$((ok_count+1))
    fi
    # Não usar "set -e" aqui em cima — o laço precisa continuar mesmo com falha.
done

echo "Sucesso: $ok_count | Falhas: $fail_count" | tee -a "$LOGFILE"
```

Windows:
```bat
@echo off
setlocal enabledelayedexpansion

set LOGFILE=log_%COMPUTERNAME%.txt
echo Inicio: %DATE% %TIME% > %LOGFILE%

set apps=Notepad++.Notepad++ Microsoft.PowerToys Microsoft.WindowsTerminalX
set ok_count=0
set fail_count=0

for %%A in (%apps%) do (
    winget install --id %%A -e --silent --accept-package-agreements --accept-source-agreements
    if !errorlevel! neq 0 (
        echo [FALHA] %%A >> %LOGFILE%
        set /a fail_count+=1
    ) else (
        echo [OK] %%A >> %LOGFILE%
        set /a ok_count+=1
    )
)

echo Sucesso: !ok_count! ^| Falhas: !fail_count! >> %LOGFILE%
```

Repare: `htopz` e `Microsoft.WindowsTerminalX` estão errados de propósito, só para mostrar o laço registrando a falha e seguindo para o próximo item — exatamente a regra comum aos três grupos, só que aqui aplicada a um exemplo neutro.

---

## Passo 5 — Preencher a lista de apps do grupo e rodar

Usem a tabela de configuração do grupo (mais abaixo) para preencher a Peça 2 com os apps corretos, e apliquem os dois requisitos do grupo nos pontos indicados pelos comentários do scaffold. Depois, rodem o script na estação — ele deve gerar um arquivo `log_<nome-da-estação>.txt`.

---

## Passo 6 — Enviar o relatório

```bash
git add log_<nome-da-estação>.txt
git commit -m "Provisionamento da estação <nome-da-estação>"
git push
```
`git add` seleciona o arquivo a ser enviado; `git commit` registra a mudança localmente, com uma mensagem explicando o que foi feito; `git push` envia para o fork do grupo no GitHub. **Repitam os Passos 5 e 6 em cada estação** sob responsabilidade do grupo — cada uma gera e envia o seu próprio log, sem conflito com as demais.

---

## Configuração do seu grupo

> Preencher/manter apenas a linha correspondente ao grupo deste fork.

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
