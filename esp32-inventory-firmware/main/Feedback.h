#include "esp32-hal.h"
#include "esp32-hal-gpio.h"
#ifndef FEEDBACK_H
#define FEEDBACK_H

class Feedback {
  int ledPin;
  int buzzerPin;

public:
  Feedback(int led, int buzzer) {
    ledPin = led;
    buzzerPin = buzzer;
  }

  void begin() {
    pinMode(ledPin, OUTPUT);
    pinMode(buzzerPin, OUTPUT);
    off();
  }

  void success() {
    digitalWrite(ledPin, HIGH);
    digitalWrite(buzzerPin, HIGH);
    delay(200);
    off();
  }

  void error() {
    for (int i = 0; i < 5; i++) {
      digitalWrite(ledPin, HIGH);
      digitalWrite(buzzerPin, HIGH);
      delay(150);

      off();
      delay(150);
    }
  }

  void off() {
    digitalWrite(ledPin, LOW);
    digitalWrite(buzzerPin, LOW);
  }
};

#endif