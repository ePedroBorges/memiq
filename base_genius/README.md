# 🎮 Genius - Jogo da Memória

Um jogo interativo clássico de memória estilo Genius, desenvolvido como projeto de aprendizado durante o bootcamp de fullstack da DIO.

## 📚 Sobre o Projeto

Este projeto é uma implementação do clássico jogo Genius, onde o jogador deve memorizar e reproduzir uma sequência de cores que aumenta em complexidade a cada nível. O jogo testa a memória e a concentração do usuário através de uma interface visual colorida e intuitiva.

### Características

- ✨ **Interface Visual Atraente**: Cores vibrantes e design circular imersivo
- 🎯 **Progressão de Dificuldade**: A sequência aumenta a cada nível acertado
- ⏱️ **Feedback Imediato**: Efeitos visuais em tempo real ao clicar
- 🏆 **Sistema de Pontuação**: Acompanhamento do seu progresso
- 🔄 **Replay Infinito**: Jogue quantas vezes quiser

## 🛠️ Tecnologias Utilizadas

- **HTML5**: Estrutura e marcação semântica
- **CSS3**: Styling responsivo e efeitos visuais
- **JavaScript**: Lógica do jogo e interatividade
- **GitHub Copilot**: Auxílio no desenvolvimento do código

## 📁 Estrutura de Arquivos

```
jogo_da_memoria_genius/
├── index.html      # Arquivo principal HTML
├── styles.css      # Estilos CSS do jogo
├── scripts.js      # Lógica do jogo em JavaScript
└── README.md       # Este arquivo
```

## 🚀 Como Usar

1. **Abra o projeto**: Abra o arquivo `index.html` em seu navegador web preferido
2. **Inicie o jogo**: Clique em "OK" quando a mensagem de boas-vindas aparecer
3. **Memorize a sequência**: Observe a sequência de cores que piscar
4. **Reproduza**: Clique na ordem correta das cores que foram mostradas
5. **Avance de nível**: Acerte a sequência para ir para o próximo nível
6. **Game Over**: Se errar, o jogo termina e você pode começar novamente

## 🎮 Como Funciona

### Mecânica do Jogo

- O jogo começa com uma sequência de 1 cor
- A cada nível acertado, uma nova cor é adicionada à sequência
- O jogador deve clicar nas cores na ordem correta que foram mostradas
- Se o jogador errar uma cor, o jogo acaba
- A pontuação é incrementada para cada nível completado

### Cores

| Cor | Posição |
|-----|---------|
| 🟩 Verde | Superior Esquerda |
| 🟥 Vermelho | Superior Direita |
| 🟨 Amarelo | Inferior Esquerda |
| 🟦 Azul | Inferior Direita |

## 📊 Estrutura do Código

### Variáveis Principais

```javascript
let order = []           // Sequência do jogo
let clickedOrder = []    // Sequência clicada pelo jogador
let score = 0           // Pontuação atual
```

### Funções Principais

- `shuffleOrder()`: Adiciona uma nova cor à sequência e a exibe
- `lightColor()`: Anima a cor usando efeito de opacidade
- `checkOrder()`: Verifica se o jogador acertou a sequência
- `click()`: Trata o clique do jogador em uma cor
- `nextLevel()`: Avança para o próximo nível
- `gameOver()`: Encerra o jogo ao errar

## 🎓 Aprendizados

Este projeto permitiu praticar:

- Manipulação do DOM com JavaScript
- Event listeners e tratamento de eventos
- Lógica condicional e loops
- Funções e controle de escopo
- CSS Grid e Flexbox para layout
- Animações e efeitos visuais com CSS e JavaScript

## 🤝 Créditos

- **Desenvolvido por**: Pedro Borges
- **Bootcamp**: Fullstack Developer na DIO (Digital Innovation One)
- **Assistência**: GitHub Copilot
- **Data**: 2026

## 📝 Licença

Este projeto é de código aberto e está disponível para fins educacionais.

## 📮 Entre em Contato

- 🐙 [GitHub](https://github.com/pedroborges)
- 💼 [LinkedIn](https://www.linkedin.com/in/pedroborges)

---

**Divirta-se jogando! 🎮✨**
