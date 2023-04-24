/***************************************************************************
 * Nom du fichier : ProcessingClientConnexion.pde                          *
 * Auteur : Guy Toutant                                                    *
 * Date de dernière modification : 21 mars 2023                            *
 * Référence de Processing : https://processing.org/reference.             *
 * Logiciel client IP se connectant à un logiciel serveur IP.              *
 * Les deux logiciels s'exécutent sur le même ordinateur.                  *
 * Le code inclut l'adresse IP du serveur et le port sur lequel il écoute. *
 * L'utilisateur est informé de la réussite ou non de la connexion.        *
 * Le client affiche l'adresse IP du serveur auquel il est connecté.       *
 ***************************************************************************/

// Le mot-clé import est utilisé pour charger une bibliothèque dans un programme (sketch).
// Les bibliothèques de base sont chargées automatiquement. Nul besoin d'énoncés import.
// Une bibliothèque est composée d'une ou de plusieurs classes (types complexes) regroupées pour étendre les capacités de Processing.
// Le caractère * est souvent utilisé à la fin de la ligne d'importation pour charger en une seule étapes toutes
// les classes liées, sans avoir à les référencer individuellement.
// D'autres bibliothèques, comme celles créée pour Java, peuvent également être importées.
// L'importation serait inscrite automatiquement en sélectionnant une bibliothèque dans le menu Sketch > Importer une librarie...
// Ici on importe la bibliothèque pour pouvoir utiliser des fonctions en lien avec l'utilisation d'un réseau.
// Dans ce programme, l'absence de cette importation causerait l'erreur suivante : Cannot find a class or type named "Client".
import processing.net.*;

// Contient un client réseau IP. https://processing.org/reference/libraries/net/Client.html.
// Un client demande une connexion à un serveur, et lui envoie ensuite des requêtes afin d'obtenir un service.
// Un service se traduit par l'obtention de diverses données et/ou par l'exécution de certaines tâches sur le serveur.
// Les ordinateurs client et serveur possèdent chacun une adresse IP.
// Le logiciel client sur cet ordinateur émet des requêtes à un logiciel serveur.
// Le logiciel serveur, également sur cet ordinateur, "écoute" les requêtes sur un port identifié par le développeur.
// Les logiciels client et serveur peuvent être sur des ordinateurs différents.
// Le logiciel serveur peut ensuite répondre aux requêtes des logiciels clients.
// Si la connexion n'est pas possible, par exemple si l'ordinateur serveur n'est pas disponible, ou si le logiciel serveur n'écoute
// pas sur le port indiqué par le logiciel client, la fonction/méthode active() permettra de le savoir et d'en informer l'utilisateur.
Client client;

// Adresse IP du serveur.
//String IPServeur = "10.10.212.28";
String IPServeur = "192.168.1.222";

// Numéro du port sur lequel écoute le serveur.
int portServeur = 5000;

// Logo indiquant que c'est un logiciel client.
// PImage imageDuClient;
PImage LEDOn;
PImage LEDOff;
PImage flecheHaut;
PImage flecheBas;
PImage flecheGauche;
PImage flecheDroite;
PImage flecheHautDroite;
PImage flecheHautGauche;
PImage flecheBasDroite;
PImage flecheBasGauche;
PImage arret;
PImage flecheIntensiteeHaut;
PImage flecheIntensiteeBas;
/**/
PImage porteFermee;
PImage porteOuverte;
PImage porte;

String instructionPorte;
boolean etatPorte;
String instructionLED;
String[] tabInstructionLED = {"10", "11", "20", "21", "30", "31", "40", "41"};
/*
String[] tabInstructionFlecheHaut = {"10", "11", "12", "13", "14", "15"};
String[] tabInstructionFlecheBas = {"20", "21", "22", "23", "24", "25"};
String[] tabInstructionFlecheGauche = {"30", "31", "32", "33", "34", "35"};
String[] tabInstructionFlecheDroite = {"40", "41", "42", "43", "44", "45"};
String[] tabInstructionFlecheHautDroite = {"50", "51", "52", "53", "54", "55"};
String[] tabInstructionFlecheHautGauche = {"60", "61", "62", "63", "64", "65"};
String[] tabInstructionFlecheBasDroite = {"70", "71", "72", "73", "74", "75"};
String[] tabInstructionFlecheBasGauche = {"80", "81", "82", "83", "84", "85"};*/
String[] tabInstructionFleche = {"0", "1", "2", "3", "4", "5", "6", "7", "8"};
String instructionFleche;
String instructionArret = "90";
String[] tabInstructionIntensitee = {"1", "2", "3", "4", "5"};
String instructionIntensitee;
int intensite;
int[][] tabPositionFleche = {{270, 75}, {270, 315}, {270, 195}, {420, 195}, {110, 195}, {420, 75}, {110, 75}, {420, 315}, {110, 315}};
int[][] tabPositionIntensitee = {{300, 475}, {300, 575}};

String instructionRobot;
boolean LED1 = false;
boolean LED2 = false;
boolean LED3 = false;
boolean LED4 = false;
boolean[] LED = {false, false, false, false};
int[] LEDPos = {10, 180, 360, 540};
Server serveur;
/*Position des images :
  flecheHaut, 270, 75
  flecheBas, 270, 315
  flecheGauche, 110, 195
  flecheDroite, 420, 195
  flecheHautDroite, 420, 75
  flecheHautGauche, 110, 75
  flecheBasDroite, 420, 315
  flecheBasGauche, 110, 315
  flecheIntensiteeBas, 320, 575
  flecheIntensiteeHaut, 320, 475
  arret, 270, 195
*/
/******************************************
* Fonction setup()                        *
*******************************************/
void setup()
{
  background(255);
  size(750, 900);
  textSize(24);
  fill(0);
  // imageDuClient = loadImage("Client.jpg");
  // image(imageDuClient, 15, 0);
  LEDOn = loadImage("../images/haut.png");
  LEDOff = loadImage("../images/bas.png");
  porteFermee = loadImage("../images/intensitee_bas.png");
  porteOuverte = loadImage("../images/intensitee_haut.png");
  porteOuverte.resize(112, 200);
  intensite = 1;
  instructionFleche = "2";
{
  flecheHaut = loadImage("../images/haut.png");
  flecheBas = loadImage("../images/bas.png");
  flecheGauche = loadImage("../images/gauche.png");
  flecheDroite = loadImage("../images/droite.png");
  flecheHautDroite = loadImage("../images/haut_droite.png");
  flecheHautGauche = loadImage("../images/haut_gauche.png");
  flecheBasDroite = loadImage("../images/bas_droite.png");
  flecheBasGauche = loadImage("../images/bas_gauche.png");
  arret = loadImage("../images/basic_circle.png");
  flecheIntensiteeHaut = loadImage("../images/intensitee_haut.png");
  flecheIntensiteeBas = loadImage("../images/intensitee_bas.png");
  flecheHaut.resize(200, 180);
  flecheBas.resize(200, 180);
  flecheGauche.resize(200, 180);
  flecheDroite.resize(200, 180);
  flecheHautDroite.resize(200, 180);
  flecheHautGauche.resize(200, 180);
  flecheBasDroite.resize(200, 180);
  flecheBasGauche.resize(200, 180);
  arret.resize(200, 180);
  flecheIntensiteeHaut.resize(120, 100);
  flecheIntensiteeBas.resize(120, 100);
}

  instructionPorte = "00";
  porte = porteOuverte;

  // Tentative de connexion au serveur 192.168.1.148, écoutant sur le port 5000.
  println("Tentative de connexion avec le serveur...");
  //text("Tentative de connexion avec le serveur...", 30, 60);
  /*client = new Client(this, IPServeur, portServeur);
  serveur = new Server(this, portServeur);
  //client.write(instructionPorte);*/
  client = new Client(this, IPServeur, portServeur);
}

/******************************************
* Fonction draw()                         *
*******************************************/
void draw()
{
  background(255);
  /*for (int i = 0; i < 4; i++) {
    if (LED[i] == true) {
      image(LEDOn, LEDPos[i], 100);
    } else {
      image(LEDOff, LEDPos[i], 100);
    }
  }
  image(porte, 320, 310);*/
  /*if ()*/

  // Vérifier s'il y a une connexion active au serveur, et en informer l'utilisateur.
  if(client.active())
  {    
    text("Le client est connecté au serveur " + IPServeur + ".", 30, 60);
    //println("Le client est connecté au serveur " + IPServeur + ".");
    if (client.available() > 0) {
      String message = client.readStringUntil('\n');
      if (message != null) {
        message = message.substring(0, message.length() - 1);
        if (message.equals("1")) {
          text("Le serveur a reçu la commande " + instructionRobot + ".", 30, 90);
        } else if (message.equals("0")) {
          text("Le serveur n'a pas reçu la commande " + instructionRobot + ".", 30, 90);
        }
      }
    }
  }
  else
  {
    text("Le client n'a pas pu se connecter au serveur " + IPServeur, 30, 60);
    text("ou le serveur n'est plus disponible.", 30, 90);
    println("Le client n'a pas pu se connecter au serveur " + IPServeur + " ou le serveur n'est plus disponible.");
  }

  text("Contrôle d'un robot avec connexion Wi-Fi", 165, 30);
  image(flecheHaut, 270, 75);
  image(flecheBas, 270, 315);
  image(flecheGauche, 110, 195);
  image(flecheDroite, 420, 195);
  image(flecheHautDroite, 420, 75);
  image(flecheHautGauche, 110, 75);
  image(flecheBasDroite, 420, 315);
  image(flecheBasGauche, 110, 315);
  image(flecheIntensiteeBas, 300, 575);
  image(flecheIntensiteeHaut, 300, 475);
  image(arret, 270, 195);
  text("Intensité : " + intensite, 320, 700);
  instructionRobot = instructionFleche + char(intensite + 48);
  text("Instruction envoyée au robot : " + instructionRobot, 30, 800);

}

void mouseClicked(){
  for(int i = 0; i < 9; i++){
    if (mouseX > tabPositionFleche[i][0] && mouseX < tabPositionFleche[i][0] + 200 &&
        mouseY > tabPositionFleche[i][1] && mouseY < tabPositionFleche[i][1] + 180) {
      instructionFleche = tabInstructionFleche[i];
      //client.write(instructionFleche);
      println("j'ai écrit", instructionFleche);
      instructionRobot = instructionFleche + char(intensite + 48);
      client.write(instructionRobot);
    }
  }
  for (int j = 0; j < 2; j++){
    if (mouseX > tabPositionIntensitee[j][0] && mouseX < tabPositionIntensitee[j][0] + 120 &&
        mouseY > tabPositionIntensitee[j][1] && mouseY < tabPositionIntensitee[j][1] + 100) {
      //instructionIntensitee = tabInstructionIntensitee[j];
      println("j'ai écrit", tabInstructionIntensitee[j]);
      if (j == 0){
        intensite = intensite + 1;
      }
      if (j == 1){
        intensite = intensite - 1;
      }
      if (intensite > 5){
        intensite = 5;
      }
      if (intensite < 1){
        intensite = 1;
      }
      println(intensite);
        
    }
  }
}
