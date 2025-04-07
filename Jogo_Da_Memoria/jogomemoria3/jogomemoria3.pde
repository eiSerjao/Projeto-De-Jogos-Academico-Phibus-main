import java.util.Collections;
import java.util.ArrayList;

int screen = 0; 
String chosenTheme = "";
boolean[][] cardFlipped;
int gridSize = 4;
PImage bgImage;
PImage bgFrutas, bgJogos, bgBandeiras;
PImage[] cardImages;
int[][] cardPairs;

int[] firstCard = {-1, -1};
int[] secondCard = {-1, -1};
boolean lock = false;
int lastFlipTime = 0;
int jogadas = 0;

void setup() { // ---------------------------------------------------------------------- variáveis principais
  size(420, 814); // ------------------------------------------------------------------- tamanho da tela do jogo
  cardFlipped = new boolean[gridSize][gridSize];
  resetCards();
 
  bgFrutas = loadImage("frutas.jpg"); // ----------------------------------------------- imagens de background
  bgJogos = loadImage("jogos.jpg");
  bgBandeiras = loadImage("bandeiras.jpg");
  
  cardImages = new PImage[8];  // ------------------------------------------------------- imagens do jogo 
  for (int i = 0; i < 8; i++) {
    cardImages[i] = loadImage("fruta" + i + ".png");
  }
  
  generateCardPairs();
}

void draw() { // ----------------------------------------------------------------------- carregar as telas
  if (screen == 0) {
    drawMenu();
  } else if (screen == 1) {
    drawGame();

    if (lock && millis() - lastFlipTime > 1000) { // ----------------------------------- verificações de pares
      int i1 = firstCard[0];
      int j1 = firstCard[1];
      int i2 = secondCard[0];
      int j2 = secondCard[1];

      if (cardPairs[i1][j1] != cardPairs[i2][j2]) {
        cardFlipped[i1][j1] = false;
        cardFlipped[i2][j2] = false;
      }

      firstCard[0] = -1;
      firstCard[1] = -1;
      secondCard[0] = -1;
      secondCard[1] = -1;
      lock = false;

      if (checarVitoria()) {
        screen = 2;
      }
    }
  } else if (screen == 2) {
    drawVictory();
  }
}

void drawMenu() { // -------------------------------------------------------------------- carregar a tela de MENU e suas informações
  background(200, 220, 255);
  fill(0);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Escolha o tema do seu jogo", width / 2, 100);  // -------------------------------- TEMAS
  
  drawButton("Frutas", width / 2 - 75, 250);
  drawButton("Jogos", width / 2 - 75, 350);
  drawButton("Bandeiras", width / 2 - 75, 450);
}

void drawVictory() { // ------------------------------------------------------------------ informações da vitória 
  background(255);
  textAlign(CENTER, CENTER);
  fill(0, 150, 0);
  textSize(36);
  text("Você venceu!", width / 2, height / 2 - 50);
  fill(0);
  textSize(24);
  text("Jogadas: " + jogadas, width / 2, height / 2);
  textSize(18);
  text("Clique para jogar novamente", width / 2, height / 2 + 50);
}

void drawButton(String label, float x, float y) { // ------------------------------ botões
  fill(255);
  rect(x, y, 150, 50, 10);
  fill(0);
  textSize(20);
  text(label, x + 75, y + 25);
}

void drawGame() {
  background(255);
  if (bgImage != null) {
    image(bgImage, 0, 0, width, height);
  }

  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("Tema: " + chosenTheme, width / 2, 50);
  text("Jogadas: " + jogadas, width / 2, 80);
  
  drawCards();
}

void drawCards() { // ---------------------------------------------------------------- mostrar a imagem das cartas
  int cardSize = 80;
  int startX = (width - gridSize * cardSize) / 2;
  int startY = 120;

  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      int x = startX + j * cardSize;
      int y = startY + i * cardSize;

      if (cardFlipped[i][j]) {
        int index = cardPairs[i][j];
        if (index >= 0 && index < cardImages.length && cardImages[index] != null) {
          image(cardImages[index], x, y, cardSize - 5, cardSize - 5);
        } else {
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

void generateCardPairs() { // ------------------------------------------------------ cartas embaralhadas 
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

void resetCards() { // ----------------------------------------------------------- "limpa o histórico" das cartas do último jogo
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      cardFlipped[i][j] = false;
    }
  }
  generateCardPairs();
  firstCard[0] = -1;
  secondCard[0] = -1;
  lock = false;
  jogadas = 0;
}

boolean checarVitoria() {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      if (!cardFlipped[i][j]) return false;
    }
  }
  return true;
}

void mousePressed() { // --------------------------------------------------------- cliques do mouse
  if (screen == 0) {
    if (mouseX > width / 2 - 75 && mouseX < width / 2 + 75) {
      if (mouseY > 250 && mouseY < 300) {
        chosenTheme = "frutas";
        bgImage = bgFrutas;
        loadThemeImages("fruta");
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
  } else if (screen == 1 && !lock) {
    int cardSize = 80;
    int startX = (width - gridSize * cardSize) / 2;
    int startY = 120;

    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        int x = startX + j * cardSize;
        int y = startY + i * cardSize;
        if (mouseX > x && mouseX < x + cardSize - 5 && mouseY > y && mouseY < y + cardSize - 5) {
          if (!cardFlipped[i][j]) {
            cardFlipped[i][j] = true;

            if (firstCard[0] == -1) {
              firstCard[0] = i;
              firstCard[1] = j;
            } else if (secondCard[0] == -1) {
              secondCard[0] = i;
              secondCard[1] = j;
              jogadas++;
              lock = true;
              lastFlipTime = millis();
            }
          }
        }
      }
    }
  } else if (screen == 2) {
    screen = 0;
  }
}

void loadThemeImages(String theme) { // ----------------------------------------- vai mostrar as imagens dos temas 
  cardImages = new PImage[8];
  for (int i = 0; i < 8; i++) {
    cardImages[i] = loadImage(theme + i + ".png");
    if (cardImages[i] == null) {
      println("Erro ao carregar imagem: " + theme + i + ".png");
    }
  }
}
