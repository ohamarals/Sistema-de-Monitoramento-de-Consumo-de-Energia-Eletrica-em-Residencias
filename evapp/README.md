# Enervision - Aplicativo Simulado

## Descrição

**Enervision** é um aplicativo desenvolvido por **Guilherme Henrique Amaral Cevada**, como parte do seu Trabalho de Conclusão de Curso (TCC) de Eletrotécnica.  
Este repositório contém a versão simulada do aplicativo, onde os dados de tensão, corrente e potência são simulados para testar e prototipar a funcionalidade do sistema antes da implementação com sensores reais.

## Objetivo

O principal objetivo desta versão simulada é proporcionar aprendizado e compreensão do fluxo de dados e da interface do usuário.  
Esta versão permite identificar e corrigir problemas, além de planejar e implementar futuras funcionalidades de maneira mais eficiente.

## Funcionalidades

- **Monitoramento Simulado de Energia:** Exibe dados simulados de corrente, tensão e potência.
- **Interface de Usuário Amigável:** Proporciona uma visualização clara e acessível dos dados simulados.
- **Simulação de Dados:** Gera dados simulados para corrente, tensão e potência, facilitando a prototipagem e testes sem a necessidade de hardware real.

## Estrutura do Código

### `monitoramento_screen.dart`

Contém a tela principal do aplicativo, onde os dados simulados de corrente, tensão e potência são exibidos.  
A interface é construída utilizando widgets do Flutter.

### `mqtt_client.dart`

Inclui a lógica para a conexão MQTT e a recepção de dados simulados.  
Através do MQTT, o aplicativo se conecta a um broker e recebe dados simulados, que são processados e exibidos na interface.

### `constantes.dart`

Define constantes utilizadas no aplicativo, como cores, URLs do broker MQTT e tópicos.

### `helpers.dart`

Fornece funções auxiliares para formatação de dados, como a formatação de datas e valores de corrente e tensão.

### `main.dart`

Ponto de entrada do aplicativo.  
Configura a interface do usuário e inicializa a conexão MQTT para receber dados simulados.

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
4. Execute o aplicativo.
   ```bash
   flutter run
   ```
---

**Guilherme Henrique Amaral Cevada**  
Ilha Solteira, São Paulo, Brasil  
Junho de 2024
