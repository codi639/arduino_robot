/***************************************************************************
 * Nom du fichier : client.pde                                             *
 * Auteur : Jean-Lou Gilbertas                                             *
 * Date de dernière modification : 05 mai 2023                             *
 * Description : Ce programme permet de contrôler un robot à l'aide d'une  *
 * interface graphique.                                                    *
 *                                                                         *
 * Le programme est composé de deux parties :                              *
 *   - La première partie est l'interface graphique.                       *
 *   - La deuxième partie est la connexion avec le robot.                  *
 *                                                                         *
 * L'interface graphique est composée de :                                 *
 *   - 9 flèches pour contrôler le robot.                                  *
 *   - 2 flèches pour contrôler l'intensité des mouvements.                *
 *                                                                         *
 * La connexion avec le robot est composée de :                            *
 *   - Une adresse IP.                                                     *
 *   - Un port.                                                            *
 *                                                                         *
 * Le programme est composé de 3 fonctions :                               *
 *   - La fonction setup()                                                 *
 *   - La fonction draw()                                                  *
 *   - La fonction mousePressed()                                          *
 *                                                                         *
 * La fonction setup() est utilisée pour initialiser les variables et la   *
 * connexion avec le serveur.                                              *
 *                                                                         *
 * La fonction draw() est utilisée pour afficher l'interface graphique.    *
 *                                                                         *
 * La fonction mousePressed() est utilisée pour envoyer les instructions   *
 * au robot.                                                               *
 ***************************************************************************/

// Pour simplifier la lecture du code, on utilise des commentaires pour expliquer le fonctionnement du programme. Les commentaires sont ignorés par le compilateur.
// Par soucis de simplicité à la lecture du code, j'ai mis en place de region qui permettent de cacher le code (en le regroupant) et de le rendre plus lisible.

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

// Variable d'images pour les flèches.
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

// Variables pour les instructions.
String[] tabInstructionFleche = {"0", "1", "2", "3", "4", "5", "6", "7", "8"}; // 0 = haut, 1 = bas, 2 = arrêt, 3 = droite, 4 = gauche, 5 = haut-droite, 6 = haut-gauche, 7 = bas-droite, 8 = bas-gauche.
String instructionFleche;
String instructionArret = "90"; // 90 = arrêt (instruction unique).
String[] tabInstructionIntensitee = {"1", "2", "3", "4", "5"}; // 1 = virage très doux, 2 = virage doux, 3 = virage normal, 4 = virage serré, 5 = virage très serré. Ce tableau n'est utilisé que pour le débogage.
String instructionIntensitee;
int intensite;

// Variables pour les positions des flèches.
int[][] tabPositionFleche = {{320, 125}, {320, 365}, {320, 245}, {470, 245}, {160, 245}, {470, 125}, {160, 125}, {470, 365}, {160, 365}};
int[][] tabPositionIntensitee = {{340, 505}, {340, 575}};

// Variables envoyés au robot afin de le contrôler.
String instructionRobot;

/******************************************
 * Fonction setup()                        *
 * Cette fonction va s'exécuter une seule  *
 * fois au démarrage de l'application.     *
 * Elle est utilisée pour initialiser les  *
 * variables et la fenêtre graphique.      *
 * Elle va initialiser la connexion avec   *
 * le serveur.                             *
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

  // region Ouverture des images et redimensionnement.
    // Ouverture des images.
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
    // Redimensionnement des images.
    // Pour une question d'optimisation, nous aurions pus utiliser le tableau de positions des flèches pour redimensionner les images.
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
  // endregion


  println("Tentative de connexion avec le serveur...");

  // Connexion au serveur.
  client = new Client(this, IPServeur, portServeur);
}

/******************************************
 * Fonction draw()                         *
 * Cette fonction va s'exécuter en boucle  *
 * tant que l'application est ouverte.     *
 * Elle est utilisée pour afficher les     *
 * images et les textes.                   *
 * Elle va envoyer les instructions au     *
 * robot.                                  *
 *******************************************/
void draw()
{
  background(255);

  // Vérifier s'il y a une connexion active au serveur, et en informer l'utilisateur.
  if(client.active())
  {    
    text("Le client est connecté au serveur " + IPServeur + ".", 140, 60);
  }
  else // Si la connexion n'est pas active, en informer l'utilisateur.
  {
    text("Le client n'a pas pu se connecter au serveur " + IPServeur, 30, 60);
    text("ou le serveur n'est plus disponible.", 30, 90);
    println("Le client n'a pas pu se connecter au serveur " + IPServeur + " ou le serveur n'est plus disponible.");
  }
  // region Affichage des images et des textes et initialisation des instructions.
    // Affichage des images et des textes.
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
    // Initialisation de l'instruction envoyée au robot.
    instructionRobot = instructionFleche + char(intensite + 48);
    // Affichage de l'instruction envoyée au robot. (Non nécessaire mais simplifie le débogage, à commenter au besoin).
    text("Instruction envoyée au robot : " + instructionRobot, 30, 800);
  // endregion
}

/******************************************
 * Fonction mouseClicked()                 *
 * Cette fonction va s'exécuter lorsque    *
 * l'utilisateur va cliquer sur la fenêtre *
 * graphique.                              *
 * Elle est utilisée pour envoyer les      *
 * instructions au robot en fonction de    *
 * l'endroit où l'utilisateur a cliqué     *
 * (flèches du haut, du bas, etc.).        *
 *******************************************/

void mouseClicked(){
  // Boucle de vérification de la position de la souris. Cette partie vérifie si la souris est sur une des flèches directionnelles.
  // L'instruction à destination du robot est envoyée dans cette partie de la fonction car il n'est pas nécessaire de l'envoyer à chaque changement d'intensité.
  for(int indiceDirection = 0; indiceDirection < 9; indiceDirection++){ // Bouclage sur les 9 flèches directionnelles.
    // Si la souris se trouve à la position x à x + 100 et y à y + 90 (les + 100 et + 90 sont pour la taille des images), alors l'instruction est déterminée en fonction de la flèche.
    if (mouseX > tabPositionFleche[indiceDirection][0] && mouseX < tabPositionFleche[indiceDirection][0] + 100 &&
        mouseY > tabPositionFleche[indiceDirection][1] && mouseY < tabPositionFleche[indiceDirection][1] + 90) 
    {
      // Sélection de l'instruction en fonction de la flèche.
      instructionFleche = tabInstructionFleche[indiceDirection];
      //client.write(instructionFleche);
      println("Instruction Flèche : ", instructionFleche); // Débogage (apparait uniquement dans la console, à commenter au besoin).
      instructionRobot = instructionFleche + char(intensite + 48); // Conversion de l'intensité en caractère ASCII.
      client.write(instructionRobot); // Envoi de l'instruction au robot.
    }
  }
  // Boucle de vérification de la position de la souris. Cette partie vérifie si la souris est sur une des flèches d'intensité.
  for (int indiceIntensite = 0; indiceIntensite < 2; indiceIntensite++){
    if (mouseX > tabPositionIntensitee[indiceIntensite][0] && mouseX < tabPositionIntensitee[indiceIntensite][0] + 60 &&
        mouseY > tabPositionIntensitee[indiceIntensite][1] && mouseY < tabPositionIntensitee[indiceIntensite][1] + 40) 
    {
      //instructionIntensitee = tabInstructionIntensitee[indiceIntensite];
      println("Intensite : ", tabInstructionIntensitee[indiceIntensite]); // Débogage (apparait uniquement dans la console, à commenter au besoin).
      // region Calcul de l'intensité (si la souris est sur la flèche du haut, l'intensité augmente, si elle est sur la flèche du bas, l'intensité diminue).
      if (indiceIntensite == 0){
        intensite = intensite + 1;
      }
      if (indiceIntensite == 1){
        intensite = intensite - 1;
      }
      // Vérification que l'intensité est entre 1 et 5 (bloquée entre 1 et 5 (inclus), il est impossble de dépasser ces valeurs).
      if (intensite > 5){
        intensite = 5;
      }
      if (intensite < 1){
        intensite = 1;
      }
      println(intensite); // Débogage (apparait uniquement dans la console, à commenter au besoin).
      // endregion
    }
  }
}
