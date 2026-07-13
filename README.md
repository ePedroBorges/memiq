# MEMIQ

Jogo da memoria estilo Genius feito em Godot para Android.

## Modos

- Infinito - Sequencia: preserva o padrao anterior e acrescenta um novo sinal a cada rodada.
- Infinito - Aleatorio: cria um novo padrao a cada rodada e aumenta tamanho e velocidade com a dificuldade.
- Recorde, progresso, conquistas, recompensas, customizacao e audio salvos localmente em `user://memiq_scores.cfg`.
- Menu principal com `INFINITO`, `CUSTOMIZACAO`, `CONQUISTAS` e `RECOMPENSAS`.
- Conquistas offline com requisitos visiveis em tela propria.
- Recompensas incluem fundos e estilos do circulo Genius.
- Durante a partida ha opcoes para continuar, reiniciar, remover audio e voltar ao menu.

## Visual

- Tema escuro.
- Tela inicial com `assets/anchorlab_studio_splash.png`, centralizada e adaptada a retrato e paisagem.
- Tabuleiro circular inspirado no Genius classico, com luzes de acerto e erro.
- Iluminacao RGB animada ao redor do tabuleiro.
- Menus com fundo neon animado, botoes luminosos e listas rolaveis.
- Layout responsivo para celular e desktop, com escala dinamica de tabuleiro, botoes e fontes.
- Android com retrato, paisagem ou rotacao automatica; Windows abre em janela horizontal 1280x720.
- A orientacao escolhida em `AJUSTES > ORIENTACAO` fica salva no aparelho e e reaplicada ao abrir o jogo.
- O layout em retrato usa uma coluna, controles e tabuleiro maiores; ao girar para paisagem as grades voltam a usar varias colunas.
- Botao/gesto Voltar do Android navega pelas telas e abre o menu durante a partida.
- Logo `MEMIQ` e opcoes mais centralizados na tela inicial.
- Fundos e estilos visuais mudam conforme recompensas desbloqueadas.
- Icone do APK em `assets/icon.png`, copiado de `base_genius/src/icon.png`.

## Android

O preset de exportacao Android esta em `export_presets.cfg` e aponta para:

```text
build/memiq.apk
```

O preset Windows gera `build/memiq-windows.exe`.

## Conta e multiplayer

- Cadastro e login usam Supabase Auth com confirmacao de email.
- `ESQUECI A SENHA` solicita o email de recuperacao pelo Supabase.
- Para publicar, configure SMTP proprio em `Authentication > Email` no painel do Supabase. O SMTP padrao e limitado e nao e adequado para usuarios finais.
- O multiplayer LAN permite criar ou entrar em uma sala por IP na mesma rede Wi-Fi. O anfitriao inicia o duelo; os dois jogadores recebem a mesma sequencia e o resultado atualiza ranking e historico.
- No Windows, o firewall pode pedir permissao na primeira sala criada. No Android, as permissoes de internet e estado da rede ja estao habilitadas no preset.

Para gerar pelo editor:

1. Abra esta pasta no Godot 4.6.
2. Instale os Android export templates, se o Godot pedir.
3. Va em `Project > Export`.
4. Selecione `Android`.
5. Clique em `Export Project`.

Pelo terminal, com o executavel do Godot no PATH:

```powershell
godot --headless --path . --export-debug Android build/memiq.apk
```
