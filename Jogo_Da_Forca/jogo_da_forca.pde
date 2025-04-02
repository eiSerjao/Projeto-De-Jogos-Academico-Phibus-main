// Jogo da Forca em Processing com Design Moderno
// Por: Ingryd Barbosa

String[] categorias = {"Frutas", "Cidades", "Animais", "Países"};
String[][] palavras = {
  {"BANANA", "MORANGO", "ABACAXI", "LARANJA", "UVA", "MELANCIA", "KIWI", "MELÃO", "PÊSSEGO"},
  {"SÃO PAULO", "RIO DE JANEIRO", "BRASÍLIA", "SALVADOR", "CURITIBA", "BELO HORIZONTE", "FORTALEZA", "RECIFE"},
  {"ELEFANTE", "GIRAFA", "TIGRE", "LEÃO", "ZEBRA", "MACACO", "RINOCERONTE", "HIPOPÓTAMO", "CROCODILO"},
  {"BRASIL", "ARGENTINA", "CANADÁ", "JAPÃO", "ALEMANHA", "ITÁLIA", "FRANÇA", "ESPANHA", "PORTUGAL"}
};

String palavraSecreta;
char[] letrasDescobertas;
ArrayList<Character> letrasErradas = new ArrayList<Character>();
int categoriaSelecionada = -1;
int erros = 0;
final int MAX_ERROS = 6;
boolean jogoAtivo = false;
boolean vitoria = false;

// Variáveis do cronômetro
int tempoInicial;
int tempoLimite = 120; // 2 minutos em segundos
boolean modoContraTempo = false;
boolean tempoEsgotado = false;

// Cores
color corFundo = color(245, 245, 220); // Bege claro
color corTexto = color(50, 50, 80); // Azul escuro
color corBotao = color(70, 130, 180); // Azul médio
color corBotaoHover = color(100, 150, 200); // Azul mais claro
color corBotaoTempo = color(218, 165, 32); // Dourado
color corBotaoTempoHover = color(230, 180, 50); // Dourado claro
color corErro = color(220, 20, 60); // Vermelho
color corAcerto = color(34, 139, 34); // Verde
color corTempoCritico = color(178, 34, 34); // Vermelho escuro

void setup() {
  size(900, 650);
  textAlign(CENTER, CENTER);
  smooth();
}

void draw() {
  background(corFundo);
  
  if (!jogoAtivo) {
    desenharMenu();
  } else {
    desenharJogo();
    
    if (erros >= MAX_ERROS || vitoria || (modoContraTempo && tempoEsgotado())) {
      desenharResultado();
    }
  }
}

// Método para remover acentos
char removerAcento(char letra) {
  switch(letra) {
    case 'Á': case 'À': case 'Â': case 'Ã': case 'Ä':
      return 'A';
    case 'á': case 'à': case 'â': case 'ã': case 'ä':
      return 'a';
    case 'É': case 'È': case 'Ê': case 'Ë':
      return 'E';
    case 'é': case 'è': case 'ê': case 'ë':
      return 'e';
    case 'Í': case 'Ì': case 'Î': case 'Ï':
      return 'I';
    case 'í': case 'ì': case 'î': case 'ï':
      return 'i';
    case 'Ó': case 'Ò': case 'Ô': case 'Õ': case 'Ö':
      return 'O';
    case 'ó': case 'ò': case 'ô': case 'õ': case 'ö':
      return 'o';
    case 'Ú': case 'Ù': case 'Û': case 'Ü':
      return 'U';
    case 'ú': case 'ù': case 'û': case 'ü':
      return 'u';
    case 'Ç':
      return 'C';
    case 'ç':
      return 'c';
    default:
      return letra;
  }
}

void desenharMenu() {
  // Título
  fill(corTexto);
  textSize(42);
  text("JOGO DA FORCA", width/2, 70);
  textSize(28);
  text("Selecione uma categoria:", width/2, 120);
  
  // Botões de categoria
  for (int i = 0; i < categorias.length; i++) {
    boolean sobreBotao = mouseSobreBotao(width/2 - 150, 160 + i*80, 300, 50);
    fill(sobreBotao ? corBotaoHover : corBotao);
    rect(width/2 - 150, 160 + i*80, 300, 50, 15);
    fill(255);
    text(categorias[i], width/2, 185 + i*80);
  }
  
  // Botão para modo contra o tempo
  boolean sobreTempo = mouseSobreBotao(width/2 - 150, 160 + categorias.length*80 + 30, 300, 50);
  fill(sobreTempo ? corBotaoTempoHover : corBotaoTempo);
  rect(width/2 - 150, 160 + categorias.length*80 + 30, 300, 50, 15);
  fill(255);
  text(modoContraTempo ? "Modo Contra Tempo: ON" : "Modo Contra Tempo: OFF", width/2, 185 + categorias.length*80 + 30);
  
  // Explicação do modo contra o tempo
  if (modoContraTempo) {
    fill(corTexto);
    textSize(18);
    text("Você terá " + tempoLimite + " segundos para adivinhar a palavra!", width/2, 185 + categorias.length*80 + 85);
    textSize(28);
  }
  
  // Créditos
  fill(corTexto);
  textSize(14);
  text("Desenvolvido por Ingryd Barbosa", width/2, height - 30);
}

void desenharJogo() {
  // Desenhar a forca
  stroke(80);
  strokeWeight(6);
  noFill();
  
  // Base da forca
  line(120, 520, 280, 520);
  // Poste vertical
  line(150, 520, 150, 120);
  // Topo horizontal
  line(150, 120, 300, 120);
  // Corda
  line(300, 120, 300, 160);
  
  // Desenhar o boneco
  if (erros > 0) { // Cabeça
    fill(255, 218, 185);
    stroke(80);
    ellipse(300, 190, 70, 70);
    
    if (erros >= MAX_ERROS) {
      stroke(0);
      line(285, 180, 295, 190);
      line(295, 180, 285, 190);
      line(315, 180, 305, 190);
      line(305, 180, 315, 190);
    } else {
      fill(0);
      noStroke();
      ellipse(285, 185, 8, 8);
      ellipse(315, 185, 8, 8);
    }
    
    noFill();
    stroke(0);
    if (vitoria) {
      arc(300, 200, 30, 20, 0, PI);
    } else {
      line(290, 210, 310, 210);
    }
  }
  
  if (erros > 1) { // Corpo
    stroke(80);
    line(300, 220, 300, 340);
  }
  
  if (erros > 2) { // Braço esquerdo
    line(300, 250, 260, 290);
  }
  
  if (erros > 3) { // Braço direito
    line(300, 250, 340, 290);
  }
  
  if (erros > 4) { // Perna esquerda
    line(300, 340, 260, 400);
  }
  
  if (erros > 5) { // Perna direita
    line(300, 340, 340, 400);
  }
  
  // Letras erradas
  fill(corTexto);
  textSize(22);
  text("Letras erradas: " + letrasErradas.size() + "/" + MAX_ERROS, 675, 130);
  
  fill(corErro);
  textSize(20);
  String erradasStr = "";
  for (int i = 0; i < letrasErradas.size(); i++) {
    erradasStr += letrasErradas.get(i) + " ";
  }
  text(erradasStr, 675, 160);
  
  // Palavra secreta
  fill(corTexto);
  textSize(24);
  text("Palavra: " + (modoContraTempo ? "(Contra o tempo)" : ""), width/2, 400);
  
  fill(0);
  textSize(32);
  for (int i = 0; i < letrasDescobertas.length; i++) {
    if (letrasDescobertas[i] != 0) {
      fill(corAcerto);
      text(letrasDescobertas[i], 350 + i*40, 440);
    } else {
      fill(corTexto);
      text("_", 350 + i*40, 440);
    }
  }
  
  // Teclado
  desenharTecladoCompleto();
  
  // Cronômetro
  if (modoContraTempo) {
    desenharCronometro();
  }
}

void desenharTecladoCompleto() {
  String[] linhas = {"QWERTYUIOP", "ASDFGHJKL", "ZXCVBNMÇ"};
  
  for (int l = 0; l < linhas.length; l++) {
    for (int i = 0; i < linhas[l].length(); i++) {
      char letra = linhas[l].charAt(i);
      boolean usada = letrasErradas.contains(letra) || letraJaDescoberta(letra);
      boolean sobreLetra = mouseSobreBotao(350 + i*40 - l*20, 500 + l*50, 35, 35);
      
      if (usada) {
        fill(200, 200);
      } else if (sobreLetra) {
        fill(240);
      } else {
        fill(255, 220);
      }
      
      stroke(180);
      rect(350 + i*40 - l*20, 500 + l*50, 35, 35, 5);
      
      fill(usada ? 150 : corTexto);
      textSize(20);
      text(letra, 350 + i*40 - l*20 + 17, 500 + l*50 + 17);
    }
  }
}

void desenharCronometro() {
  int tempoRestante = tempoLimite - (millis() - tempoInicial) / 1000;
  tempoRestante = max(0, tempoRestante);
  
  fill(230);
  noStroke();
  rect(width - 200, 30, 170, 50, 10);
  
  if (tempoRestante <= 10) {
    fill(corTempoCritico);
  } else if (tempoRestante <= 30) {
    fill(255, 165, 0);
  } else {
    fill(50, 50, 80);
  }
  
  textSize(28);
  text("⏱ " + nf(tempoRestante, 2) + "s", width - 115, 55);
  
  if (tempoRestante <= 0 && !tempoEsgotado) {
    tempoEsgotado = true;
  }
}

boolean letraJaDescoberta(char letra) {
  for (int i = 0; i < palavraSecreta.length(); i++) {
    char letraPalavra = removerAcento(palavraSecreta.charAt(i));
    char letraDigitada = removerAcento(letra);
    
    if (Character.toUpperCase(letraPalavra) == Character.toUpperCase(letraDigitada) 
        && letrasDescobertas[i] == palavraSecreta.charAt(i)) {
      return true;
    }
  }
  return false;
}

void desenharResultado() {
  fill(0, 0, 0, 120);
  rect(0, 0, width, height);
  fill(255);
  textSize(42);
  
  if (vitoria) {
    fill(corAcerto);
    text("PARABÉNS! VOCÊ GANHOU!", width/2, height/2 - 40);
  } else if (tempoEsgotado) {
    fill(corTempoCritico);
    text("TEMPO ESGOTADO!", width/2, height/2 - 40);
  } else {
    fill(corErro);
    text("QUE PENA! VOCÊ PERDEU!", width/2, height/2 - 40);
  }
  
  fill(255);
  textSize(24);
  text("A palavra era: " + palavraSecreta, width/2, height/2 + 10);
  
  // Botão "Jogar Novamente"
  boolean sobreJogarNovamente = mouseSobreBotao(width/2 - 100, height/2 + 60, 200, 50);
  fill(sobreJogarNovamente ? corBotaoHover : corBotao);
  rect(width/2 - 100, height/2 + 60, 200, 50, 15);
  fill(255);
  text("Jogar Novamente", width/2, height/2 + 85);
}

boolean mouseSobreBotao(float x, float y, float w, float h) {
  return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
}

void mousePressed() {
  if (!jogoAtivo) {
    for (int i = 0; i < categorias.length; i++) {
      if (mouseSobreBotao(width/2 - 150, 160 + i*80, 300, 50)) {
        iniciarJogo(i);
      }
    }
    
    if (mouseSobreBotao(width/2 - 150, 160 + categorias.length*80 + 30, 300, 50)) {
      modoContraTempo = !modoContraTempo;
    }
  } else if (erros >= MAX_ERROS || vitoria || tempoEsgotado) {
    if (mouseSobreBotao(width/2 - 100, height/2 + 60, 200, 50)) {
      reiniciarJogo();
    }
  } else {
    String[] linhas = {"QWERTYUIOP", "ASDFGHJKL", "ZXCVBNMÇ"};
    
    for (int l = 0; l < linhas.length; l++) {
      for (int i = 0; i < linhas[l].length(); i++) {
        char letra = linhas[l].charAt(i);
        boolean usada = letrasErradas.contains(letra) || letraJaDescoberta(letra);
        
        if (!usada && mouseSobreBotao(350 + i*40 - l*20, 500 + l*50, 35, 35)) {
          verificarLetra(letra);
        }
      }
    }
  }
}

void iniciarJogo(int categoria) {
  categoriaSelecionada = categoria;
  palavraSecreta = palavras[categoria][(int)random(palavras[categoria].length)];
  letrasDescobertas = new char[palavraSecreta.length()];
  
  for (int i = 0; i < palavraSecreta.length(); i++) {
    if (palavraSecreta.charAt(i) == ' ' || palavraSecreta.charAt(i) == '-') {
      letrasDescobertas[i] = palavraSecreta.charAt(i);
    } else {
      letrasDescobertas[i] = 0;
    }
  }
  
  letrasErradas.clear();
  erros = 0;
  jogoAtivo = true;
  vitoria = false;
  tempoEsgotado = false;
  
  if (modoContraTempo) {
    tempoInicial = millis();
  }
}

void reiniciarJogo() {
  jogoAtivo = false;
  vitoria = false;
  erros = 0;
  tempoEsgotado = false;
  letrasErradas.clear();
}

void verificarLetra(char letra) {
  boolean acertou = false;
  
  for (int i = 0; i < palavraSecreta.length(); i++) {
    char letraPalavra = removerAcento(palavraSecreta.charAt(i));
    char letraDigitada = removerAcento(letra);
    
    if (Character.toUpperCase(letraPalavra) == Character.toUpperCase(letraDigitada)) {
      letrasDescobertas[i] = palavraSecreta.charAt(i);
      acertou = true;
    }
  }
  
  if (!acertou) {
    letrasErradas.add(letra);
    erros++;
  }
  
  vitoria = true;
  for (int i = 0; i < letrasDescobertas.length; i++) {
    if (letrasDescobertas[i] == 0) {
      vitoria = false;
      break;
    }
  }
}

boolean tempoEsgotado() {
  if (!modoContraTempo) return false;
  int tempoDecorrido = (millis() - tempoInicial) / 1000;
  return tempoDecorrido >= tempoLimite;
}

void keyPressed() {
  if (jogoAtivo && erros < MAX_ERROS && !vitoria && !tempoEsgotado) {
    if ((key >= 'a' && key <= 'z') || (key >= 'A' && key <= 'Z') || key == 'Ç' || key == 'ç') {
      verificarLetra(key);
    }
  }
}
