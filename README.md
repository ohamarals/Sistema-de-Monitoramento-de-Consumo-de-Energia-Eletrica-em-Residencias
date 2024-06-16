# Sistema de Monitoramento de Consumo de Energia Elétrica

## Descrição Geral

Este projeto foi desenvolvido por **Guilherme Henrique Amaral Cevada** como parte do Trabalho de Conclusão de Curso (TCC) de Eletrotécnica na **ETEC de Ilha Solteira**, São Paulo, Brasil, em junho de 2024.  
O objetivo principal deste projeto é monitorar e gerenciar o consumo de energia elétrica em residências, utilizando sensores conectados ao ESP32 para transmitir dados via MQTT a um aplicativo móvel.

## Objetivos e Funcionalidades

### Aplicativo Funcional

A versão funcional do aplicativo **Enervision** foi projetada para receber dados reais de tensão, corrente e potência diretamente dos sensores conectados ao ESP32.  
O aplicativo exibe esses dados em tempo real, proporcionando uma interface simples e intuitiva para visualização.

- **Monitoramento de Energia em Tempo Real:** Recebe e exibe dados reais de corrente, tensão e potência.
- **Conexão MQTT:** Conecta-se a um broker MQTT em nuvem, como o HiveMQ, para transmissão de dados.
- **Interface de Usuário Simples:** Interface limpa e direta, exibindo os dados de consumo de energia de forma acessível.

### Aplicativo Simulado

Antes de desenvolver a versão funcional, foi criada uma versão simulada do aplicativo para fins de aprendizado e prototipagem.  
Esta versão utiliza dados simulados para testar a interface e a lógica de processamento, garantindo que todas as funcionalidades essenciais estejam corretamente implementadas antes de trabalhar com dados reais.

- **Simulação de Dados:** Gera dados simulados de corrente, tensão e potência.
- **Testes de Interface:** Permite verificar e ajustar a interface do usuário.
- **Prototipagem:** Auxilia no desenvolvimento e validação da lógica do aplicativo.

## Estrutura do Projeto

### Código do ESP32

O código do ESP32 é responsável por coletar dados dos sensores SCT013 e ZMPT101B, calcular os valores de corrente, tensão e potência, e enviar esses dados via MQTT para o aplicativo.

#### Componentes Utilizados

- **ESP32:** Microcontrolador com conectividade Wi-Fi.
- **SCT013:** Sensor de corrente não invasivo.
  - **Circuito Adicional:**
    - Capacitor de 470µF, 25V
    - Resistência de carga de 330Ω
- **ZMPT101B:** Sensor de tensão.
- **MQTT:** Protocolo de comunicação para transmissão de dados.

### Código do Aplicativo Funcional

O aplicativo funcional foi desenvolvido em Flutter e inclui várias telas e serviços para receber e exibir dados reais.

#### Principais Arquivos

- **`monitoramento_screen.dart`:** Tela principal do aplicativo, exibindo os dados de consumo de energia.
- **`mqtt_client.dart`:** Lógica para conexão e recepção de dados via MQTT.
- **`constantes.dart`:** Definição de constantes utilizadas no aplicativo.
- **`helpers.dart`:** Funções auxiliares para formatação de dados.
- **`main.dart`:** Ponto de entrada do aplicativo, configurando a interface do usuário e inicializando a conexão MQTT.

### Código do Aplicativo Simulado

A versão simulada do aplicativo foi utilizada para testar e validar a interface e a lógica de processamento antes de trabalhar com dados reais.

#### Principais Arquivos

- **`monitoramento_screen.dart`:** Tela principal do aplicativo, exibindo dados simulados.
- **`mqtt_service.dart`:** Gera e envia dados simulados.
- **`constantes.dart`:** Definição de constantes utilizadas no aplicativo.
- **`helpers.dart`:** Funções auxiliares para formatação de dados.
- **`main.dart`:** Ponto de entrada do aplicativo, configurando a interface do usuário e inicializando a simulação de dados.

## Configuração e Execução

### Requisitos

- **Hardware:**
  - ESP32
  - Sensor de corrente SCT013
  - Sensor de tensão ZMPT101B
  - Capacitor de 470µF, 25V
  - Resistência de carga de 330Ω

- **Software:**
  - [Flutter](https://flutter.dev) SDK
  - Broker MQTT (ex.: [HiveMQ](https://www.hivemq.com/mqtt-cloud/))

### Configuração do ESP32

1. Configure o ESP32 com os sensores SCT013 e ZMPT101B conforme o circuito adicional descrito.
2. Faça upload do código do ESP32 para coletar dados e enviá-los via MQTT.

### Configuração do Aplicativo Funcional

1. Clone este repositório.
   ```bash
   git clone https://github.com/ohamarals/Sistema-de-Monitoramento-de-Consumo-de-Energia-Eletrica.git
   ```
2. Navegue até o diretório do projeto.
   ```bash
   cd Sistema-de-Monitoramento-de-Consumo-de-Energia-Eletrica
   ```
3. Instale as dependências.
   ```bash
   flutter pub get
   ```
4. Configure os dados de conexão MQTT no arquivo `mqtt_client.dart`.
   ```dart
   final String serverUri = 'seu_servidor_hivemq.com';
   final String username = 'seu_username';
   final String password = 'sua_senha';
   final List<String> topics = [
     'seu_topico/tensao',
     'seu_topico/corrente',
     'seu_topico/potencia'
   ];
   ```
5. Execute o aplicativo.
   ```bash
   flutter run
   ```

### Configuração do Aplicativo Simulado

1. Clone o repositório da versão simulada.
   ```bash
   git clone https://github.com/ohamarals/Sistema-de-Monitoramento-de-Consumo-de-Energia-Eletrica-Simulado.git
   ```
2. Navegue até o diretório do projeto.
   ```bash
   cd Sistema-de-Monitoramento-de-Consumo-de-Energia-Eletrica-Simulado
   ```
3. Instale as dependências.
   ```bash
   flutter pub get
   ```
4. Execute o aplicativo.
   ```bash
   flutter run
   ```

## Agradecimentos

Este projeto foi desenvolvido com o apoio de:

- **Professor Evandro da Cunha:** Pelos insights e dicas valiosas na programação.
- **Professor Alessandro:** Pela orientação nos cálculos e conceitos técnicos.

---

**Guilherme Henrique Amaral Cevada**  
Ilha Solteira, São Paulo, Brasil  
Junho de 2024

## Nota Pessoal

Este projeto marca meu primeiro desenvolvimento como programador.  
Foi o primeiro contato com programação e desenvolvimento de aplicativos móveis, visando uma solução prática para o monitoramento de consumo de energia elétrica.  
Além disso, este projeto foi realizado em colaboração com meu grupo de Trabalho de Conclusão de Curso (TCC) e tem como objetivo não apenas a conclusão do curso, mas também o desenvolvimento de uma solução comercial e educativa.  
Pretendemos continuar trabalhando no aprimoramento deste projeto, visando seu crescimento e aplicabilidade no mercado.
