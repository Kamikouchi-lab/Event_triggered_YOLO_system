const int LED = 13;   

//レジスタの設定を変えるためのもの
#include <avr/io.h>
int PWMPin = 10;

//関数の定義
//frq:周波数 (1Hz~指定できる)
//duty:指定したいduty比
void HzWrite(int frq, float duty) { 

    // モード指定
  TCCR1A = 0b00100001;
  TCCR1B = 0b00010100; //分周比256を用いる

  // TOP値指定
  OCR1A = (unsigned int)(31250 / frq);

  // Duty比指定
  OCR1B = (unsigned int)(31250 / frq * duty);
}


void setup() {
  Serial.begin(9600);
  pinMode( LED, OUTPUT);
  pinMode(PWMPin, OUTPUT);
  
}

void loop() {
  unsigned int ser_avail = Serial.available();
  while (ser_avail > 0) {
      byte var;
      var = Serial.read();
      switch(var){
    case '0':
      digitalWrite(PWMPin, LOW);
      delay(100);
      break;
    case '1':
      HzWrite(30, 0.5);
      delay(10000);
      break;
    default:
      break;
  }
}

}
