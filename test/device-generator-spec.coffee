_ = require 'lodash'
DeviceGenerator = require '../device-generator'

describe 'DeviceGenerator', ->
  it 'should exist', ->
    expect(DeviceGenerator).to.exist

  describe 'constructor', ->
    describe 'when called', ->
      beforeEach ->
        @sut = new DeviceGenerator

      it 'should exist', ->
        expect(@sut).to.exist

  describe '.toMessageSchema ->', ->
    describe 'when called with pet-store v2.0', ->
      beforeEach (done) ->
        @sut = new DeviceGenerator
        @sut.toMessageSchema './test/swagger/pet-store-2-0-swagger.json', (@error, @result) => done()

      it 'should return schemas with the correct titles', ->
        expect(@result).to.be.an 'array'
        titles = _.pluck @result, 'title'
        expect(titles).to.deep.equal [ 'getAllPets', 'createPet', 'deletePet', 'getPetById' ]

      it 'should return the correct properties for getAllPets', ->
        getAllPetsProperties =
            type: "object"
            title: "getAllPets"
            description: 'Finds all pets in the system'
            properties:
              status:
                type: "string"
                description: "The status to filter by"
        getAllPetsSchema = _.findWhere @result, title: 'getAllPets'
        expect(getAllPetsSchema).to.deep.equal getAllPetsProperties

      it 'should return the correct properties for getPetById', ->
        getAllPetsProperties =
            type: "object"
            title: "getAllPets"
            description: 'Finds all pets in the system'
            properties:
              status:
                type: "string"
                description: "The status to filter by"
        getAllPetsSchema = _.findWhere @result, title: 'getAllPets'
        expect(getAllPetsSchema).to.deep.equal getAllPetsProperties

  describe '.toForm ->', ->
    describe 'when called with pet-store v2.0', ->
      beforeEach (done) ->
        @sut = new DeviceGenerator
        @sut.toForm './test/swagger/pet-store-2-0-swagger.json', (@error, @result) => done()

      it 'should return the subschema enumeration', ->
        actionNames = _.pluck @result, 'key'
        expect(actionNames).to.contain.all(
          "subschema"
          "getAllPets"
          "createPet"
          "deletePet"
          "getPetById"
        )
