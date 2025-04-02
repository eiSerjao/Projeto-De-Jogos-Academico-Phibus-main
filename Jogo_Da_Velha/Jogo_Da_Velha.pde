// Jogo da Velha (Tic Tac Toe) em Processing
// Versão final com reset de contadores ao voltar ao menu

final int TAMANHO = 600;
final int TAM_CELULA = TAMANHO / 3;
final int MARGEM = 50;

char[][] tabuleiro = new char[3][3];
boolean vezX = true;
boolean jogoAtivo = false;
boolean vsComputador;
boolean telaInicial = true;
boolean resultadoProcessado = false;
int vitoriasX = 0;
int vitoriasO = 0;
int empates = 0;

void setup() {
  size(600, 700);
  textSize(20);
  textAlign(CENTER, CENTER);
  reiniciarJogo();
}

void draw() {
  background(255);
  
  if (telaInicial) {
    desenharTelaInicial();
  } else {
    desenharJogo();
  }
}

void desenharTelaInicial() {
  fill(0);
  textSize(32);
  text("Jogo da Velha", width/2, 100);
  textSize(24);
  text("Selecione o modo de jogo:", width/2, 180);
  
  fill(200);
  rect(width/2 - 150, 250, 300, 60, 10);
  fill(0);
  text("1 Jogador (vs Computador)", width/2, 280);
  
  fill(200);
  rect(width/2 - 150, 350, 300, 60, 10);
  fill(0);
  text("2 Jogadores", width/2, 380);
}

void desenharJogo() {
  // Desenha o placar
  fill(0);
  text("X: " + vitoriasX + "  O: " + vitoriasO + "  Empates: " + empates, width/2, 15);
  
  // Desenha o tabuleiro
  strokeWeight(4);
  line(TAM_CELULA, MARGEM, TAM_CELULA, TAMANHO - MARGEM);
  line(TAM_CELULA * 2, MARGEM, TAM_CELULA * 2, TAMANHO - MARGEM);
  line(MARGEM, TAM_CELULA, TAMANHO - MARGEM, TAM_CELULA);
  line(MARGEM, TAM_CELULA * 2, TAMANHO - MARGEM, TAM_CELULA * 2);
  
  // Desenha os X e O no tabuleiro
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      float x = j * TAM_CELULA + TAM_CELULA / 2;
      float y = i * TAM_CELULA + TAM_CELULA / 2;
      
      if (tabuleiro[i][j] == 'X') {
        drawX(x, y);
      } else if (tabuleiro[i][j] == 'O') {
        drawO(x, y);
      }
    }
  }
  
  // Verifica se há um vencedor ou empate
  char vencedor = verificarVencedor();
  boolean jogoTerminou = (vencedor != ' ' || tabuleiroCompleto());
  
  if (jogoTerminou && jogoAtivo) {
    jogoAtivo = false;
    
    if (!resultadoProcessado) {
      if (vencedor == 'X') {
        vitoriasX++;
      } else if (vencedor == 'O') {
        vitoriasO++;
      } else {
        empates++;
      }
      resultadoProcessado = true;
    }
  }
  
  // Exibe mensagem de resultado se o jogo terminou
  if (!jogoAtivo) {
    fill(255, 200);
    rect(MARGEM, TAMANHO/2 - 30, TAMANHO - 2*MARGEM, 60);
    fill(0);
    String mensagem = "";
    if (vencedor == 'X') {
      mensagem = "X venceu!";
    } else if (vencedor == 'O') {
      mensagem = "O venceu!";
    } else {
      mensagem = "Empate!";
    }
    text(mensagem, TAMANHO/2, TAMANHO/2);
    
    // Botão para reiniciar
    fill(200);
    rect(TAMANHO/2 - 50, TAMANHO/2 + 50, 100, 40);
    fill(0);
    text("Reiniciar", TAMANHO/2, TAMANHO/2 + 70);
    
    // Botão para voltar ao menu
    fill(200);
    rect(TAMANHO/2 - 50, TAMANHO/2 + 100, 100, 40);
    fill(0);
    text("Menu", TAMANHO/2, TAMANHO/2 + 120);
  }
  
  // Se for vez do computador e o jogo está ativo
  if (vsComputador && !vezX && jogoAtivo) {
    jogadaComputador();
    vezX = true;
  }
}

void mousePressed() {
  if (telaInicial) {
    // Verifica clique na tela inicial
    if (mouseX >= width/2 - 150 && mouseX <= width/2 + 150) {
      if (mouseY >= 250 && mouseY <= 310) {
        // Modo 1 jogador
        vsComputador = true;
        telaInicial = false;
        jogoAtivo = true;
        reiniciarJogo();
      } else if (mouseY >= 350 && mouseY <= 410) {
        // Modo 2 jogadores
        vsComputador = false;
        telaInicial = false;
        jogoAtivo = true;
        reiniciarJogo();
      }
    }
  } else {
    // Verifica clique no botão de reiniciar
    if (!jogoAtivo && mouseX >= TAMANHO/2 - 50 && mouseX <= TAMANHO/2 + 50) {
      if (mouseY >= TAMANHO/2 + 50 && mouseY <= TAMANHO/2 + 90) {
        reiniciarJogo();
        return;
      } else if (mouseY >= TAMANHO/2 + 100 && mouseY <= TAMANHO/2 + 140) {
        // Voltar ao menu - Zera os contadores
        resetarContadores();
        telaInicial = true;
        return;
      }
    }
    
    // Se o jogo não está ativo, não processa cliques no tabuleiro
    if (!jogoAtivo) return;
    
    // Verifica clique no tabuleiro
    if (mouseX >= MARGEM && mouseX < TAMANHO - MARGEM &&
        mouseY >= MARGEM && mouseY < TAMANHO - MARGEM) {
      
      int coluna = (mouseX - MARGEM) / TAM_CELULA;
      int linha = (mouseY - MARGEM) / TAM_CELULA;
      
      // Verifica se a célula está vazia
      if (tabuleiro[linha][coluna] == ' ') {
        tabuleiro[linha][coluna] = vezX ? 'X' : 'O';
        vezX = !vezX;
      }
    }
  }
}

// Função para resetar os contadores
void resetarContadores() {
  vitoriasX = 0;
  vitoriasO = 0;
  empates = 0;
}

void drawX(float x, float y) {
  stroke(255, 0, 0);
  line(x - TAM_CELULA/3, y - TAM_CELULA/3, x + TAM_CELULA/3, y + TAM_CELULA/3);
  line(x + TAM_CELULA/3, y - TAM_CELULA/3, x - TAM_CELULA/3, y + TAM_CELULA/3);
  stroke(0);
}

void drawO(float x, float y) {
  stroke(0, 0, 255);
  noFill();
  ellipse(x, y, TAM_CELULA/1.5, TAM_CELULA/1.5);
  stroke(0);
}

char verificarVencedor() {
  // Verifica linhas
  for (int i = 0; i < 3; i++) {
    if (tabuleiro[i][0] != ' ' && tabuleiro[i][0] == tabuleiro[i][1] && tabuleiro[i][1] == tabuleiro[i][2]) {
      return tabuleiro[i][0];
    }
  }
  
  // Verifica colunas
  for (int j = 0; j < 3; j++) {
    if (tabuleiro[0][j] != ' ' && tabuleiro[0][j] == tabuleiro[1][j] && tabuleiro[1][j] == tabuleiro[2][j]) {
      return tabuleiro[0][j];
    }
  }
  
  // Verifica diagonais
  if (tabuleiro[0][0] != ' ' && tabuleiro[0][0] == tabuleiro[1][1] && tabuleiro[1][1] == tabuleiro[2][2]) {
    return tabuleiro[0][0];
  }
  if (tabuleiro[0][2] != ' ' && tabuleiro[0][2] == tabuleiro[1][1] && tabuleiro[1][1] == tabuleiro[2][0]) {
    return tabuleiro[0][2];
  }
  
  return ' '; // Sem vencedor
}

boolean tabuleiroCompleto() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == ' ') {
        return false;
      }
    }
  }
  return true;
}

void reiniciarJogo() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      tabuleiro[i][j] = ' ';
    }
  }
  vezX = true;
  jogoAtivo = true;
  resultadoProcessado = false;
}

void jogadaComputador() {
  // Primeiro verifica se pode vencer
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == ' ') {
        tabuleiro[i][j] = 'O';
        if (verificarVencedor() == 'O') {
          return;
        }
        tabuleiro[i][j] = ' ';
      }
    }
  }
  
  // Depois verifica se pode bloquear o jogador
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == ' ') {
        tabuleiro[i][j] = 'X';
        if (verificarVencedor() == 'X') {
          tabuleiro[i][j] = 'O';
          return;
        }
        tabuleiro[i][j] = ' ';
      }
    }
  }
  
  // Tenta jogar no centro
  if (tabuleiro[1][1] == ' ') {
    tabuleiro[1][1] = 'O';
    return;
  }
  
  // Tenta jogar em um canto vazio
  int[][] cantos = {{0, 0}, {0, 2}, {2, 0}, {2, 2}};
  for (int[] canto : cantos) {
    if (tabuleiro[canto[0]][canto[1]] == ' ') {
      tabuleiro[canto[0]][canto[1]] = 'O';
      return;
    }
  }
  
  // Joga em qualquer posição vazia
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == ' ') {
        tabuleiro[i][j] = 'O';
        return;
      }
    }
  }
}
