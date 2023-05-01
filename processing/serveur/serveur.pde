com.healthmarketscience.jackcess.Database db;
com.healthmarketscience.jackcess.Table table;

import processing.net.Server;
import processing.net.Client;

Server serveur;

int portServeur = 5000;

String messageConnexion = "En attente de connexion...";
String requeteClient = "Allons-y";

String IPRequete = "";
int mouvementRequete = ' ';
int intensiteRequete = ' ';
String dateRequete = "";

void setup()
{
  size(750, 400);
  background(255);
  fill(0);
  println("Tentative de démarrage du serveur...");
  text("Tentative de démarrage du serveur...", 30, 160);

  serveur = new Server(this, portServeur);

  try{
    db = DatabaseBuilder.open(new File(dataPath("") +"/logsMouvementsRobot.accdb"));
    println("Connexion à la base de données réussie.");

    table = db.getTable("logs");
    println("Connexion à la table réussie.");
  }
  catch(IOException erreur)
  {
    println("Erreur lors de la connexion à la base de données.");
  }
  catch(Exception erreur)
  {
    println("Erreur lors de la connexion à la table.");
  }

}

void draw()
{
   Client client;

  background(255);
  if(serveur.active())
  {    
    text("Le serveur est démarré sur le port " + portServeur + this + ".", 30, 60);
    //println("Le serveur est démarré sur le port " + portServeur + ".");
    text(messageConnexion, 30, 105);
    //text("Requête du client : " + requeteClient, 30, 135);
    
    client = serveur.available();
    //requeteClient = "Non pas tout de suite.";

    if (client != null) {
        //requeteClient = "Tu me vois ?";
        IPRequete = client.readStringUntil(' ');
        mouvementRequete = client.read() - 48;
        intensiteRequete = client.read() - 48;
        if(IPRequete != null && mouvementRequete != ' ' && intensiteRequete != ' ')
        {
          IPRequete = IPRequete.substring(0, IPRequete.length() - 1);
          
          //mouvementRequete = mouvementRequete.substring(0, mouvementRequete.length() - 1);
          
          println("Requête du client : " + IPRequete + " mouvement : " + mouvementRequete + " avec une intensitee : " + intensiteRequete);
          //intensiteRequete = intensiteRequete.substring(0, intensiteRequete.length() - 1);
          //println("Requête du client : " + requeteClient);
            //requeteClient = requeteClient.substring(0, requeteClient.length() - 1);
          //println("Requête du client : " + requeteClient);
          try
          {
            table.addRow(0, IPRequete, mouvementRequete, intensiteRequete, hour(), minute(), second());
            println("Ajout de la requête dans la base de données réussie.");
          }
          catch(IOException erreur)
          {
            println("Erreur lors de l'ajout de la requête dans la base de données.");
          }
          client.write("1\n");
        }
      text(messageConnexion, 30, 90);
    }
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

void serverEvent(Server serveur, Client client)
{
  messageConnexion = client.ip() + " s'est connecté.";
  println("Nouvelle connexion");
}

void disconnectEvent(Client client)
{
  println("Déconnexion");
  messageConnexion = "déconnecté.";
}
