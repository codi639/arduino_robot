
#include <WiFiNINA.h>
#define BROCHE_DIRECTION_M1_GND 5
#define BROCHE_DIRECTION_M3_GND 6
#define BROCHE_VITESSE_M1M3 0
#define BROCHE_VITESSE_M2M4 1
#define BROCHE_DIRECTION_M2_GND 3
#define BROCHE_DIRECTION_M4_GND 9

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
    char actionRobot;
    int intensitee;


    if(WiFi.status() != WL_CONNECTED) {
        Serial.println("\nArduino n'est plus connecté au réseau Wi-Fi.");
        connexionWiFi();
    }

    client = serveur.available();

    if(client){
        Serial.println("\nUn client est connecté.");
            if(client.available() >= 2){
                //Serial.println("\nUn client a envoyé une requête.");
                actionRobot = client.read();
                intensitee = client.read();
                Serial.print("première valeur d'actionRobot "); Serial.println(actionRobot);
                Serial.print("première valeur d'intensité "); Serial.println(intensitee);
                intensitee = intensitee - 48;
                //intensitee =  (intensitee - 1) * (165) / 4 + 50;
                Serial.print("intensité "); Serial.println(intensitee);
                intensitee = (6 - intensitee) * (225 - 50) / 4 + 50;
                Serial.print("première valeur d'intensité "); Serial.println(intensitee);
                //intensitee = intensitee + 2050; //ajoutée uniquement par soucis de valeur (problème de serial.read)
                intensitee = (intensitee * -1) + 500 - 200;
                requeteClient[0] = actionRobot;
                requeteClient[1] = intensitee;
                Serial.print("seconde valeur d'actionRobot "); Serial.println(actionRobot);
                Serial.print("seconde valeur d'intensité ");Serial.println(intensitee);

                switch(actionRobot)
                {
                    case '0':
                        Serial.println("Le robot avance en ligne droite, pleine vitesse.");
                        analogWrite(BROCHE_DIRECTION_M1_GND, 0); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M3_GND, 0);
                        analogWrite(BROCHE_DIRECTION_M2_GND, 255); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M4_GND, 255);
                        break;
                    case '1':
                        Serial.println("Le robot recule, pleine vitesse.");
                        analogWrite(BROCHE_DIRECTION_M1_GND, 255); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M3_GND, 255);
                        analogWrite(BROCHE_DIRECTION_M2_GND, 0); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M4_GND, 0);
                        break;
                    case '2':
                        Serial.println("Arret du robot.");
                        analogWrite(BROCHE_DIRECTION_M2_GND, 0); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M4_GND, 0);
                        analogWrite(BROCHE_DIRECTION_M3_GND, 0); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M1_GND, 0);
                        break;
                    case '3':
                        Serial.println("Le robot pivote sur la droite.");
                        analogWrite(BROCHE_DIRECTION_M1_GND, 255); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M3_GND, 0);
                        analogWrite(BROCHE_DIRECTION_M2_GND, 255); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M4_GND, 0);
                        break;
                    case '4':
                        Serial.println("Le robot pivote sur la gauche.");
                        analogWrite(BROCHE_DIRECTION_M1_GND, 0); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M3_GND, 255);
                        analogWrite(BROCHE_DIRECTION_M2_GND, 0); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M4_GND, 255);
                        break;
                    case '5':
                        Serial.println("Le robot avance vers la droite.");
                        analogWrite(BROCHE_DIRECTION_M1_GND, 0); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M3_GND, 0);
                        analogWrite(BROCHE_DIRECTION_M2_GND, 255); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M4_GND, intensitee);
                        break;
                    case '6':
                        Serial.println("Le robot avance vers la gauche.");
                        analogWrite(BROCHE_DIRECTION_M1_GND, 0); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M3_GND, 0);
                        analogWrite(BROCHE_DIRECTION_M2_GND, intensitee); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M4_GND, 255);
                        break;
                    case '7':
                        Serial.println("Le robot recule vers la droite.");
                        analogWrite(BROCHE_DIRECTION_M1_GND, intensitee); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M3_GND, 255);
                        analogWrite(BROCHE_DIRECTION_M2_GND, 0); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M4_GND, 0);
                        break;
                    case '8':
                        Serial.println("Le robot recule vers la gauche.");
                        analogWrite(BROCHE_DIRECTION_M1_GND, 255); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M3_GND, intensitee);
                        analogWrite(BROCHE_DIRECTION_M2_GND, 0); // LOW ou 0.
                        analogWrite(BROCHE_DIRECTION_M4_GND, 0);
                        break;
                }
            }
        }        
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