#include "Systemcontroller.h"


SystemController controller;

void setup() {
	controller.begin();
}
void loop() {
	controller.update();
}
