/******************************************************
 * Nom du fichier : serveur.pde                        *
 * Auteur : Jean-Lou Gilbertas                         *
 * Date de dernière modification : 05 mai 2023         *
 * L'objectif de ce programme et de créer un serveur   *
 * qui va permette d'insérer dans une base de          *
 * données toutes les requêtes que le Robot qui        *
 * y sera connecté recevra (inclut l'adresse de        *
 * l'expéditeur, le mouvement et l'intensité).         *
 *******************************************************/

/******************************************
 * Imports et variables globales           *
 *                                         *
 * Cette section permet d'importer les     *
 * classes nécessaires pour travailler     *
 * avec une base de données Access et les  *
 * connexions réseau.                      *
 *******************************************/

// Importation des classes
import processing.net.Server;
import processing.net.Client;


// Déclaration des variables
com.healthmarketscience.jackcess.Database db; // Objet de type Database pour gérer la base de données
com.healthmarketscience.jackcess.Table table; // Objet de type Table pour gérer la table de la base de données
Server serveur; // Objet de type Server pour gérer le serveur

int portServeur = 5000; // Numéro du port sur lequel le serveur écoute

String messageConnexion = "En attente de connexion..."; // Message affiché lorsqu'on attend une connexion
//String requeteClient = ""; // Requête envoyée par le client

String IPRequete = ""; // Adresse IP de la requête
int mouvementRequete = ' '; // Mouvement de la requête (caractère)
int intensiteRequete = ' '; // Intensité de la requête (caractère)
String dateRequete = ""; // Date de la requête

/******************************************
 * Fonction setup()                        *
 * Cette fonction va s'exécuter une seule  *
 * fois au démarrage de l'application.     *
 * Elle va permettre de démarrer le        *
 * serveur et de se connecter à la base de *
 * données.                                *
 *******************************************/

void setup()
{
  size(750, 400); // Définit la taille de la fenêtre de l'application.
  background(255); // Définit la couleur de fond de la fenêtre en blanc.
  fill(0); // Définit la couleur de remplissage en noir.
  println("Tentative de démarrage du serveur..."); // Affiche un message dans la console.
  text("Tentative de démarrage du serveur...", 30, 160); // Affiche un message à l'écran.

  serveur = new Server(this, portServeur); // Crée une instance du serveur avec le port spécifié.

  try{
    db = DatabaseBuilder.open(new File(dataPath("") +"/logsMouvementsRobot.accdb")); // Ouvre la base de données Access spécifiée.
    println("Connexion à la base de données réussie."); // Affiche un message dans la console.

    table = db.getTable("logs"); // Récupère la table "logs" de la base de données.
    println("Connexion à la table réussie."); // Affiche un message dans la console.
  }
  catch(IOException erreur) // Si une erreur est survenue lors de la connexion à la base de données.
  {
    println("Erreur lors de la connexion à la base de données."); // Affiche un message d'erreur dans la console.
  }
  catch(Exception erreur) // Si une erreur est survenue lors de la connexion à la table.
  {
    println("Erreur lors de la connexion à la table."); // Affiche un message d'erreur dans la console.
  }

}

/******************************************
 * Fonction draw()                         *
 * Cette fonction va s'exécuter en boucle  *
 * et va permettre de gérer les connexions *
 * des clients et d'insérer les requêtes   *
 * dans la base de données.                *
 *******************************************/

void draw()
{
  Client client; // Déclaration d'une variable de type Client pour gérer la connexion client

  background(255); // Remplit la fenêtre avec une couleur de fond blanche
  if(serveur.active()) // Vérifie si le serveur est actif
  {    
    text("Le serveur est démarré sur le port " + portServeur + this + ".", 30, 60);// Affiche un message indiquant que le serveur est démarré sur le port spécifié
    
    text(messageConnexion, 30, 105); // Affiche le message de connexion
    
    client = serveur.available(); // Vérifie si un client est disponible pour se connecter

    if (client != null) { // Vérifie si un client est connecté
        IPRequete = client.readStringUntil(' '); // Lit l'adresse IP de la requête du client jusqu'à ce qu'il rencontre le caractère ' '
        mouvementRequete = client.read() - 48; // Lit le mouvement de la requête et soustrait 48 pour convertir la valeur ASCII en entier
        intensiteRequete = client.read() - 48; // Lit l'intensité de la requête et soustrait 48 pour convertir la valeur ASCII en entier
        if(IPRequete != null && mouvementRequete != ' ' && intensiteRequete != ' ') // Vérifie si les informations de la requête sont valides (ne sont pas vides).
        {
          IPRequete = IPRequete.substring(0, IPRequete.length() - 1); // Supprime le dernier caractère (' ') de l'adresse IP
          
          //mouvementRequete = mouvementRequete.substring(0, mouvementRequete.length() - 1);
          
          println("Requête du client : " + IPRequete + " mouvement : " + mouvementRequete + " avec une intensitee : " + intensiteRequete); // Affiche les informations de la requête dans la console
          try
          {
            table.addRow(0, IPRequete, mouvementRequete, intensiteRequete, hour(), minute(), second()); // Ajoute la requête dans la base de données avec les informations correspondantes et l'heure actuelle
            println("Ajout de la requête dans la base de données réussie.");
          }
          catch(IOException erreur)
          {
            println("Erreur lors de l'ajout de la requête dans la base de données.");
          }
          client.write("1\n");
        }
    }
    text(messageConnexion, 30, 90); // Affiche le message de connexion
    //text("Le client est connecté au serveur " + IPServeur + ".", 30, 120);
    //println("Le client est connecté au serveur " + IPServeur + ".");
  }
  else
  {
    text("Échec du démarrage du serveur", 30, 160);
    text("ou le serveur n'est plus disponible.", 30, 215);
    println("Échec du démarrage du serveur ou le serveur n'est plus disponible.");
  }
}

/******************************************
 * Fonction serveurEvent()                 *
 * Cette fonction va s'exécuter à chaque   *
 * fois qu'un client se connecte au        *
 * serveur.                                *
 *******************************************/

void serverEvent(Server serveur, Client client)
{
  messageConnexion = "connecté."; // Enregistre l'adresse IP du client connecté
  println("Nouvelle connexion"); // Affiche un message dans la console pour indiquer une nouvelle connexion
}

/******************************************
 * Fonction disconnectEvent()              *
 * Cette fonction va s'exécuter à chaque   *
 * fois qu'un client se déconnecte du      *
 * serveur.                                *
 *******************************************/

void disconnectEvent(Client client)
{
  println("Déconnexion"); // Affiche un message dans la console pour indiquer une déconnexion
  messageConnexion = "déconnecté."; // Met à jour le message de connexion pour indiquer que le client s'est déconnecté
}
