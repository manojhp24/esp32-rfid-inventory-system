#include "LCDManager.h"

LcdManager::LcdManager(uint8_t address, uint8_t cols, uint8_t rows)
  : lcd(address, cols, rows){}


void LcdManager::init(){
  lcd.init();
  lcd.backlight();
}

void LcdManager::clearMessage(){
  lcd.clear();
}

void LcdManager::printMessage(uint8_t col, uint8_t row, const String &text){
  lcd.setCursor(col,row);
  lcd.print(text);
}