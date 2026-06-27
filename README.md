# MEMIQ

Jogo da memoria estilo Genius feito em Godot para Android.

## Modos

- Aventura: progressao por fase com XP, nivel e recompensas desbloqueaveis.
- Infinito: sequencia infinita que acelera aos poucos e possui recorde proprio.
- Recorde do Infinito, progresso da Aventura, conquistas e recompensas salvos localmente em `user://memiq_scores.cfg`.
- Conquistas offline com requisitos visiveis no menu.
- Recompensas da Aventura incluem novos fundos e novos estilos do circulo Genius.

## Visual

- Tema escuro.
- Tela inicial com `assets/anchorlab.png`, centralizada e adaptada ao tamanho do dispositivo.
- Tabuleiro circular inspirado no Genius classico.
- Iluminacao RGB animada ao redor do tabuleiro.
- Menus com fundo neon animado, botoes luminosos e listas rolaveis.
- Layout responsivo para celular e desktop, com escala dinamica de tabuleiro, botoes e fontes.
- Menu principal minimalista com apenas `AVENTURA` e `INFINITO`.
- Logo `MEMIQ` no topo do menu, modos na parte inferior e acesso a conquistas abaixo dos modos.
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
