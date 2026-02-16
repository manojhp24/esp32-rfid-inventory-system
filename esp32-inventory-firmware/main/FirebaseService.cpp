#include "esp32-hal.h"
#include "WString.h"
#include "FirebaseService.h"

FirebaseService::FirebaseService(
  const char *apiKey,
  const char *dbURL,
  const char *email,
  const char *password)
  : userAuth(apiKey, email, password),
    asyncClient(sslClient)

{
  database.url(dbURL);
}

void FirebaseService::begin() {
  sslClient.setInsecure();

  initializeApp(
    asyncClient,
    app,
    getAuth(userAuth),
    processData,
    "authTask");

  app.getApp<RealtimeDatabase>(database);
}

void FirebaseService::loop() {
  app.loop();
}

bool FirebaseService::ready() {
  return app.ready();
}


bool FirebaseService::isHandlerAuthorized(const String &uid) {
  if (!app.ready()) return false;

  String path = "/handlers/" + uid + "/status";

  String status = database.get<String>(asyncClient, path);

  if (status.length() == 0) return false;

  return status == "authorized";
}

bool FirebaseService::isItemValid(const String &uid) {
  if (!app.ready()) return false;

  String path = "/items/" + uid + "/status";

  String status = database.get<String>(asyncClient, path);

  if (status.length() == 0) return false;

  return status == "active";
}

String FirebaseService::getItemLocation(const String &uid) {
  if (!app.ready()) return "";

  String path = "/items/" + uid + "/location";
  return database.get<String>(asyncClient, path);
}

void FirebaseService::updateItemLocation(const String &uid, const String &location) {
  if (!app.ready()) return;

  String path = "/items/" + uid + "/location";
  database.set(asyncClient, path, location);
}

void FirebaseService::createLog(const String &handler, const String &item, const String &action) {
  if (!app.ready()) return;

  String path = "/logs/" + String(millis());

  database.set(asyncClient, path + "/handler", handler);
  database.set(asyncClient, path + "/item", item);
  database.set(asyncClient, path + "/action", action);
  database.set(asyncClient, path + "/time", millis());
}



void FirebaseService::processData(AsyncResult &aResult) {
  static bool printed = false;

  if (!aResult.isResult()) return;

  if (aResult.isError()) {
    Serial.print("Firebase error: ");
    Serial.println(aResult.error().message());
    return;
  }

  if (aResult.available() && !printed) {
    Serial.println("Firebase ready");
    printed = true;
  }
}
