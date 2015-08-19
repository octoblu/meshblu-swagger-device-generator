_ = require 'lodash'
Swagger2ToProxyConfig = require '../swagger-2-to-proxy-config'
describe 'Swagger2ToProxyConfig', ->
  beforeEach ->
    @petsSwagger = require './swagger/pets-resolved.json'
    @sut = new Swagger2ToProxyConfig @petsSwagger

  it 'should exist', ->
    expect(@sut).to.exist

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
        expect(@result.body).to.not.exist

    describe 'when called with an action name with query params', ->
      beforeEach ->
        @petsSwagger.paths['/pets'].get.parameters = [
          { name: "pet_status", in: "query"}
          { name: "pet_name", in: "query"}
        ]

        @result = @sut.generateProxyActionConfig 'getAllPets'

      it 'should return a proxy config with query parameters', ->
        expect(@result.qs).to.exist

      it 'should return a proxy config with query parameters that map to message properties', ->
        messagePropertyMap =
          pet_status: "options.petStatus"
          pet_name: "options.petName"

        expect(@result.qs).to.deep.equal messagePropertyMap


    xdescribe 'when called with an action name with post data', ->
      beforeEach ->
        @petsSwagger.paths['/pets'].post.parameters = [
          { name: "pet_status", in: "query"}
          { name: "pet_name", in: "query"}
        ]
        @result = @sut.generateProxyActionConfig 'createPet'

      it 'should return a proxy config with body parameters', ->
        expect(@result.body).to.exist

      it 'should return a proxy config with body parameters that map to message properties', ->
        messagePropertyMap =
          monster_type: "options.monsterType"
          monster_name: "options.monsterName"

        expect(@result.body).to.equal messagePropertyMap

  describe '.getParameterNameMap', ->
    describe 'when called with parameters with the names we want', ->
      beforeEach ->
        @sut.getParametersForAction = sinon.stub().returns [ name: "id" ]
        @result = @sut.getParameterNameMap 'getPetById'

      it 'should return an empty map', ->
        expect(@result).to.deep.equal {}

    describe "when called with parameters with the names we don't want", ->
      beforeEach ->
        @sut.getParametersForAction = sinon.stub().returns [
            { name: "Bandit" }
            { name: "mastiff" }
            { name: "bandit_captain" }
        ]

        @result = @sut.getParameterNameMap 'getPetById'

      it 'should return an empty map', ->
        expect(@result).to.deep.equal {
          "bandit": "Bandit"
          "banditCaptain": "bandit_captain"
        }

    describe "when called with parameters with the names we don't want", ->
      beforeEach ->
        @sut.getParametersForAction = sinon.stub().returns [
            { name: "Bandit" }
            { name: "mastiff" }
            { name: "bandit_captain" }
        ]

        @result = @sut.getParameterNameMap 'getPetById'

      it 'should return an empty map', ->
        expect(@result).to.deep.equal {
          "bandit": "Bandit"
          "banditCaptain": "bandit_captain"
        }


    describe "when called with parameters with a schema", ->
      beforeEach ->
        @sut.getParametersForAction = sinon.stub().returns [
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

        @result = @sut.getParameterNameMap 'getPetById'

      it 'should return an empty map', ->
        expect(@result).to.deep.equal {
          "bandit": "Bandit"
          "banditCaptain": "bandit_captain"
          "monsterId": "monster_id"
          "braveryLevel": "bravery_level"
        }

    describe "when called with parameters with a schema with nested properties", ->
      beforeEach ->
        @sut.getParametersForAction = sinon.stub().returns [
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

        @result = @sut.getParameterNameMap 'getPetById'

      it 'should return an empty map', ->
        expect(@result).to.deep.equal {
          "bandit": "Bandit"
          "banditCaptain": "bandit_captain"
          "monsterId": "monster_id"
          "braveryLevel": "bravery_level"
          "averageEducationLevel": "average_education_level"
        }
