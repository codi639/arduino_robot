/*******************************************************************************************
 * Nom du fichier : reception_octet.ino                                                    *
 * Auteur : Jean-Lou Gilbertas                                                             *
 * Dernière date de modification : 05 mai 2023                                             *
 * Description : Programme permettant de recevoir des octets et de les traiter avec une    *
 *               carte Arduino Uno.                                                        *
 *                                                                                         *
 * Le programme est composé de deux parties :                                              *
 * - La première partie est la mise en place du serveur (à l'écoute d'un client            *
 *   processing) et la connexion au serveur processign pour la base de données.            *
 * - La seconde partie est la gestion des moteur du robot en fonction des instructions     *
 *   qu'il aura reçu du client Processing, et l'envoie des requete au serveur Access.      *
 *******************************************************************************************/


// Inclusion des bibliothèques nécessaires au programme.
#include <WiFiNINA.h>

// Définition des constantes utilisées dans le programme (correspondante aux différentes broche de ma carte).
#define BROCHE_DIRECTION_M1M3_GND 4
#define BROCHE_DIRECTION_M2M4_GND 7
#define BROCHE_VITESSE_M1M3_GND 5
#define BROCHE_VITESSE_M2M4_GND 6
#define BROCHE_LED_WIFI 2
#define BROCHE_LED_ACCESS 0

// Numéro du port sur lequel le serveur écoute.
WiFiServer serveur(5000);

// Déclaration des variables utilisées dans le programme.
WiFiClient serveurProcessing; // Variable permettant de stocker le serveur Processing.

String adresseClient[4]; // Variable permettant de stocker l'adresse IP du client Processing.

/*********************************************************
 * Fonction : setup()                                    *
 * Description : Fonction permettant de configurer       *
 *              l'Arduino.                               *
 * Initie la connexion au réseau Wi-Fi et au serveur     *
 * Access.                                               *
 *********************************************************/

void setup() {
  int noBroche;

  // Initialisation du port série pour son utilisation avec le Moniteur série.
  Serial.begin(9600);

  // Les broches 3 à 8, servant au contrôle des roues du robot, sont configurées pour la sortie d'un signal.
  for (noBroche = 2; noBroche <= 9; noBroche++)
  {
    pinMode(noBroche, OUTPUT);
  }

  connexionWiFi(); // Connexion au réseau Wi-Fi.
  connexionServeur(); // Connexion au serveur Processing.
  
}

/*********************************************************
 * Fonction : loop()                                     *
 * Description : Fonction permettant de gérer le         *
 *             fonctionnement de l'Arduino.              *
 * Gère la connexion au réseau Wi-Fi et au serveur       *
 * Access en cas de déconnexion.                         *
 * Gère la réception des octets et l'envoie des requêtes *
 * au serveur Access.                                    *
 * Gère la gestion des moteurs du robot.                 *
 *********************************************************/

void loop() {
    WiFiClient client; 
    char requeteClient[15]; // Variable permettant de stocker la requête du client Processing.
    char actionRobot; // Variable permettant de stocker l'action à effectuer par le robot.
    int intensitee; // Variable permettant de stocker l'intensité à envoyer au robot.
    int intensiteAEnvoyer; // Variable permettant de stocker l'intensité à envoyer au serveur Access.

    // Vérification de la connexion au serveur Processing.
    if(!serveurProcessing.connected()){
      Serial.println("Perte de la connexion au serveur.");
      // Si la connexion au serveur Processing est perdue, on éteint la LED au serveur Processing et on tente de se reconnecter.
      digitalWrite(BROCHE_LED_ACCESS, LOW);
      connexionServeur();
    }

    // Vérification de la connexion au réseau Wi-Fi.
    if(WiFi.status() != WL_CONNECTED) {
        Serial.println("\nArduino n'est plus connecté au réseau Wi-Fi.");
        // Si la connexion au réseau Wi-Fi est perdue, on éteint la LED de connexion au Wi-Fi et on tente de se reconnecter.
        digitalWrite(BROCHE_LED_WIFI, LOW);
        connexionWiFi();
    }

    // Vérification qu'un client est connecté et lui envoie des informations.
    client = serveur.available();

    // Si un client est connecté et envoie des informations.
    if(client){
        // Récupération de l'adresse IP du client Processing.
        adresseClient[0] = String(client.remoteIP()[0]);
        adresseClient[1] = String(client.remoteIP()[1]);
        adresseClient[2] = String(client.remoteIP()[2]);
        adresseClient[3] = String(client.remoteIP()[3]);
        Serial.println("\nUn client est connecté.");
            // Si le client a envoyé au moins deux octets (respect du protocol).
            if(client.available() >= 2){
                //Serial.println("\nUn client a envoyé une requête.");
                actionRobot = client.read(); // Récupération de l'action à effectuer par le robot.
                intensitee = client.read(); // Récupération de l'intensité à envoyer au robot.
                Serial.print("première valeur d'actionRobot "); Serial.println(actionRobot); // Débogage (à commenter au besoin).
                Serial.print("première valeur d'intensité "); Serial.println(intensitee); // Débogage (à commenter au besoin).
                intensitee = intensitee - 48; // Conversion de l'intensité en entier.
                intensiteAEnvoyer = intensitee; // Stockage de l'intensité à envoyer au serveur Access.
                intensitee = (6 - intensitee) * (225 - 50) / 4 + 25; // Conversion de l'intensité en PWM (en fonction des valeurs 1, 2, 3, 4 ou 5).
                requeteClient[0] = actionRobot; // Stockage de l'action à effectuer par le robot.
                requeteClient[1] = intensitee; // Stockage de l'intensité à envoyer au robot.
                Serial.print("seconde valeur d'actionRobot "); Serial.println(actionRobot); // Débogage (à commenter au besoin).
                Serial.print("seconde valeur d'intensité ");Serial.println(intensitee); // Débogage (à commenter au besoin).


                // En fonction de l'action à effectuer par le robot.
                switch(actionRobot)
                {
                    // Si le robot doit avancer en ligne droite.
                    case '0':
                        Serial.println("Le robot avance en ligne droite, pleine vitesse."); // Débogage (à commenter au besoin).
                        digitalWrite(BROCHE_DIRECTION_M1M3_GND, HIGH); 
                        analogWrite(BROCHE_VITESSE_M1M3_GND, 255);
                        digitalWrite(BROCHE_DIRECTION_M2M4_GND, LOW);
                        analogWrite(BROCHE_VITESSE_M2M4_GND, 255);
                        // Envoi de l'adresse IP du client Processing, du mouvement effectué et de l'intensité à envoyer au serveur Access.
                        // A noter que le caractère '0' est ajouté à l'intensité pour permettre de séparer l'adresse IP du client Processing du mouvement et de l'intensité.
                        serveurProcessing.print(adresseClient[0] + "." + adresseClient[1] + "." + adresseClient[2] + "." + adresseClient[3] + ' ' + 0 + intensiteAEnvoyer);
                        break;
                    // Si le robot doit reculer.
                    case '1':
                        Serial.println("Le robot recule, pleine vitesse."); // Débogage (à commenter au besoin).
                        digitalWrite(BROCHE_DIRECTION_M1M3_GND, LOW);
                        analogWrite(BROCHE_VITESSE_M1M3_GND, 255);
                        digitalWrite(BROCHE_DIRECTION_M2M4_GND, HIGH);
                        analogWrite(BROCHE_VITESSE_M2M4_GND, 255);
                        serveurProcessing.print(adresseClient[0] + "." + adresseClient[1] + "." + adresseClient[2] + "." + adresseClient[3] + ' ' + 1 + intensiteAEnvoyer);
                        break;
                    // Si le robot doit s'arrêter.
                    case '2':
                        Serial.println("Arret du robot."); // Débogage (à commenter au besoin).
                        analogWrite(BROCHE_VITESSE_M1M3_GND, 0);
                        analogWrite(BROCHE_VITESSE_M2M4_GND, 0);
                        serveurProcessing.print(adresseClient[0] + "." + adresseClient[1] + "." + adresseClient[2] + "." + adresseClient[3] + ' ' + 2 + intensiteAEnvoyer);
                        break;
                    // Si le robot doit pivoter sur la droite.
                    case '3':
                        Serial.println("Le robot pivote sur la droite."); // Débogage (à commenter au besoin).
                        digitalWrite(BROCHE_DIRECTION_M1M3_GND, LOW);
                        analogWrite(BROCHE_VITESSE_M1M3_GND, 255);
                        digitalWrite(BROCHE_DIRECTION_M2M4_GND, LOW);
                        analogWrite(BROCHE_VITESSE_M2M4_GND, 255);
                        serveurProcessing.print(adresseClient[0] + "." + adresseClient[1] + "." + adresseClient[2] + "." + adresseClient[3] + ' ' + 3 + intensiteAEnvoyer);
                        break;
                    // Si le robot doit pivoter sur la gauche.
                    case '4':
                        Serial.println("Le robot pivote sur la gauche."); // Débogage (à commenter au besoin).
                        digitalWrite(BROCHE_DIRECTION_M1M3_GND, HIGH);
                        analogWrite(BROCHE_VITESSE_M1M3_GND, 255);
                        digitalWrite(BROCHE_DIRECTION_M2M4_GND, HIGH);
                        analogWrite(BROCHE_VITESSE_M2M4_GND, 255);
                        serveurProcessing.print(adresseClient[0] + "." + adresseClient[1] + "." + adresseClient[2] + "." + adresseClient[3] + ' ' + 4 + intensiteAEnvoyer);
                        break;
                    // Si le robot doit avancer vers la droite.
                    case '5':
                        Serial.println("Le robot avance vers la droite."); // Débogage (à commenter au besoin).
                        digitalWrite(BROCHE_DIRECTION_M1M3_GND, HIGH);
                        analogWrite(BROCHE_VITESSE_M1M3_GND, intensitee);
                        digitalWrite(BROCHE_DIRECTION_M2M4_GND, LOW);
                        analogWrite(BROCHE_VITESSE_M2M4_GND, 255);
                        serveurProcessing.print(adresseClient[0] + "." + adresseClient[1] + "." + adresseClient[2] + "." + adresseClient[3] + ' ' + 5 + intensiteAEnvoyer);
                        break;
                    // Si le robot doit avancer vers la gauche.
                    case '6':
                        Serial.println("Le robot avance vers la gauche."); // Débogage (à commenter au besoin).
                        digitalWrite(BROCHE_DIRECTION_M1M3_GND, HIGH);
                        analogWrite(BROCHE_VITESSE_M1M3_GND, 255);
                        digitalWrite(BROCHE_DIRECTION_M2M4_GND, LOW);
                        analogWrite(BROCHE_VITESSE_M2M4_GND, intensitee);
                        serveurProcessing.print(adresseClient[0] + "." + adresseClient[1] + "." + adresseClient[2] + "." + adresseClient[3] + ' ' + 6 + intensiteAEnvoyer);
                        break;
                    // Si le robot doit reculer vers la droite.
                    case '7':
                        Serial.println("Le robot recule vers la droite."); // Débogage (à commenter au besoin).
                        digitalWrite(BROCHE_DIRECTION_M1M3_GND, LOW);
                        analogWrite(BROCHE_VITESSE_M1M3_GND, intensitee);
                        digitalWrite(BROCHE_DIRECTION_M2M4_GND, HIGH);
                        analogWrite(BROCHE_VITESSE_M2M4_GND, 255);
                        serveurProcessing.print(adresseClient[0] + "." + adresseClient[1] + "." + adresseClient[2] + "." + adresseClient[3] + ' ' + 7 + intensiteAEnvoyer);
                        break;
                    // Si le robot doit reculer vers la gauche.
                    case '8':
                        Serial.println("Le robot recule vers la gauche."); // Débogage (à commenter au besoin).
                        digitalWrite(BROCHE_DIRECTION_M1M3_GND, LOW);
                        analogWrite(BROCHE_VITESSE_M1M3_GND, 255);
                        digitalWrite(BROCHE_DIRECTION_M2M4_GND, HIGH);
                        analogWrite(BROCHE_VITESSE_M2M4_GND, intensitee);
                        serveurProcessing.print(adresseClient[0] + "." + adresseClient[1] + "." + adresseClient[2] + "." + adresseClient[3] + ' ' + 8 + intensiteAEnvoyer);
                        break;
                }
            }
        }        
}


/**************************************************
 * Fonction : connexionWiFi()                     *
 * Description : Connexion au réseau Wi-Fi.       *
 * Gère les paramètres de connexion au réseau     *
 * Wi-Fi.                                         *
 * Allume la DEL de la carte Arduino lorsque la   *
 * connexion est établie.                         *
 **************************************************/

void connexionWiFi() {
  // Identifiants privés pour l'accès au réseau Wi-Fi.
  // https://create.arduino.cc/projecthub/Arduino_Genuino/store-your-sensitive-data-safely-when-sharing-a-sketch-e7d0f0
  char ssid[] = "h212"; // SSID.
  char motDePasse[] = "cisco1234"; // Mot de passe WPA2 Personal.

  // Adressage IP alloué à Arduino par le serveur DHCP du réseau local. Type/Classe de la librairie Ethernet.
  // https://www.arduino.cc/reference/en/libraries/ethernet/ipaddress/
  IPAddress ipDHCP, passerelleDHCP;

  // Adressage statique de la carte Arduino.
  IPAddress ipStatique(192, 168, 1, 222);
  IPAddress dnsStatique(1, 1, 1, 1); // Inutilisée. Adresse bidon.
  IPAddress passerelleStatique(192, 168, 1, 1);
  IPAddress masqueStatique(255, 255, 255, 0);
  
  Serial.print("\nTentative de connexion au réseau Wi-Fi "); Serial.print(ssid); Serial.println("."); // Débogage (à commenter au besoin).
  
  // WiFi.begin() initialise les paramètres réseau de la bibliothèque WiFiNINA, et retourne une valeur indiquant si la
  // connexion au réseau Wi-Fi a réussi ou non.
  // Retourne WL_CONNECTED lorsqu'il y a une connexion au réseau Wi-Fi.
  // Retourne WL_IDLE_STATUS lorsqu'il n'y a pas de connexion au réseau Wi-Fi, mais que l'interface réseau est sous tension.
  // La connexion est tentée en boucle.
  while (WiFi.begin(ssid, motDePasse) != WL_CONNECTED)
  {
    // Échec de la connexion au réseau Wi-Fi.
    Serial.print(".");
    delay(5000);
  }

  // Succès de la connexion au réseau Wi-Fi.
  Serial.print("\nArduino est connecté au réseau Wi-Fi.\n\n");
  
  // Récupération de l'adresse IP et de l'adresse de la passerelle, allouées par le serveur DHCP.
  ipDHCP = WiFi.localIP();
  passerelleDHCP = WiFi.gatewayIP();
  Serial.print("Le serveur DHCP lui a alloué l'adressage suivant :\n");
  Serial.print("Adresse IP : "); Serial.println(ipDHCP);
  Serial.print("Passerelle par défaut : "); Serial.println(passerelleDHCP);

  // Configuration de l'adressage statique de la carte Arduino.
 // https://www.arduino.cc/reference/en/libraries/wifinina/wifi.config
 WiFi.config(ipStatique, dnsStatique, passerelleStatique,masqueStatique);

 // Affichage de l'adresse IP statique de la carte Arduino.
 Serial.print("\nL'adresse statique "); Serial.print(WiFi.localIP()); Serial.println(" lui a ensuite été allouée par programmation.");

  // Demander au serveur de débuter l'écoute des demandes de connexions des clients.
  serveur.begin();

  digitalWrite(BROCHE_LED_WIFI, HIGH);
}

/**************************************************
 * Fonction : connexionServeur()                  *
 * Description : Connexion au serveur Processing. *
 * Envoie une requête de connexion au serveur     *
 * Processing.                                    *
 * Allume la LED d'accès au serveur Processing.   *
 **************************************************/
 

void connexionServeur(){
  while(!serveurProcessing.connect("10.10.212.18", 5000)){
    Serial.print("Tentative de connexion au serveur...\n");
  }
  Serial.print("Le robot est connecté au serveur\n");
  digitalWrite(BROCHE_LED_ACCESS, HIGH);
}
