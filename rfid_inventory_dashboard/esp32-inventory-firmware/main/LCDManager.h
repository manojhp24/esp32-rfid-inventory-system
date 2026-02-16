#ifndef LCDMANAGER_H
#define LCDMANAGER_H
#include <Wire.h>
#include <LiquidCrystal_I2C.h>


class LcdManager{
  private:
    LiquidCrystal_I2C lcd;

  public:
    LcdManager(uint8_t address, uint8_t cols, uint8_t rows);

    void init();
    void clearMessage();
    void printMessage(uint8_t col,uint8_t row, const String& text);
};




#endif