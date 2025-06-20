Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/joseph_marquez_mazzini'


  Scenario: Crear personaje (exitoso)
    * def create_character_request =
    """
    {
        "name": "Superman",
        "alterego": "Tommy Black",
        "description": "Sobrenarual",
        "powers": [
            "Vuela rapido",
            "Rayos en los ojos"
        ]
    }
    """
    Given path '/api/characters'
    And request create_character_request
    When method post
    Then status 201


  Scenario: Crear personaje (nombre duplicado)
    * def create_character_request =
    """
    {
      "name": "Dog-Man",
      "alterego": "Juan Lopez",
      "description": "Superhéroe de los perros de uio",
      "powers": ["Sentido perruno", "Olfatear"]
    }
    """
    * def error_message = 'Character name already exists'
    Given path '/api/characters'
    And request create_character_request
    When method post
    Then status 400
    And match response.error == error_message

  Scenario: Crear personaje (faltan campos requeridos)
    * def create_character_request =
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """
    Given path '/api/characters'
    And request create_character_request
    When method post
    Then status 400
    And match response.name == 'Name is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'
    And match response.alterego == 'Alterego is required'

  Scenario: Obtener todos los personajes
    Given path '/api/characters'
    When method get
    Then status 200
    * print response

  Scenario: Obtener personaje por ID (exitoso)
    Given path '/api/characters'
    When method get
    Then status 200

    Given path '/api/characters/', response[0].id
    When method get
    Then status 200

  Scenario: Obtener personaje por ID (no existe)
    Given path '/api/characters/', 999
    When method get
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Actualizar personaje (exitoso)
    * def update_character_request =
    """
    {
      "name": "Cat-Man",
      "alterego": "Juan Piguave",
      "description": "Superhéroe de los gatos de gye",
      "powers": [
            "Agilidad",
            "Sentido gatuno",
            "Trepar techos"
        ]
    }
    """
    Given path '/api/characters/', 8
    And request update_character_request
    When method put
    Then status 200

  Scenario: Actualizar personaje (no existe)
    * def update_character_request =
    """
    {
      "name": "Cat-Man",
      "alterego": "Luis Torres",
      "description": "Superhéroe de los gatos de uio",
      "powers": ["Sentido gatuno", "Trepar techos"]
    }
    """
    Given path '/api/characters/', 999
    And request update_character_request
    When method put
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Eliminar personaje (exitoso)
    Given path '/api/characters/', 11
    When method delete
    Then status 204

  Scenario: Eliminar personaje (no existe)
    Given path '/api/characters/', 999
    When method delete
    Then status 404
    And match response.error == 'Character not found'
