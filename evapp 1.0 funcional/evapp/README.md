# Enervision - Aplicativo Funcional

## Descrição

**Enervision** é um aplicativo desenvolvido por **Guilherme Henrique Amaral Cevada**, como parte do seu Trabalho de Conclusão de Curso (TCC) de Eletrotécnica.  
Este repositório contém a versão funcional do aplicativo, que recebe dados reais de tensão, corrente e potência através da conexão com o ESP32, SCT (sensor de corrente) e ZMPT101B (sensor de tensão).

## Objetivo

O objetivo principal desta versão é monitorar e gerenciar o consumo de energia elétrica em tempo real, utilizando sensores conectados ao ESP32.  
Os dados são transmitidos via MQTT para uma interface simples e intuitiva no aplicativo, permitindo uma visualização clara e imediata das medições.

## Funcionalidades

- **Monitoramento de Energia em Tempo Real:** Recebe e exibe dados reais de corrente, tensão e potência.
- **Conexão MQTT:** Conecta-se a um broker MQTT em nuvem, como o HiveMQ, para transmissão de dados.
- **Interface de Usuário Simples:** Interface limpa e direta, exibindo os dados de consumo de energia de forma acessível.
- **Configuração de Tópicos:** Permite a configuração de tópicos MQTT personalizados para testes e uso.

## Estrutura do Código

### `monitoramento_screen.dart`

Contém a tela principal do aplicativo, onde os dados reais de corrente, tensão e potência são exibidos.  
A interface é construída utilizando widgets do Flutter e atualiza automaticamente com os dados recebidos.

### `mqtt_client.dart`

Inclui a lógica para a conexão MQTT e a recepção de dados reais.  
Configura o cliente MQTT para se conectar ao broker e ouvir os tópicos de interesse, processando e exibindo os dados recebidos na interface.

### `constantes.dart`

Define constantes utilizadas no aplicativo, como cores, URLs do broker MQTT e tópicos.

### `helpers.dart`

Fornece funções auxiliares para formatação de dados, como a formatação de datas e valores de corrente e tensão.

### `main.dart`

Ponto de entrada do aplicativo.  
Configura a interface do usuário e inicializa a conexão MQTT para receber dados reais.

### `pubspec.yaml`

Arquivo de configuração do Flutter, listando as dependências necessárias e outras configurações do projeto.

## Como Executar

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

## Configuração do HiveMQ

Para utilizar o HiveMQ como broker MQTT:

1. Crie uma conta no [HiveMQ Cloud](https://www.hivemq.com/mqtt-cloud/).
2. Configure um cluster MQTT.
3. Use as credenciais fornecidas pelo HiveMQ Cloud (URI do servidor, username e senha) para configurar o cliente MQTT no arquivo `mqtt_client.dart`.

---

**Guilherme Henrique Amaral Cevada**  
Ilha Solteira, São Paulo, Brasil  
Junho de 2024

---

Se precisar de mais ajustes ou detalhes adicionais, estou à disposição.
