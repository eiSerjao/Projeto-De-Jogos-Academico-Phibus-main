import java.util.Collections;
import java.util.ArrayList;

int screen = 0; // 0 = Tela inicial, 1 = Jogo
String chosenTheme = "";
boolean[][] cardFlipped;
int gridSize = 4;
PImage bgImage;
PImage bgFrutas, bgJogos, bgBandeiras;
PImage[] cardImages;
int[][] cardPairs;

void setup() {
  size(420, 914);
  cardFlipped = new boolean[gridSize][gridSize];
  resetCards();
  
  // Carregar imagens de fundo
  bgFrutas = loadImage("frutas.jpg");
  bgJogos = loadImage("jogos.jpg");
  bgBandeiras = loadImage("bandeiras.jpg");
  
  // Carregar imagens das cartas
  cardImages = new PImage[8];
  for (int i = 0; i < 8; i++) {
    cardImages[i] = loadImage("fruta" + i + ".png");
  }
  
  generateCardPairs();
}

void draw() {
  if (screen == 0) {
    drawMenu();
  } else if (screen == 1) {
    drawGame();
  }
}

void drawMenu() {
  background(200, 220, 255);
  fill(0);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Escolha um tema", width / 2, 100);
  
  drawButton("Frutas", width / 2 - 75, 250);
  drawButton("Jogos", width / 2 - 75, 350);
  drawButton("Bandeiras", width / 2 - 75, 450);
}

void drawButton(String label, float x, float y) {
  fill(255);
  rect(x, y, 150, 50, 10);
  fill(0);
  textSize(20);
  text(label, x + 75, y + 25);
}

void drawGame() {
  background(255);
  if (bgImage != null) {
    image(bgImage, 0, 0, width, height); // Desenha a imagem de fundo do tema escolhido
  }
  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("Tema escolhido: " + chosenTheme, width / 2, 50);
  
  drawCards();
}

void drawCards() {
  int cardSize = 80;
  int startX = (width - gridSize * cardSize) / 2;
  int startY = 100;

  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      int x = startX + j * cardSize;
      int y = startY + i * cardSize;

      if (cardFlipped[i][j]) {
        int index = cardPairs[i][j];
        if (index >= 0 && index < cardImages.length && cardImages[index] != null) {
          image(cardImages[index], x, y, cardSize - 5, cardSize - 5);
          println("Desenhando imagem da carta [" + i + "][" + j + "] - Índice: " + index);
        } else {
          println("ERRO: Tentativa de acessar imagem inválida na posição [" + i + "][" + j + "]");
          fill(255, 0, 0);
          rect(x, y, cardSize - 5, cardSize - 5);
        }
      } else {
        fill(100, 100, 200);
        rect(x, y, cardSize - 5, cardSize - 5, 10);
      }
    }
  }
}


void generateCardPairs() {
  ArrayList<Integer> pairs = new ArrayList<Integer>();
  for (int i = 0; i < 8; i++) {
    pairs.add(i);
    pairs.add(i);
  }
  Collections.shuffle(pairs);
  
  cardPairs = new int[gridSize][gridSize];
  int index = 0;
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      cardPairs[i][j] = pairs.get(index);
      index++;
    }
  }
}

void resetCards() {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      cardFlipped[i][j] = false; // Todas as cartas começam fechadas
    }
  }
  generateCardPairs();
}

void mousePressed() {
  if (screen == 0) {
    if (mouseX > width / 2 - 75 && mouseX < width / 2 + 75) {
      if (mouseY > 250 && mouseY < 300) {
        chosenTheme = "frutas";
        bgImage = bgFrutas;
        loadThemeImages("fruta"); // Função para carregar imagens corretas
        screen = 1;
        resetCards();
      } else if (mouseY > 350 && mouseY < 400) {
        chosenTheme = "jogos";
        bgImage = bgJogos;
        loadThemeImages("jogo");
        screen = 1;
        resetCards();
      } else if (mouseY > 450 && mouseY < 500) {
        chosenTheme = "bandeiras";
        bgImage = bgBandeiras;
        loadThemeImages("bandeira");
        screen = 1;
        resetCards();
      }
    }
  } else if (screen == 1) {
    // Lógica para virar carta clicada
    int cardSize = 80;
    int startX = (width - gridSize * cardSize) / 2;
    int startY = 100;

    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        int x = startX + j * cardSize;
        int y = startY + i * cardSize;
        if (mouseX > x && mouseX < x + cardSize - 5 && mouseY > y && mouseY < y + cardSize - 5) {
          if (!cardFlipped[i][j]) {
            cardFlipped[i][j] = true; // Vira a carta
            println("Carta clicada: " + i + ", " + j);
          }
        }
      }
    }
  }
}


void loadThemeImages(String theme) {
  cardImages = new PImage[8];
  for (int i = 0; i < 8; i++) {
    cardImages[i] = loadImage(theme + i + ".png");
    if (cardImages[i] == null) {
      println("Erro ao carregar imagem: " + theme + i + ".png");
    }
  }
}
