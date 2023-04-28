import processing.net.*;

Server serveur;

int portServeur = 5000;

String messageConnexion = "En attente de connexion...";
String requeteClient = "Allons-y";

void setup()
{
  size(750, 400);
  background(255);
  fill(0);
  println("Tentative de démarrage du serveur...");
  text("Tentative de démarrage du serveur...", 30, 160);

  serveur = new Server(this, portServeur);

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
    text("Requête du client : " + requeteClient, 30, 135);
    
    client = serveur.available();
    requeteClient = "Non pas tout de suite.";

    if (client != null) {
        requeteClient = "Tu me vois ?";
        requeteClient = client.readStringUntil('\n');
        println("Requête du client : " + requeteClient);
        if(requeteClient != null)
        {
            //requeteClient = requeteClient.substring(0, requeteClient.length() - 1);
          println("Requête du client : " + requeteClient);
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
  println("Nouvelle connexion : " + client.ip());
}

void disconnectEvent(Client client)
{
  println("Déconnexion de " + client.ip());
  messageConnexion = client.ip() + " s'est déconnecté.";
}