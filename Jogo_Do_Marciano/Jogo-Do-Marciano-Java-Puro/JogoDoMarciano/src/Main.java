import java.util.Random;
import java.util.Scanner;
import java.util.List;
import java.util.ArrayList;
import java.util.Comparator;


public class Main {
    // Scanner para capturar a entrada do usuário via teclado
    static Scanner scanner = new Scanner(System.in);
    
    // Lista para armazenar os recordes dos jogadores
    static List<Recorde> recordes = new ArrayList<>();
    
    // Variável global para armazenar o nome do jogador atual
    static String nomeJogador;

    public static void main(String[] args) {
        // Inicia o jogo chamando a tela inicial
        telaInicial();
    }

    static void telaInicial() {
        // Exibe o título e opções do menu inicial
        System.out.println("\n******************************************");
        System.out.println("Jogo do Marciano");
        
        // Mostra os recordes antes do jogador escolher a opção
        mostrarRecordes();
        
        System.out.println("Digite 1 para iniciar");
        System.out.println("Digite 2 para sair");
        System.out.print("\nDigite a sua opção: ");

        try {
            // Lê a entrada do usuário e converte para número
            int opcaoEscolhidaNumerica = Integer.parseInt(scanner.nextLine());

            // Verifica a opção escolhida pelo jogador
            switch (opcaoEscolhidaNumerica) {
                case 1:
                    System.out.println("******************************************");
                    solicitarNomeJogador(); // Solicita o nome antes da história
                    contarHistoria();       // Conta a introdução do jogo
                    gameMarciano();         // Inicia o jogo principal
                    break;
                case 2:
                    System.out.println("Você digitou a opção " + opcaoEscolhidaNumerica);
                    System.out.println("Tchau tchau :)"); // Mensagem de saída
                    break;
                default:
                    System.out.println("Opção inválida");
                    telaInicial(); // Se a entrada for inválida, exibe o menu novamente
                    break;
            }
        } catch (NumberFormatException e) {
            System.out.println("Entrada inválida! Digite um número.");
            telaInicial(); // Se a entrada não for um número, exibe o menu novamente
        }
    }


    static void solicitarNomeJogador() {
        // Solicita ao jogador que digite seu nome
        System.out.print("\nDigite seu nome para começar: ");
        
        // Armazena o nome digitado pelo jogador
        nomeJogador = scanner.nextLine();
        
        // Exibe uma mensagem de boas-vindas personalizada
        System.out.println("Bem-vindo, " + nomeJogador + "! Sua jornada começa agora.\n");
    }

    static void gameMarciano() {
        // Inicia o jogo principal
        game();
        
        // Após o jogo, pergunta se o jogador quer jogar novamente
        novaPartida();
    }

    static void contarHistoria() {
        // Exibe a introdução do jogo, apresentando a história ao jogador
        mostrarTexto("O Mistério do Marciano Perdido");
        esperarEnter(); // Aguarda o jogador pressionar ENTER para continuar
        
        mostrarTexto("Em um planeta distante chamado Xylox, um pequeno marciano chamado Zorp se perdeu enquanto explorava a Floresta das Mil Árvores. \nEle adora brincar de esconde-esconde, mas dessa vez foi longe demais e agora ninguém consegue encontrá-lo!");
        esperarEnter();

        mostrarTexto("Você, " + nomeJogador + ", é um explorador intergaláctico e recebeu uma missão muito importante: encontrar Zorp antes que a noite caia e ele fique com medo no meio da floresta.");
        esperarEnter();

        mostrarTexto("A única pista que você tem é que Zorp está escondido em uma árvore numerada de 1 a 100. \nSeu comunicador intergaláctico consegue detectar a posição aproximada de Zorp e te dirá se ele está escondido em uma árvore de número maior ou menor do que o que você tentou.");
        esperarEnter();

        mostrarTexto("Será que você consegue encontrar o pequeno marciano antes que ele se assuste? Boa sorte, " + nomeJogador + "! 🚀👽");
        esperarEnter();
    }


    static void game() {
        // Cria um objeto Random para gerar números aleatórios
        Random rand = new Random();
        
        // Define a posição inicial do Marciano em uma árvore entre 1 e 100
        int arvoreMarciano = rand.nextInt(100) + 1;
        
        // Variáveis auxiliares
        int arvore = 0; // Número digitado pelo jogador
        int numeroTentativa = 0; // Contador de tentativas
        boolean marcianoEncontrado = false; // Indica se o jogador encontrou o Marciano

        // Exibe o título do jogo
        mostrarTexto("Adivinhe a Árvore do Marciano");

        // Marca o tempo de início do jogo para medir quanto tempo o jogador leva
        long inicioTempo = System.currentTimeMillis();

        // Loop principal do jogo, continua até o jogador encontrar o Marciano
        while (!marcianoEncontrado) {
            System.out.print("\nDigite um número da árvore onde o Marciano possa estar: ");

            // Captura a entrada do jogador
            String opcaoEscolhida = scanner.nextLine();

            try {
                // Converte a entrada do jogador para número inteiro
                arvore = Integer.parseInt(opcaoEscolhida);

                // Verifica se o número digitado está dentro do intervalo válido (1 a 100)
                if (arvore < 1 || arvore > 100) {
                    System.out.println("Entrada inválida! Digite um número entre 1 e 100.");
                    continue; // Volta para o início do loop
                }

                // Incrementa o número de tentativas
                numeroTentativa++;

                // Verifica se o jogador acertou a árvore correta
                if (arvore == arvoreMarciano) {
                    // Calcula o tempo total que o jogador levou para encontrar o Marciano
                    long tempoDecorrido = (System.currentTimeMillis() - inicioTempo) / 1000;

                    // Exibe a mensagem de vitória
                    System.out.println("\n******************************************");
                    System.out.println("🎉 Parabéns, " + nomeJogador + "! Você encontrou o Marciano!");
                    System.out.println("******************************************");
                    System.out.println("🌳 O Marciano estava na árvore: " + arvoreMarciano);
                    System.out.println("🔢 Número de Tentativas: " + numeroTentativa);
                    System.out.println("⌛ Tempo: " + tempoDecorrido + " segundos");
                    System.out.println("******************************************\n");

                    // Verifica se o jogador bateu o recorde de tempo
                    Recorde melhorRecorde = obterMelhorRecorde();

                    if (melhorRecorde == null) {
                        // Se ainda não há recordes registrados
                        System.out.println("🏆 Você foi o PRIMEIRO a registrar um tempo na tabela de recordes!");
                    } else if (tempoDecorrido < melhorRecorde.tempo) {
                        // Se o tempo do jogador foi melhor que o recorde anterior
                        System.out.println("🔥 NOVO RECORD MUNDIAL! Você superou " + melhorRecorde.nome + ", que tinha " + melhorRecorde.tempo + " segundos!");
                    }

                    // Registra o tempo do jogador na tabela de recordes
                    registrarRecorde(tempoDecorrido);

                    // Define que o Marciano foi encontrado, encerrando o jogo
                    marcianoEncontrado = true;
                    break;
                }

                // Exibe as informações da tentativa
                System.out.println("\n******************************************");
                System.out.println("Sua última tentativa: " + arvore);
                System.out.println("Número de Tentativas: " + numeroTentativa);

                // Dá uma dica ao jogador, indicando se o Marciano está em uma árvore maior ou menor
                if (arvore > arvoreMarciano) {
                    System.out.println("O Marciano está em uma árvore menor!");
                } else {
                    System.out.println("O Marciano está em uma árvore maior!");
                }

                // A cada 10 tentativas, o Marciano muda de posição
                if (numeroTentativa % 10 == 0) {
                    System.out.println("O Marciano se cansou e trocou de árvore!");
                    arvoreMarciano = rand.nextInt(100) + 1;
                }

            } catch (NumberFormatException e) {
                // Caso o jogador digite algo que não seja um número
                System.out.println("Entrada inválida! Digite um número entre 1 e 100.");
            }
        }
    }

    
 // Retorna o melhor recorde registrado
    static Recorde obterMelhorRecorde() {
        return recordes.isEmpty() ? null : recordes.get(0);
    }

    // Método para iniciar uma nova partida
    static void novaPartida() {
        while (true) {
            System.out.print("\nGostaria de Jogar Novamente? s/n: ");
            
            // Cria um novo Scanner para capturar a entrada do usuário
            scanner = new Scanner(System.in);
            String opcaoEscolhida = scanner.nextLine().toLowerCase(); // Converte para minúsculas para evitar erros de comparação

            if (opcaoEscolhida.equals("s")) {
                System.out.println("\n**********************************");
                gameMarciano(); // Reinicia o jogo
            } else if (opcaoEscolhida.equals("n")) {
                telaInicial(); // Retorna ao menu inicial
                break;
            } else {
                System.out.println("Opção inválida!"); // Mensagem de erro caso a entrada seja inválida
            }
        }
    }

    // Método para exibir um texto com efeito de digitação
    static void mostrarTexto(String texto) {
        for (char letra : texto.toCharArray()) { // Percorre cada caractere do texto
            System.out.print(letra);
            try {
                Thread.sleep(30); // Pausa de 30 milissegundos entre cada caractere para criar o efeito
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt(); // Garante que a interrupção seja tratada corretamente
            }
        }
        System.out.println(); // Nova linha ao final do texto
    }

    // Método para pausar o jogo até o jogador pressionar ENTER
    static void esperarEnter() {
        System.out.println("\nPressione ENTER para continuar...");
        scanner.nextLine(); // Aguarda o jogador pressionar ENTER
    }

    // Método para registrar um novo recorde
    static void registrarRecorde(long tempo) {
        // Adiciona um novo recorde com o nome do jogador e o tempo gasto
        recordes.add(new Recorde(nomeJogador, tempo));
        
        // Ordena a lista de recordes pelo tempo (menor tempo primeiro)
        recordes.sort(Comparator.comparingLong(r -> r.tempo));
        
        // Mantém apenas os 10 melhores tempos na lista
        if (recordes.size() > 10) {
            recordes.remove(recordes.size() - 1);
        }
    }

    static void mostrarRecordes() {
        System.out.println("\nTabela de Recordes:");
        System.out.println("Nome | Tempo (s)");
        
        // Percorre a lista de recordes e exibe cada um
        for (Recorde recorde : recordes) {
            System.out.println(recorde.nome + " | " + recorde.tempo);
        }
        
        
        System.out.println("\n**************************************");
    }
}

class Recorde {
    String nome; // Percorre a lista de recordes e exibe cada um
    long tempo; // Tempo que ele levou para encontrar o marciano

    
    // Construtor da classe Recorde
    Recorde(String nome, long tempo) {
        this.nome = nome;
        this.tempo = tempo;
    }
}
