_ = require 'lodash'
Swagger2ToProxyConfig = require '../../parser/swagger-2-to-proxy-config'
describe 'Swagger2ToProxyConfig', ->
  beforeEach ->
    @petsSwagger = require '../samples/swagger/pets-resolved.json'
    @sut = new Swagger2ToProxyConfig @petsSwagger

  it 'should exist', ->
    expect(@sut).to.exist

  describe '.generateProxyAction', ->
    describe 'when called', ->
      beforeEach ->
        @result = @sut.generateProxyConfig()

        it 'should return an object with requestOptions', ->
          expect(@result.requestOptions).to.exist

        it 'should return an object with requestOptions for each action', ->
          expect(_.keys @result.requestOptions).to.deep.equal [
            "getAllPets"
            "createPet"
            "deletePet"
            "getPetById"
          ]

  describe '.generateProxyActionConfig', ->
    it 'should exist', ->
      expect(@sut.generateProxyActionConfig).to.exist

    describe 'when called with an action name', ->
      beforeEach ->
        @result = @sut.generateProxyActionConfig 'getPetById'

      it 'should return the proxy config uri', ->
        expect(@result.uri).to.equal '\"http://petstore.swagger.wordnik.com/api/pets/#{options.id}\"'

      it 'should return the method', ->
        expect(@result.method).to.equal 'GET'

      it 'should not return body params', ->
        expect(@result.body).to.deep.equal []

    describe 'when called with an action name with query and body params', ->
      beforeEach ->
        @petsSwagger.paths['/pets'].get.parameters = [
          { name: "pet_status", in: "query"}
          { name: "pet_name", in: "query"}
          { name: "pet_type", in: "body"}
          { name: "pet_age", in: "body"}
        ]

        @result = @sut.generateProxyActionConfig 'getAllPets'

      it 'should return a proxy config with query parameters', ->
        expect(@result.qs).to.exist

      it 'should return an array containing the query parameter names', ->
        expect(@result.qs).to.deep.equal ['pet_status', 'pet_name']

      it 'should return a proxy config with body parameters', ->
        expect(@result.body).to.deep.equal ['pet_type', 'pet_age']

      it 'should return a proxy config with query parameters that map to message properties', ->
        messagePropertyMap =
          pet_status: "petStatus"
          pet_name: "petName"
          pet_type: "petType"
          pet_age: "petAge"

        expect(@result.messagePropertyMap).to.deep.equal messagePropertyMap


    describe 'when called with an action name with post data', ->
      beforeEach ->
        @petsSwagger.paths['/pets'].post.parameters = [
          { name: "pet_status", in: "query"}
          { name: "pet_name", in: "query"}
        ]
        @result = @sut.generateProxyActionConfig 'createPet'
        console.log JSON.stringify @result, null, 2

      it 'should return a proxy config with body parameters', ->
        expect(@result.messagePropertyMap).to.exist

      it 'should return a proxy config with body parameters that map to message properties', ->
        messagePropertyMap =
          pet_status: "petStatus"
          pet_name: "petName"

        expect(@result.messagePropertyMap).to.deep.equal messagePropertyMap

  describe '.getParameterNameMap', ->
    describe 'when called with parameters with the names we want', ->
      beforeEach ->
        @result = @sut.getParameterNameMap [ name: "id" ]

      it 'should return an empty map', ->
        expect(@result).to.deep.equal {}

    describe "when called with parameters with the names we don't want", ->
      beforeEach ->
        @parameters = [
            { name: "Bandit" }
            { name: "mastiff" }
            { name: "bandit_captain" }
        ]

        @result = @sut.getParameterNameMap @parameters

      it 'should return an empty map', ->
        expect(@result).to.deep.equal {
          "bandit": "Bandit"
          "banditCaptain": "bandit_captain"
        }

    describe "when called with parameters with the names we don't want", ->
      beforeEach ->
        @parameters = [
            { name: "Bandit" }
            { name: "mastiff" }
            { name: "bandit_captain" }
        ]

        @result = @sut.getParameterNameMap @parameters

      it 'should return an empty map', ->
        expect(@result).to.deep.equal {
          "bandit": "Bandit"
          "banditCaptain": "bandit_captain"
        }


    describe "when called with parameters with a schema", ->
      beforeEach ->
        @parameters = [
            { name: "Bandit" }
            { name: "mastiff" }
            { name: "bandit_captain" }
            { name: "stats", schema:
                allOf: [
                  {
                    properties:
                      monster_id: true
                      bravery_level: true
                      strength: true
                      dexterity: true
                  }
                ]
            }
        ]

        @result = @sut.getParameterNameMap @parameters

      it 'should return an empty map', ->
        expect(@result).to.deep.equal {
          "bandit": "Bandit"
          "banditCaptain": "bandit_captain"
          "monsterId": "monster_id"
          "braveryLevel": "bravery_level"
        }

    describe "when called with parameters with a schema with nested properties", ->
      beforeEach ->
        @parameters = [
            { name: "Bandit" }
            { name: "mastiff" }
            { name: "bandit_captain" }
            { name: "stats", schema:
                allOf: [
                  {
                    properties:
                      nation:
                        type: "object"
                        properties:
                          population:
                            type: "integer"
                          average_education_level:
                            type: "integer"

                      monster_id: true
                      bravery_level: true
                      strength: true
                      dexterity: true
                  }
                ]
            }
        ]

        @result = @sut.getParameterNameMap @parameters

      it 'should return an empty map', ->
        expect(@result).to.deep.equal {
          "bandit": "Bandit"
          "banditCaptain": "bandit_captain"
          "monsterId": "monster_id"
          "braveryLevel": "bravery_level"
          "averageEducationLevel": "average_education_level"
        }

  describe 'getParameterTypeMap', ->
    describe 'when called with some youtube parameters', ->
      beforeEach ->
        @parameters = [
          { in: "query", name: "part" }
          { in: "query", name: "onBehalfOfContentOwner" }
          { in: "query", name: "onBehalfOfContentOwnerChannel" }
          {
            in: "body"
            name: "body"
            schema:
              properties:
                contentDetails:
                  properties:
                    itemCount:
                      type: "integer"
                  type: "object"
                etag:
                  type: "string"
                id:
                  type: "string"
                kind:
                  type: "string"
                status:
                  properties:
                    privacyStatus:
                      type: "string"
                  type: "object"
              type: "object"
          }
        ]
        @result = @sut.getParameterTypeMap @parameters

      it 'should return an object with qs and body keys', ->
        expect(@result.qs).to.exist
        expect(@result.body).to.exist

      it 'should have all the query param names in qs', ->
        expect(@result.qs).to.deep.equal [
          "part"
          "onBehalfOfContentOwner"
          "onBehalfOfContentOwnerChannel"
        ]

      it 'should contain all the body params in body', ->
        expect(@result.body).to.deep.equal [
          "contentDetails"
          "etag"
          "id"
          "kind"
          "status"
        ]


  describe 'when called with parameters that have allOf in their schemas', ->
    beforeEach ->
      @parameters = [{
        in: "body"
        name: "pet"
        schema:
          allOf: [{
            "properties": {
              "id": {
                "type": "integer"
              },
              "name": {
                "type": "string"
              }
            },
            "required": [
              "id",
              "name"
            ]
          }]
      }]
      @result = @sut.getParameterTypeMap @parameters

    it 'should contain all the body params in body', ->
      expect(@result.body).to.deep.equal [
        "id"
        "name"
      ]
