// === CONFIGURAÇÕES DE MENU ===
String[] categorias = { "1 x PC", "1 x 1", "Impossível" };
color corFundo = color(0);
color corTexto = color(255);
color corBotao = color(50);
color corBotaoHover = color(100);

// === CONFIGURAÇÕES DE JOGO ===
int pontosParaVencer = 3; // <<< Defina aqui quantos pontos são necessários para vencer

int modo = -1; // -1 = menu, 0 = 1xPC, 1 = 1x1, 2 = Impossível
boolean jogoAcabou = false;
String vencedor = "";

// === RAQUETES ===
float playerY, pcY;
float raqueteLargura = 30;
float raqueteAltura = 200; 
float velocidadeRaquete = 10;

// === BOLA ===
float bolaX, bolaY;
float bolaVelX, bolaVelY;
float bolaTam = 20;

// === PLACAR ===
int pontosPlayer = 0;
int pontosPC = 0;

void setup() {
  size(900, 650);
  textAlign(CENTER, CENTER);
  iniciarJogo();
}

void draw() {
  background(corFundo);

  if (modo == -1) {
    desenharMenu();
  } else if (jogoAcabou) {
    mostrarVencedor();
  } else {
    jogar();
  }
}

void iniciarJogo() {
  bolaX = width / 2;
  bolaY = height / 2;
  bolaVelX = random(4, 5) * (random(1) < 0.5 ? -1 : 1); // MAIS RÁPIDA
  bolaVelY = random(3, 4) * (random(1) < 0.5 ? -1 : 1);
  playerY = height / 2 - raqueteAltura / 2;
  pcY = height / 2 - raqueteAltura / 2;
  pontosPlayer = 0;
  pontosPC = 0;
  jogoAcabou = false;
  vencedor = "";
}

void jogar() {
  // Movimento da bola
  bolaX += bolaVelX;
  bolaY += bolaVelY;

  // Rebater nas paredes
  if (bolaY < 0 || bolaY > height - bolaTam) {
    bolaVelY *= -1;
  }

  // Movimento jogador 1
  if (keyPressed) {
    if (key == 'w') playerY -= velocidadeRaquete;
    if (key == 's') playerY += velocidadeRaquete;
  }

  // Movimento jogador 2 ou PC
  if (modo == 1) {
    if (keyPressed) {
      if (keyCode == UP) pcY -= velocidadeRaquete;
      if (keyCode == DOWN) pcY += velocidadeRaquete;
    }
  } else if (modo == 0 || modo == 2) {
    if (modo == 2) {
      pcY = bolaY - raqueteAltura / 2;
    } else {
      float centroPC = pcY + raqueteAltura / 2;
      float velocidadePC = 3;
      if (centroPC < bolaY - 10) pcY += velocidadePC;
      else if (centroPC > bolaY + 10) pcY -= velocidadePC;
    }
  }

  // Limitar raquetes na tela
  playerY = constrain(playerY, 0, height - raqueteAltura);
  pcY = constrain(pcY, 0, height - raqueteAltura);

  // Colisão com raquetes
  if (bolaX < 50 && bolaY > playerY && bolaY < playerY + raqueteAltura) {
    bolaVelX *= -1.1;
  }
  if (bolaX > width - 50 && bolaY > pcY && bolaY < pcY + raqueteAltura) {
    bolaVelX *= -1.1;
  }

  // Pontuação
  if (bolaX < 0) {
    pontosPC++;
    resetarBola();
  } else if (bolaX > width) {
    pontosPlayer++;
    resetarBola();
  }

  // Verificar vitória
  if (pontosPlayer >= pontosParaVencer) {
    jogoAcabou = true;
    vencedor = "Jogador 1 venceu!";
  } else if (pontosPC >= pontosParaVencer) {
    jogoAcabou = true;
    vencedor = (modo == 1 ? "Jogador 2 venceu!" : "Computador venceu!");
  }

  // Desenhar raquetes
  fill(255);
  rect(30, playerY, raqueteLargura, raqueteAltura);
  rect(width - 50, pcY, raqueteLargura, raqueteAltura);

  // Desenhar bola
  ellipse(bolaX, bolaY, bolaTam, bolaTam);

  // Desenhar placar
  textSize(32);
  text(pontosPlayer + "  x  " + pontosPC, width / 2, 40);
}

void resetarBola() {
  bolaX = width / 2;
  bolaY = height / 2;
  bolaVelX = random(4, 5) * (random(1) < 0.5 ? -1 : 1);
  bolaVelY = random(3, 4) * (random(1) < 0.5 ? -1 : 1);
}

void desenharMenu() {
  fill(corTexto);
  textSize(42);
  text("PONG", width / 2, 70);

  textSize(28);
  text("Selecione o modo de jogo:", width / 2, 120);

  for (int i = 0; i < categorias.length; i++) {
    float x = width / 2 - 150;
    float y = 160 + i * 80;
    float w = 300;
    float h = 50;

    boolean sobreBotao = mouseSobreBotao(x, y, w, h);
    fill(sobreBotao ? corBotaoHover : corBotao);
    rect(x, y, w, h, 15);

    fill(255);
    text(categorias[i], width / 2, y + h / 2);
  }
}

void mostrarVencedor() {
  background(0);
  fill(255);
  textSize(48);
  text(vencedor, width / 2, height / 2 - 100);

  // Botão voltar ao menu
  float x = width / 2 - 150;
  float y = height / 2;
  float w = 300;
  float h = 60;

  boolean sobreBotao = mouseSobreBotao(x, y, w, h);
  fill(sobreBotao ? corBotaoHover : corBotao);
  rect(x, y, w, h, 15);

  fill(255);
  textSize(24);
  text("Voltar ao menu", width / 2, y + h / 2);
}

boolean mouseSobreBotao(float x, float y, float w, float h) {
  return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
}

void mousePressed() {
  if (modo == -1) {
    for (int i = 0; i < categorias.length; i++) {
      float x = width / 2 - 150;
      float y = 160 + i * 80;
      float w = 300;
      float h = 50;

      if (mouseSobreBotao(x, y, w, h)) {
        modo = i;
        iniciarJogo();
      }
    }
  } else if (jogoAcabou) {
    float x = width / 2 - 150;
    float y = height / 2;
    float w = 300;
    float h = 60;

    if (mouseSobreBotao(x, y, w, h)) {
      modo = -1;
    }
  }
}
