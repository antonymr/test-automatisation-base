Feature: Api personajes

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'

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
