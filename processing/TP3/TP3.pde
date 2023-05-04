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
// String IPServeur = "192.168.1.139"; // Pour tester sur un autre robot.

// Numéro du port sur lequel écoute le serveur.
int portServeur = 5000;

// Logo indiquant que c'est un logiciel client.
// PImage imageDuClient;
PImage flecheHaut;
PImage flecheBas;
PImage flecheGauche;
PImage flecheDroite;
PImage flecheHautDroite;
PImage flecheHautGauche;
PImage flecheBasDroite;
PImage flecheBasGauche;
PImage arret;
PImage flecheIntensiteHaut;
PImage flecheIntensiteBas;
/**/

String instructionLED;
String[] tabInstructionLED = {"10", "11", "20", "21", "30", "31", "40", "41"};
String[] tabInstructionFleche = {"0", "1", "2", "3", "4", "5", "6", "7", "8"};
String instructionFleche;
String instructionArret = "90";
String[] tabInstructionIntensitee = {"1", "2", "3", "4", "5"};
String instructionIntensitee;
int intensite;
int[][] tabPositionFleche = {{320, 125}, {320, 365}, {320, 245}, {470, 245}, {160, 245}, {470, 125}, {160, 125}, {470, 365}, {160, 365}};
int[][] tabPositionIntensitee = {{340, 505}, {340, 575}};

String instructionRobot;

/******************************************
* Fonction setup()                        *
*******************************************/
void setup()
{
  // Initialisation de la fenêtre graphique.
  background(255);
  size(750, 900);
  textSize(24);
  fill(0);

  // Initialisation des variables à envoyer au robot.
  intensite = 1;
  instructionFleche = "2";

  // Ouverture des images et redimensionnement.
  {
    flecheHaut = loadImage("../images/haut.png");
    flecheBas = loadImage("../images/bas.png");
    flecheGauche = loadImage("../images/gauche.png");
    flecheDroite = loadImage("../images/droite.png");
    flecheHautDroite = loadImage("../images/haut_droite.png");
    flecheHautGauche = loadImage("../images/haut_gauche.png");
    flecheBasDroite = loadImage("../images/bas_droite.png");
    flecheBasGauche = loadImage("../images/bas_gauche.png");
    arret = loadImage("../images/arret.png");
    flecheIntensiteHaut = loadImage("../images/intensite_haut.png");
    flecheIntensiteBas = loadImage("../images/intensite_bas.png");
    flecheHaut.resize(100, 90);
    flecheBas.resize(100, 90);
    flecheGauche.resize(100, 90);
    flecheDroite.resize(100, 90);
    flecheHautDroite.resize(100, 90);
    flecheHautGauche.resize(100, 90);
    flecheBasDroite.resize(100, 90);
    flecheBasGauche.resize(100, 90);
    arret.resize(100, 90);
    flecheIntensiteHaut.resize(60, 40);
    flecheIntensiteBas.resize(60, 40);
  }


  println("Tentative de connexion avec le serveur...");

  // Connexion au serveur.
  client = new Client(this, IPServeur, portServeur);
}

/******************************************
* Fonction draw()                         *
*******************************************/
void draw()
{
  background(255);

  // Vérifier s'il y a une connexion active au serveur, et en informer l'utilisateur.
  if(client.active())
  {    
    text("Le client est connecté au serveur " + IPServeur + ".", 140, 60);
  }
  else
  {
    text("Le client n'a pas pu se connecter au serveur " + IPServeur, 30, 60);
    text("ou le serveur n'est plus disponible.", 30, 90);
    println("Le client n'a pas pu se connecter au serveur " + IPServeur + " ou le serveur n'est plus disponible.");
  }
  {
    text("Contrôle d'un robot avec connexion Wi-Fi", 165, 30);
    image(flecheHaut, 320, 125);
    image(flecheBas, 320, 365);
    image(flecheGauche, 160, 245);
    image(flecheDroite, 470, 245);
    image(flecheHautDroite, 470, 125);
    image(flecheHautGauche, 160, 125);
    image(flecheBasDroite, 470, 365);
    image(flecheBasGauche, 160, 365);
    image(flecheIntensiteBas, 340, 575);
    image(flecheIntensiteHaut, 340, 505);
    image(arret, 320, 245);
    text("Intensité : " + intensite, 320, 700);
    instructionRobot = instructionFleche + char(intensite + 48);
    text("Instruction envoyée au robot : " + instructionRobot, 30, 800);
  }
}

void mouseClicked(){
  for(int i = 0; i < 9; i++){
    if (mouseX > tabPositionFleche[i][0] && mouseX < tabPositionFleche[i][0] + 100 &&
        mouseY > tabPositionFleche[i][1] && mouseY < tabPositionFleche[i][1] + 90) {
      instructionFleche = tabInstructionFleche[i];
      //client.write(instructionFleche);
      println("j'ai écrit", instructionFleche);
      instructionRobot = instructionFleche + char(intensite + 48);
      client.write(instructionRobot);
    }
  }
  for (int j = 0; j < 2; j++){
    if (mouseX > tabPositionIntensitee[j][0] && mouseX < tabPositionIntensitee[j][0] + 60 &&
        mouseY > tabPositionIntensitee[j][1] && mouseY < tabPositionIntensitee[j][1] + 40) {
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
