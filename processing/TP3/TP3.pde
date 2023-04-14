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
String[] tabInstructionFlecheHaut = {"10", "11", "12", "13", "14", "15"};
String[] tabInstructionFlecheBas = {"20", "21", "22", "23", "24", "25"};
String[] tabInstructionFlecheGauche = {"30", "31", "32", "33", "34", "35"};
String[] tabInstructionFlecheDroite = {"40", "41", "42", "43", "44", "45"};
String[] tabInstructionFlecheHautDroite = {"50", "51", "52", "53", "54", "55"};
String[] tabInstructionFlecheHautGauche = {"60", "61", "62", "63", "64", "65"};
String[] tabInstructionFlecheBasDroite = {"70", "71", "72", "73", "74", "75"};
String[] tabInstructionFlecheBasGauche = {"80", "81", "82", "83", "84", "85"};
String instructionArret = "90";
boolean LED1 = false;
boolean LED2 = false;
boolean LED3 = false;
boolean LED4 = false;
boolean[] LED = {false, false, false, false};
int[] LEDPos = {10, 180, 360, 540};
Server serveur;

/******************************************
* Fonction setup()                        *
*******************************************/
void setup()
{
  background(255);
  size(750, 500);
  textSize(24);
  fill(0);
  // imageDuClient = loadImage("Client.jpg");
  // image(imageDuClient, 15, 0);
  LEDOn = loadImage("../images/haut.png");
  LEDOff = loadImage("../images/bas.png");
  porteFermee = loadImage("../images/intensitee_bas.png");
  porteOuverte = loadImage("../images/intensitee_haut.png");
  porteOuverte.resize(112, 188);

  flecheHaut = loadImage("../images/haut.png");
  flecheBas = loadImage("../images/bas.png");
  flecheGauche = loadImage("../images/gauche.png");
  flecheDroite = loadImage("../images/droite.png");
  flecheHautDroite = loadImage("../images/haut_droite.png");
  flecheHautGauche = loadImage("../images/haut_gauche.png");
  flecheBasDroite = loadImage("../images/bas_droite.png");
  flecheBasGauche = loadImage("../images/bas_gauche.png");
  flecheIntensiteeBas = loadImage("../images/intensitee_bas.png");
  flecheIntensiteeHaut = loadImage("../images/intensitee_haut.png");

  instructionPorte = "00";
  porte = porteOuverte;

  // Tentative de connexion au serveur 192.168.1.148, écoutant sur le port 5000.
  println("Tentative de connexion avec le serveur...");
  text("Tentative de connexion avec le serveur...", 30, 60);
  client = new Client(this, IPServeur, portServeur);
  serveur = new Server(this, portServeur);
  //client.write(instructionPorte);
}

/******************************************
* Fonction draw()                         *
*******************************************/
void draw()
{
  background(255);
  for (int i = 0; i < 4; i++) {
    if (LED[i] == true) {
      image(LEDOn, LEDPos[i], 100);
    } else {
      image(LEDOff, LEDPos[i], 100);
    }
  }
  image(porte, 320, 310);
  /*if ()*/

  // Vérifier s'il y a une connexion active au serveur, et en informer l'utilisateur.
  if(client.active())
  {    
    text("Le client est connecté au serveur " + IPServeur + ".", 30, 60);
    println("Le client est connecté au serveur " + IPServeur + ".");
    if (client.available() > 0) {
      String message = client.readStringUntil('\n');
      if (message != null) {
        message = message.substring(0, message.length() - 1);
        if (message.equals("1")) {
          porte = porteOuverte;
        } else if (message.equals("0")) {
          porte = porteFermee;
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
}

void mouseClicked(){
  for (int i = 0; i < 4; i++) {
    if (mouseX > LEDPos[i] && mouseX < LEDPos[i] + 220 &&
        mouseY > 100 && mouseY < 100 + 220) {
      LED[i] = !LED[i];
      client.write(tabInstructionLED[i*2 + (LED[i] ? 0 : 1)]);
    }
  }
}
