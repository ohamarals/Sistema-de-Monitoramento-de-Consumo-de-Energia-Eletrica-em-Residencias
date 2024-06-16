#include <WiFiManager.h> // Biblioteca para gerenciar conexões Wi-Fi
#include <PubSubClient.h> // Biblioteca para gerenciar cliente MQTT
#include <WiFi.h> // Biblioteca para funcionalidades Wi-Fi no ESP32
#include <WiFiClientSecure.h> // Biblioteca para clientes Wi-Fi seguros (TLS)
#include <EmonLib.h> // Biblioteca para medições de energia

// Configurações do MQTT
const char* mqtt_server = "6a100913b4c6440fb83678b718a03f49.s1.eu.hivemq.cloud"; // Endereço do servidor MQTT
const int mqtt_port = 8883; // Porta do servidor MQTT
const char* mqtt_username = "amaral"; // Nome de usuário do MQTT
const char* mqtt_password = "22051978"; // Senha do MQTT
const char* mqtt_topic_current = "home/sensor/current"; // Tópico MQTT para corrente
const char* mqtt_topic_power = "home/sensor/power"; // Tópico MQTT para potência
const char* mqtt_topic_voltage = "home/sensor/voltage"; // Tópico MQTT para tensão

WiFiClientSecure espClient; // Usar WiFiClientSecure para TLS
PubSubClient client(espClient); // Cliente MQTT utilizando o cliente Wi-Fi seguro

WiFiManager wm; // Instância do WiFiManager para gerenciar conexões Wi-Fi

// Instâncias dos sensores
EnergyMonitor SCT013; // Instância do sensor de corrente

// Configurações dos pinos
const int pinSCT = 34; // Pino analógico conectado ao SCT-013 no ESP32
const int pinZMPT = 36; // Pino VP (ADC 36) no ESP32 para o ZMPT101B

// Configurações do sensor de corrente
const int tensao = 127; // Tensão da rede elétrica (Ajuste conforme necessário)
double potencia; // Variável para armazenar a potência

// Configurações do sensor de tensão
const int numReadings = 100; // Número de leituras para a média
int readings[numReadings]; // Array para armazenar leituras
int readIndex = 0; // Índice atual do array
unsigned long total = 0; // Soma das leituras
float smoothedValue = 0; // Valor suavizado
int adc_max1 = 4095; // Valor máximo do ADC encontrado
int adc_min1 = 1600; // Valor mínimo do ADC encontrado
float volt_multi = 250; // Multiplicador de tensão
float volt_multi_p; // Multiplicador positivo de tensão
float volt_multi_n; // Multiplicador negativo de tensão
float volt_rms1 = 0; // Variável para armazenar a tensão RMS

void setup() {
  Serial.begin(115200); // Inicializa o monitor serial com taxa de 115200

  // Configura o sensor de corrente
  SCT013.current(pinSCT, 6.0606); // Inicializa o sensor de corrente no pino 34 com o fator de calibração

  // Configura os multiplicadores do sensor de tensão
  volt_multi_p = volt_multi * 1.4142; // Ajusta o multiplicador positivo
  volt_multi_n = -volt_multi_p; // Ajusta o multiplicador negativo

  // Inicializa o array de leituras
  for (int i = 0; i < numReadings; i++) {
    readings[i] = 0; // Zera todas as leituras
  }

  // Configura WiFi usando WiFiManager
  if (!wm.autoConnect("Dispositivo EnerVision", "osmeninostcc123")) {
    Serial.println("Falha na conexão.");
    ESP.restart(); // Reinicia o ESP32 se a conexão falhar
  }

  // Configura cliente MQTT
  client.setServer(mqtt_server, mqtt_port); // Define o servidor e a porta MQTT
  client.setCallback(callback); // Define a função de callback para mensagens recebidas

  // Configura TLS
  espClient.setInsecure(); // Desabilita verificação de certificado para simplicidade

  // Conecta ao broker
  reconnect(); // Tenta conectar ao broker MQTT
}

void callback(char* topic, byte* payload, unsigned int length) {
  // Função de callback para mensagens recebidas
  Serial.print("Mensagem recebida [");
  Serial.print(topic);
  Serial.print("]: ");
  for (unsigned int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();
}

void reconnect() {
  // Loop até se reconectar ao MQTT
  while (!client.connected()) {
    Serial.print("Tentando conexão MQTT...");
    if (client.connect("ESP32Client", mqtt_username, mqtt_password)) {
      Serial.println("Conectado");
      client.subscribe(mqtt_topic_current);
      client.subscribe(mqtt_topic_power);
      client.subscribe(mqtt_topic_voltage);
    } else {
      Serial.print("Falha, rc=");
      Serial.print(client.state());
      Serial.println(" Tentando novamente em 5 segundos");
      delay(5000);
    }
  }
}

void loop() {
  if (!client.connected()) {
    reconnect(); // Reconnecta se a conexão MQTT for perdida
  }
  client.loop(); // Mantém a conexão MQTT ativa

  // Leitura da corrente (10 bits)
  analogReadResolution(10); // Define a resolução da leitura analógica para 10 bits
  double Irms = SCT013.calcIrms(1480); // Calcula o valor da corrente RMS

  // Ignorar leituras abaixo de 0,15A
  if (Irms < 0.15) {
    Irms = 0;
  }
  // Aplicar fator corretivo para valores entre 0,1 e 1 ampere
  else if (Irms > 0.1 && Irms < 1.0) {
    Irms = Irms * 2; // Ajuste o fator corretivo conforme necessário
  }

  potencia = Irms * tensao; // Calcula o valor da potência instantânea

  String current_message = String(Irms, 2) + " A"; // Cria a mensagem de corrente
  String power_message = String(potencia, 2) + " W"; // Cria a mensagem de potência

  Serial.println(current_message); // Imprime a corrente no monitor serial
  Serial.println(power_message); // Imprime a potência no monitor serial

  client.publish(mqtt_topic_current, current_message.c_str()); // Publica a corrente no tópico MQTT
  client.publish(mqtt_topic_power, power_message.c_str()); // Publica a potência no tópico MQTT

  // Leitura da tensão (12 bits)
  analogReadResolution(12); // Define a resolução da leitura analógica para 12 bits
  volt_rms1 = get_voltage(pinZMPT, adc_min1, adc_max1); // Calcula o valor da tensão RMS

  // Ajustar a leitura de tensão com base nas faixas de desvios observados
  if (volt_rms1 >= 100 && volt_rms1 <= 195) {
    volt_rms1 -= 25; // Subtrai 25V para leituras na faixa de 100V a 195V
  } else if (volt_rms1 >= 195 && volt_rms1 <= 250) {
    volt_rms1 += 10; // Acrescenta 10V para leituras na faixa de 195V a 250V
  }

  String voltage_message;
  if (volt_rms1 <= 100) {
    voltage_message = "0 VAC";
  } else {
    voltage_message = String(volt_rms1, 2) + " VAC";
  }
  Serial.print("Vrms: ");
  Serial.println(voltage_message);

  client.publish(mqtt_topic_voltage, voltage_message.c_str()); // Publica a tensão no tópico MQTT

  delay(1000); // Aguarda 1 segundo entre as leituras
}

float get_voltage(int aa, int bb, int cc) {
  float adc_sample;
  float volt_inst = 0;
  float sum = 0;
  float volt;
  long init_time = millis();
  int N = 0;

  while ((millis() - init_time) < 100) {
    adc_sample = analogRead(aa);
    volt_inst = map(adc_sample, bb, cc, volt_multi_n, volt_multi_p);
    sum += sq(volt_inst);
    readings[readIndex] = adc_sample; // Armazena a leitura
    readIndex = (readIndex + 1) % numReadings; // Atualiza o índice de leitura
    N++;
    delay(1);
  }
  volt = sqrt(sum / N);
  return volt;
}