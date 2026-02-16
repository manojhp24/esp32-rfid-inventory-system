#include "WString.h"
#ifndef SYSTEM_CONTROLLER_H
#define SYSTEM_CONTROLLER_H

#include "RFIDReader.h"
#include "Feedback.h"
#include "WIFIManager.h"
#include "FirebaseService.h"
#include "LCDManager.h"



class SystemController {

public:
  SystemController();
  void begin();
  void update();

private:
  enum ScanState{
    WAIT_HANDLER,
    WAIT_ITEM
  };

  ScanState state = WAIT_HANDLER;

  String currentHandler = "";
  String currentItem = "";
  String lastUID = "";
  unsigned long lastScanTime = 0;
  LcdManager lcd;

  const unsigned long SCAN_COOLDOWN = 3000;

  void initSystem();
  void handleRFIDScan();
  bool waitForFirebaseReady();
  void processScan(const String& uid);
  void handleHandlerScan(const String& uid);
  void handleItemScan(const String& uid);
  void resetTransaction();

  RFIDReader rfidReader;
  Feedback feedback;
  WiFiManager wifi;
  FirebaseService firebase;
};

#endif
