#include <Firebase.h>
#include <FirebaseArduino.h>
#include <FirebaseCloudMessaging.h>
#include <FirebaseError.h>
#include <FirebaseHttpClient.h>
#include <FirebaseObject.h>

//#include <ESP8266WiFi.h>
//#include <WiFiClient.h>

#include <ESP8266HTTPClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <SPI.h>
//#include <MFRC522.h>
#include <iostream>   
#include <string>  
long lastBlinkMillis;

//*************************************8**firebasesetup*********************************//
#define FIREBASE_HOST "task0esp8266-default-rtdb.firebaseio.com"      // database URL 
#define FIREBASE_AUTH "1bBZhnX0kuWYBwDv3rrng7lJOam0cWKq8SDjqf0e"        // secret key
//**************************************************************************************//

#define SCAN_PERIOD 5000
long lastScanMillis;
double data[]= {0,0,0,0,0,0};


void setup() 
{
  Serial.begin(9600);
  WiFi.begin("Ayazz", "txvq3950");   //WiFi connection
  while (WiFi.status() != WL_CONNECTED)     //Wait for the WiFI connection completion
  {  
    delay(500);
    Serial.println("Waiting for connection");
  }

  WiFi.mode(WIFI_STA);
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH); 
  //delay(100);
  /*
  Serial.println("CLEARDATA"); //clears up any data left from previous projects
  Serial.println("LABEL,Time,Timer,Flow Rate (L/min),Current liquid Flowing (ml/Sec),Output Liquid Quantity (ml)"); //always write LABEL then column names
  Serial.println("RESETTIMER"); //resets timer to 0
  */
 
}


void loop() {
  long currentMillis = millis();

  //**********************************************SCAN_WIFI*************************************************************//
  if (currentMillis - lastScanMillis > SCAN_PERIOD)
  {
    WiFi.scanNetworks(true);
    //Serial.print("\nScan start ... ");
    lastScanMillis = currentMillis;
  }
  // print out Wi-Fi network scan result upon completion
  int n = WiFi.scanComplete();
  if(n >= 0)
  {  
    for (int i = 0; i < n; i++)
    {
      if(String(WiFi.SSID(i).c_str()) == String( "STUDBME2"))
      {
        data[0] = WiFi.RSSI(i);
      }
      
      if(String(WiFi.SSID(i).c_str()) == String("STUDBME1"))
      {
        data[1] = WiFi.RSSI(i);
      }
      
      if(String(WiFi.SSID(i).c_str()) == String( "Ayazz"))
      { 
        data[2] = WiFi.RSSI(i);
      }
      
      if(String(WiFi.SSID(i).c_str()) == String( "CMP_LAB1"))
      { 
        data[3] = WiFi.RSSI(i);
      }
      
      if(String(WiFi.SSID(i).c_str()) == String( "CMP_LAB1"))
      { 
        data[4] = WiFi.RSSI(i);
      }
      
      if(String(WiFi.SSID(i).c_str()) == String( "CMP_LAB2"))
      { 
        data[5] = WiFi.RSSI(i);
      }
       if(String(WiFi.SSID(i).c_str()) == String( "CMP_LAB3"))
      { 
        data[6] = WiFi.RSSI(i);
      }
      
    }
    Serial.println(String(data[0])+  "," + String(data[1]) + "," + String(data[2]) + "," + String(data[3])+ "," + String(data[4]) + "," + String(data[5])+ "," + String(data[6]));
    WiFi.scanDelete();
  }
  //***********************************************************************************************************************//
  //****************************************SERVER_REQUESTS****************************************************************//
  if(WiFi.status()== WL_CONNECTED)
  {
    //Check WiFi connection status
    HTTPClient http; 
    http.begin("http://192.168.112.153:7452/predict");  //Specify request destination
  
    http.addHeader("Content-Type", "text/plain");  //Specify content-type header
  
    int httpCode = http.POST(String(data[0])+  "," + String(data[1]) + "," + String(data[2]) + "," + String(data[3])+","+ String(data[4]) + "," + String(data[5]));   //Send the request
    //int httpCode = http.POST("-51,-73,-86,-73,-71,-71");
    //int httpCode = http.GET();
    String payload = http.getString();    //Get the response payload
    
    //******************************************FIREBASE***********************************************************************/
   
    int location = payload.toInt();
    Firebase.setInt("room",location);
    if (Firebase.failed()) 
    {
      
      Serial.print("pushing /logs failed:");
      Serial.println(Firebase.error()); 
      return;
  }
    //************************************************************************************************************************/
   
    Serial.println(httpCode);   //Print HTTP return code
    Serial.println(payload);    //Print request response payload
   
    http.end();  //Close connection
      }   
//Send a request every 30 seconds
delay(1000); 
 
}

  
  
    
