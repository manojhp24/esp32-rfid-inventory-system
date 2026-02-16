#include "esp32-hal.h"
#include "HardwareSerial.h"
#ifndef WIFIMANAGER_H
#define WIFIMANAGER_H

#include "secrets.h"
#include <WiFi.h>


class WiFiManager {
  const char* ssid;
  const char* password;

public:
  WiFiManager(const char* wifiName, const char* wifiPassword) {
    ssid = wifiName;
    password = wifiPassword;
  }

  void connect() {
    if (tryConnect(ssid, password)) {
      Serial.println("Connected to primary WiFi");
      return;
    }

   
    if (tryConnect(WIFI_SSID_2, WIFI_PASSWORD_2)) {
      Serial.println("Connected to backup WiFi");
      return;
    }

    Serial.println("WiFi not available");
  }

  bool tryConnect(const char* s, const char* p) {
    Serial.print("Connecting to ");
    Serial.println(s);

    WiFi.begin(s, p);

    unsigned long start = millis();
    while (WiFi.status() != WL_CONNECTED && millis() - start < 15000) {
      delay(500);
      Serial.print(".");
    }

    Serial.println();

    if (WiFi.status() == WL_CONNECTED) {
      Serial.print("IP Address: ");
      Serial.println(WiFi.localIP());
      return true;
    }

    Serial.println("Failed");
    return false;
  }

  bool isConnected() {
    return WiFi.status() == WL_CONNECTED;
  }
};

#endif