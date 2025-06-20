Feature: Api personajes

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'
    * def generarTexto =
      """
      function(n) {
        var texto = '';
        var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        for (var i = 0; i < n; i++) {
          texto += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        return texto;
      }
      """
    * def textoRandom = generarTexto(12)

  @Get @all
  Scenario: Verificar que /characters responde 200 con un array
    Given path '/characters'
    When method get
    Then status 200
    Then match response == '#[]'

  @Get @all
  Scenario: Verificar que los elementos de /characters contienen id y nombre
    Given path '/characters'
    When method get
    Then match response[0] contains { id: '#number', name: '#string' }

  @Get @one
  Scenario: Verificar que el de /characters/{id} contienen id y nombre
    * def todos = call read('classpath:personajes/obtener-primero.feature')
    Given path '/characters/' + todos.response[0].id
    When method get
    Then match response contains { id: '#number', name: '#string' }

  @Get @one
  Scenario: Verificar que el de /characters/{id} devulve error con un id que no existe
    Given path '/characters/0'
    When method get
    Then status 404
    * response.error == 'Character not found'

  @Get @one
  Scenario: Verificar que el de /characters/{id} devulve error con un id mal formado
    Given path '/characters/aaaa'
    When method get
    Then status 500
    * response.error == 'Internal server error'

  @Post @one
  Scenario: Verificar que se crear un personaje nuevo
    Given path '/characters'
    And request { name: nameRandom, alterego: "anamcias", description: "Developer", powers: ["Angular", "Karate"]}
    When method post
    Then status 201
    * match response contains { id: '#number', name: '#string' }

  @Post @one
  Scenario: Verificar que se no se crea un personaje con datos vacios
    Given path '/characters'
    And request { name: nameRandom, alterego: "anamcias", description: "Developer", powers: ["Angular", "Karate"]}
    When method post
    Then status 400
    * response.error == "Character name already exists"

  @Post
  Scenario: Verificar que se no se crea un personaje con datos vacios
    Given path '/characters'
    And request { }
    When method post
    Then status 400
    * response.name == "Name is required"
    * response.description == "Description is required"
    * response.powers == "Powers are required"
    * response.alterego == "Alterego is required"

  @Put
  Scenario: Verificar que se cambia el primer personaje
    * def todos = call read('classpath:personajes/obtener-primero.feature')
    Given path '/characters/' + todos.response[0].id
    And request { name: "Iron Man" + todos.response[0].id , alterego: "Tony Stark", description: "Updated description",powers: ["Armor", "Flight"]}
    When method post
    Then status 200
    * match response contains { id: '#number', name: '#string' }

  @Put
  Scenario: Verificar que devuleve error cuando intento actualizar un personaje con un id que no existe
    * def todos = call read('classpath:personajes/obtener-primero.feature')
    Given path '/characters/1'
    And request { name: "Iron Man" + todos.response[0].id , alterego: "Tony Stark", description: "Updated description",powers: ["Armor", "Flight"]}
    When method post
    Then status 404
    * response.error == "Character not found"

  @Put
  Scenario: Verificar que devuleve error cuando intento actualizar un personaje con un id que no invalido
    * def todos = call read('classpath:personajes/obtener-primero.feature')
    Given path '/characters/aaa'
    And request { name: "Iron Man" + todos.response[0].id , alterego: "Tony Stark", description: "Updated description",powers: ["Armor", "Flight"]}
    When method post
    Then status 500
    * response.error == 'Internal server error'


