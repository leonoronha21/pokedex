# Pokédex Flutter - Leonardo Noronha de Andrade

Este é um aplicativo Flutter que utiliza a PokéAPI para exibir uma Pokédex moderna, responsiva e em português, com gerenciamento de estado MobX.

## Funcionalidades

- **Tela inicial:**
  - Lista de Pokémon com nome e imagem.
  - Busca por nome.
  - Scroll infinito para carregar mais Pokémon.
  - Layout responsivo e visual moderno.
- **Tela de detalhes:**
  - Exibe nome, número, altura, peso, tipos, habilidades, egg groups, flavor text, espécie, stats e evolução.
  - Imagem do Pokémon em destaque.
  - Abas para stats e evolução.
  - Textos em português quando disponíveis.
- **Tratamento de erros:**
  - Mensagens amigáveis em caso de falha na API ou busca sem resultados.
- **Internacionalização:**
  - Busca textos em português na PokéAPI.
- **Gerenciamento de estado:**
  - Utiliza MobX para reatividade e organização.

## Estrutura do Projeto

```
lib/
  main.dart
  assets/
    pokebola.png
  controller/
    DetalhesController.dart
  store/
    pokemons_store.dart
    pokemons_store.g.dart
  theme/
    app_theme.dart
  view/
    Pokemons.dart
    Detalhes.dart
```

## Como executar

1. **Clone o repositório:**
   ```sh
   git clone <url-do-repositorio>
   cd pokedex_leonardo_noronha_de_andrade
   ```
2. **Instale as dependências:**
   ```sh
   flutter pub get
   ```
3. **Execute o build do MobX (se necessário):**
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. **Execute o app:**
   ```sh
   flutter run
   ```

## Observações
- O asset da pokebola está em `lib/assets/pokebola.png` e já está referenciado no `pubspec.yaml`.
- O app utiliza apenas dependências open source.
- O layout é responsivo e funciona em diferentes tamanhos de tela.
- O código segue boas práticas de organização e separação de responsabilidades.

## Tecnologias utilizadas
- Flutter
- MobX
- PokéAPI
- HTTP

## Autor
Leonardo Noronha de Andrade

---

Sinta-se à vontade para sugerir melhorias ou reportar issues!
