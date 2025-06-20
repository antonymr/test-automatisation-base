Feature: Api personajes

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'
    * def nameRandom = 'Hero-' + java.util.UUID.randomUUID()

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

  Scenario: Crear nuevo personaje, obtener personaje creado, verificar que no puedo volver a crear con el mismo nombre, eliminarlo y comprabar que no puedo obtenerlo
    # Post crear persona
    Given path '/characters'
    And request { name: "#(nameRandom)", alterego: "anamcias", description: "Developer", powers: ["Angular", "Karate"]}
    When method post
    Then status 201
    * def nuevoId = response.id
    #get personaje creado
    Given path '/characters/' + nuevoId
    When method get
    Then match response contains { id: '#number', name: '#string' }
    * response.id == nuevoId
    * response.name == "#(nameRandom)"
    # Post intertar crear nuevamente
    Given path '/characters'
    And request { name: "#(nameRandom)", alterego: "anamcias", description: "Developer", powers: ["Angular", "Karate"]}
    When method post
    Then status 400
    * response.error == "Character name already exists"
    # Delete Elimnar Personaje Creado
    Given path '/characters/' + nuevoId
    When method delete
    Then status 204
    # Obtener personaje eliminado
    Given path '/characters/0'
    When method get
    Then status 404
    * response.error == 'Character not found'

  Scenario: Crear personaje, actualizarlo y eliminarlo
    # Post crear personaje
    Given path '/characters'
    And request { name: "#(nameRandom)", alterego: "anamcias", description: "Developer", powers: ["Angular", "Karate"]}
    When method post
    Then status 201
    * def nuevoId = response.id
    # Put actualizar personaje creado
    Given path '/characters/' + nuevoId
    And request { name: "anmacias #(nameRandom)", alterego: "Tony Stark", description: "Updated description",powers: ["Armor", "Flight"]}
    When method put
    Then status 200
    * match response contains { id: '#number', name: '#string' }
    # Delete Elimnar Personaje Creado
    Given path '/characters/' + nuevoId
    When method delete
    Then status 204

  @Get @one
  Scenario: Verificar que el de /characters/{id} devulve error con un id mal formado
    Given path '/characters/aaaa'
    When method get
    Then status 500
    * response.error == 'Internal server error'

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
  Scenario: Verificar que devuleve error cuando intento actualizar un personaje con un id que no existe
    Given path '/characters/1'
    And request { name: "Iron Man #(todos.response[0].id)" , alterego: "Tony Stark", description: "Updated description",powers: ["Armor", "Flight"]}
    When method put
    Then status 404
    * response.error == "Character not found"

  @Put
  Scenario: Verificar que devuleve error cuando intento actualizar un personaje con un id que no invalido
    Given path '/characters/aaa'
    And request { name: "Iron Man)" , alterego: "Tony Stark", description: "Updated description",powers: ["Armor", "Flight"]}
    When method put
    Then status 500
    * response.error == 'Internal server error'

  @Delete
  Scenario: Verificar que devuleve error cuando elimino un registro que no existe
    Given path '/characters/1'
    When method delete
    Then status 404
    * response.error == "Character not found"

  @Delete
  Scenario: Verificar que devuleve error cuando elimino un registro con un id invalido
    Given path '/characters/aaaaa'
    When method delete
    Then status 500
    * response.error == 'Internal server error'


