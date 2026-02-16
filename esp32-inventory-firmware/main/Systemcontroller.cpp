#include "esp32-hal.h"
#include <sys/_intsup.h>
#include "WString.h"
#include "Systemcontroller.h"
#include "secrets.h"
#include "pins.h"
#include "HardwareSerial.h"




SystemController::SystemController()
  : rfidReader(RFID_SS_PIN, RFID_RST_PIN),
    feedback(LED_PIN, BUZZER_PIN),
    wifi(WIFI_SSID_1, WIFI_PASSWORD_1),
    firebase(API_KEY, DATABASE_URL, USER_EMAIL, USER_PASSWORD),
    lcd(0x3F, 16, 2) {}

void SystemController::begin() {
  initSystem();
}

void SystemController::update() {
  firebase.loop();

  if (!waitForFirebaseReady())
    return;

  handleRFIDScan();
}


// ===== Internal =====

void SystemController::initSystem() {
  Serial.begin(9600);

  lcd.init();
  lcd.clearMessage();
  lcd.printMessage(0, 0, "Booting...");

  wifi.connect();
  if (!wifi.isConnected()) {
    Serial.println("No WiFi. Running offline.");

    lcd.clearMessage();
    lcd.printMessage(0, 0, "WiFi Failed");
    lcd.printMessage(0, 1, "Offline Mode");

    return;  
  }

  firebase.begin();

  rfidReader.begin();
  feedback.begin();

  Serial.println("\n[BOOT] System Ready");
  Serial.println("[BOOT] Scan Handler");

  lcd.clearMessage();
  lcd.printMessage(0, 0, "Ready");
  lcd.printMessage(0, 1, "Scan Handler");
}



void SystemController::handleRFIDScan() {
  if (!rfidReader.isCardDetected()) return;

  String uid = rfidReader.getUID();
  rfidReader.halt();
  feedback.success();

  unsigned long now = millis();

  if (uid == lastUID && (now - lastScanTime) < SCAN_COOLDOWN) {
    return;
  }

  lastUID = uid;
  lastScanTime = now;

  Serial.println("\n[SCAN]");
  Serial.print("UID: ");
  Serial.println(uid);


  processScan(uid);
}


void SystemController::processScan(const String& uid) {
  if (state == WAIT_HANDLER) {
    handleHandlerScan(uid);
  } else if (state == WAIT_ITEM) {
    handleItemScan(uid);
  }
}

void SystemController::handleHandlerScan(const String& uid) {
  lcd.clearMessage();
  lcd.printMessage(0, 0, "Verifying...");
  lcd.printMessage(0, 1, "Handler");

  if (!firebase.isHandlerAuthorized(uid)) {
    Serial.println("[HANDLER] ❌ Not authorized");
    feedback.error();

    lcd.clearMessage();
    lcd.printMessage(0, 0, "Handler");
    lcd.printMessage(0, 1, "Denied!");
    delay(2000);
    resetTransaction();
    return;
  }

  currentHandler = uid;
  state = WAIT_ITEM;

  feedback.success();
  Serial.println("[HANDLER] ✅ Verified");
  Serial.println("[ITEM] Scan item");

  lcd.clearMessage();
  lcd.printMessage(0, 0, "Handler OK");
  lcd.printMessage(0, 1, "Scan Item");
}

void SystemController::handleItemScan(const String& uid) {
  lcd.clearMessage();
  lcd.printMessage(0, 0, "Verifying...");
  lcd.printMessage(0, 1, "Item");

  if (!firebase.isItemValid(uid)) {
    Serial.println("[ITEM] ❌ Invalid");
    feedback.error();

    lcd.clearMessage();
    lcd.printMessage(0, 0, "Item Invalid");

    delay(2000);
    resetTransaction();
    return;
  }

  currentItem = uid;

  String location = firebase.getItemLocation(uid);


  if (location.length() == 0) {
    location = "IN";
  }

  String action = (location == "IN") ? "OUT" : "IN";

  firebase.updateItemLocation(uid, action);
  firebase.createLog(currentHandler, uid, action);

  feedback.success();

  Serial.println("[ITEM] ✅ Verified");
  Serial.print("[MOVE] ");
  Serial.println(action);
  Serial.println("[LOG] Transaction saved");

  lcd.clearMessage();
  lcd.printMessage(0, 0, "Item " + action);
  lcd.printMessage(0, 1, "Saved");

  delay(1500);
  resetTransaction();
}


void SystemController::resetTransaction() {
  currentHandler = "";
  currentItem = "";
  state = WAIT_HANDLER;

  Serial.println("\n[RESET] Waiting for handler");

  lcd.clearMessage();
  lcd.printMessage(0, 0, "Ready");
  lcd.printMessage(0, 1, "Scan Handler");
}


bool SystemController::waitForFirebaseReady() {
  static bool lastState = false;
  bool currentState = firebase.ready();

  if (currentState != lastState) {
    Serial.println(
      currentState ? "Firebase ready"
                   : "Waiting for Firebase auth...");
    lastState = currentState;
  }

  return currentState;
}
