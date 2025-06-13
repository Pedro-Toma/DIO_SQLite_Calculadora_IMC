# (APRIMORADO) DIO_Desafio_Calculadora_IMC

### Funcionalidade
Receber dados do usuários na tela e exibir IMC, peso, altura, classificação e data de registro.

### Como foi desenvolvido?
Foi criada uma página de calculadora que utiliza a classe imc para armazenar peso, altura, imc e 
classificação de um registro e exibe na tela os dados em uma ListView.separated para melhor visualização.
Além disso foi utilizado o pacote "sqflite: ^2.4.2" para a persistência dos dados em um banco de dados 
que será armazenado com auxílio do pacote "path: ^1.9.0". Inclusive, foi colocada a opção de remover 
registro, deslizando o registro selecionado para um dos lados (Dismissible).

### Tecnologia Utilizada
- Dart
