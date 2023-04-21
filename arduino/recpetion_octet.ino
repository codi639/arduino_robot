/************************************************************************************************************************************************
 * Nom du fichier : Cherokey4WDMouvementsDeBase.ino                                                                                             *
 * Auteur : Guy Toutant                                                                                                                         *
 * Date de dernière modification : 1 avril 2023                                                                                                 *
 * Contrôle de la marche avant, du pivotement sur la droite, du virage vers la gauche et de l'arrêt du robot Cherokey 4WD.                      *
 * Broches du microcontrôleur servant au contrôle des roues du robot :                                                                          *
 * Broche 3 : GND pour les moteurs 1 et 3.                                                                                                      *
 * Broche 4 : VCC pour les moteurs 1 et 3. Contrôle de la direction des moteurs 1 et 3.                                                         *
 * Broche 5 : Contrôle de la vitesse des moteurs 1 et 3. Sans mode PWM (0 = arrêt, 1 = maximale), ou avec mode PWM (0 = arrêt, 255 = maximale). *
 * Broche 6 : Contrôle de la vitesse des moteurs 2 et 4. Sans mode PWM (0 = arrêt, 1 = maximale), ou avec mode PWM (0 = arrêt, 255 = maximale). *
 * Broche 7 : VCC pour les moteurs 2 et 4. Contrôle de la direction des moteurs 2 et 4.                                                         *
 * Broche 8 : GND pour les moteurs 2 et 4.                                                                                                      *
 ************************************************************************************************************************************************/

// Broches contrôlant les différents moteurs du robot.
#include <WiFiNINA.h>
#define BROCHE_DIRECTION_M1M3_GND 3
#define BROCHE_DIRECTION_M1M3_VCC 4
#define BROCHE_VITESSE_M1M3 5
#define BROCHE_VITESSE_M2M4 6
#define BROCHE_DIRECTION_M2M4_VCC 7
#define BROCHE_DIRECTION_M2M4_GND 8

WiFiServer serveur(5000);

void setup() {
  int noBroche;

  // Initialisation du port série pour son utilisation avec le Moniteur série.
  Serial.begin(9600);

  // Les broches 3 à 8, servant au contrôle des roues du robot, sont configurées pour la sortie d'un signal.
  for (noBroche = 3; noBroche <= 8; noBroche++)
  {
    pinMode(noBroche, OUTPUT);
  }

  
}

void loop() {
    WiFiClient client;
    char requeteClient[15];
    char octet1Reçu;
    char octet2Reçu;

    if(WiFi.status() != WL_CONNECTED){
        Serial.println("\nArduino n'est plus connecté au réseau Wi-Fi.");
        // Tentative de reconnexion au réseau Wi-Fi.
        connexionWiFi();
    }

    client = serveur.available();

    if(client){
        octet1Reçu = ' ';
        octet2Reçu = ' ';
        octet1Reçu = char(client.read());
        octet2Reçu = char(client.read());
        requeteClient[0] = octet1Reçu;
        requeteClient[1] = octet2Reçu;
        serial.println(requeteClient[0]);
        serial.println(requeteClient[1]);
    }
}


    // Mouvement 1.
  // Faire avancer le robot en ligne droite, pleine vitesse.
  // Les roues des moteurs 1 et 3 tournent ici à la même vitesse et dans le même sens que celles des moteurs 2 et 4.
  Serial.println("Le robot avance en ligne droite, pleine vitesse.");
  digitalWrite(BROCHE_DIRECTION_M1M3_VCC, HIGH); // HIGH ou 1.
  digitalWrite(BROCHE_DIRECTION_M1M3_GND, LOW); // LOW ou 0.
  analogWrite(BROCHE_VITESSE_M1M3, 255); // Mode PWM. 255/255.
  digitalWrite(BROCHE_DIRECTION_M2M4_VCC, HIGH); //  HIGH ou 1.
  digitalWrite(BROCHE_DIRECTION_M2M4_GND, LOW); // LOW ou 0.
  analogWrite(BROCHE_VITESSE_M2M4, 255); // Mode PWM. 255/255.
  // Laisser le mouvement actuel se poursuivre pendant 5 secondes.
  delay(5000);

  // Mouvement 2.
  // Arrêter le robot.
  // Il suffit d'appliquer une vitesse nulle aux quatre moteurs.
  Serial.println("Arret du robot.");
  analogWrite(BROCHE_VITESSE_M1M3, 0);
  analogWrite(BROCHE_VITESSE_M2M4, 0);
  // Laisser l'absence de mouvement se poursuivre pendant 2 secondes.
  delay(2000);
  
  // Mouvement 3.
  // Faire pivoter le robot sur la droite.
  // Deux façons de tourner :
  //  1. Virage serré, en pivotant le robot sur lui-même, en faisant tourner les roues
  //     d'un côté à la même vitesse et dans le sens inverse de celles de l'autre côté.
  //  2. Virage à rayon variable, en faisant tourner les roues d'un côté à une vitesse différente et
  //     dans le même sens que celles de l'autre côté.
  Serial.println("Le robot pivote sur la droite.");
  digitalWrite(BROCHE_DIRECTION_M1M3_VCC, LOW);
  digitalWrite(BROCHE_DIRECTION_M1M3_GND, HIGH);
  analogWrite(BROCHE_VITESSE_M1M3, 255);
  digitalWrite(BROCHE_DIRECTION_M2M4_VCC, HIGH);
  digitalWrite(BROCHE_DIRECTION_M2M4_GND, LOW);
  analogWrite(BROCHE_VITESSE_M2M4, 255);
  // Laisser le mouvement actuel se poursuivre pendant 5 secondes.
  delay(5000);

  // Mouvement 4.
  // Arrêter le robot.
  // Il suffit d'appliquer une vitesse nulle aux quatre moteurs.
  Serial.println("Arret du robot.");
  analogWrite(BROCHE_VITESSE_M1M3, 0);
  analogWrite(BROCHE_VITESSE_M2M4, 0);
  // Laisser l'absence de mouvement se poursuivre pendant 2 secondes.
  delay(2000);
  
  // Mouvement 5.
  // Faire avancer le robot en tournant vers la gauche, pleine vitesse.
  // Les roues des moteurs 2 et 4 tournent ici à une vitesse inférieure et dans le même sens que celles des moteurs 1 et 3.
  Serial.println("Le robot avance en tournant vers la gauche, pleine vitesse.");
  digitalWrite(BROCHE_DIRECTION_M1M3_VCC, HIGH);
  digitalWrite(BROCHE_DIRECTION_M1M3_GND, LOW);
  analogWrite(BROCHE_VITESSE_M1M3, 255);
  digitalWrite(BROCHE_DIRECTION_M2M4_VCC, HIGH);
  digitalWrite(BROCHE_DIRECTION_M2M4_GND, LOW);
  analogWrite(BROCHE_VITESSE_M2M4, 150);
  // Laisser le mouvement actuel se poursuivre pendant 5 secondes.
  delay(5000);

  // Mouvement 6.
  // Arrêter le robot.
  // Il suffit d'appliquer une vitesse nulle aux quatre moteurs.
  Serial.println("Arret du robot.");
  analogWrite(BROCHE_VITESSE_M1M3, 0);
  analogWrite(BROCHE_VITESSE_M2M4, 0);
}




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
  
  Serial.print("\nTentative de connexion au réseau Wi-Fi "); Serial.print(ssid); Serial.println(".");
  
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
}