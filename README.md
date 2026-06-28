# MEMIQ

Jogo da memoria estilo Genius feito em Godot para Android.

## Modo

- Infinito: sequencia infinita que acelera aos poucos, com recorde, XP, niveis e recompensas.
- Recorde, progresso, conquistas, recompensas, customizacao e audio salvos localmente em `user://memiq_scores.cfg`.
- Menu principal com `INFINITO`, `CUSTOMIZACAO`, `CONQUISTAS` e `RECOMPENSAS`.
- Conquistas offline com requisitos visiveis em tela propria.
- Recompensas incluem fundos e estilos do circulo Genius.
- Durante a partida ha opcoes para remover audio e voltar ao menu.

## Visual

- Tema escuro.
- Tela inicial com `assets/anchorlab.png`, centralizada e adaptada ao tamanho do dispositivo.
- Tabuleiro circular inspirado no Genius classico, com luzes de acerto e erro.
- Iluminacao RGB animada ao redor do tabuleiro.
- Menus com fundo neon animado, botoes luminosos e listas rolaveis.
- Layout responsivo para celular e desktop, com escala dinamica de tabuleiro, botoes e fontes.
- Logo `MEMIQ` e opcoes mais centralizados na tela inicial.
- Fundos e estilos visuais mudam conforme recompensas desbloqueadas.
- Icone do APK em `assets/icon.png`, copiado de `base_genius/src/icon.png`.

## Android

O preset de exportacao Android esta em `export_presets.cfg` e aponta para:

```text
build/memiq.apk
```

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
