Feature: Obtener el primer personaje del array

  Background:
    * configure ssl = true

  @Get @all
  Scenario: Verificar que /characters responde 200 con un array
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    When method get
    Then status 200
    * def personaje = response[0]