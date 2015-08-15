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
        expect(@result).to.be.an 'object'
        titles = _.keys @result
        expect(titles).to.deep.equal [ 'title', 'getAllPets', 'createPet', 'deletePet', 'getPetById' ]

      it 'should return the correct properties for getAllPets', ->
        getAllPetsProperties =
            type: "object"
            title: "getAllPets"
            description: 'Finds all pets in the system'
            additionalProperties: false
            properties:
              action:
                type: 'hidden'
                default: 'getAllPets'
              options:
                type: 'object'
                properties:
                  status:
                    type: "string"
                    description: "The status to filter by"
        getAllPetsSchema = _.findWhere @result, title: 'getAllPets'
        expect(getAllPetsSchema).to.deep.equal getAllPetsProperties

      it 'should return the correct properties for getPetById', ->
        getPetByIdProperties =
            type: "object"
            title: "getAllPets"
            description: 'Finds all pets in the system'
            additionalProperties: false
            properties:
              action:
                type: 'hidden'
                default: 'getAllPets'
              options:
                type: 'object'
                properties:
                  status:
                    type: "string"
                    description: "The status to filter by"
        getAllPetsSchema = _.findWhere @result, title: 'getAllPets'
        expect(getAllPetsSchema).to.deep.equal getPetByIdProperties

  xdescribe '.toForm ->', ->
    describe 'when called with pet-store v2.0', ->
      beforeEach (done) ->
        @sut = new DeviceGenerator
        @sut.toForm './test/swagger/pet-store-2-0-swagger.json', (@error, @result) => done()

      it 'should return keys for all the subschema', ->
        console.log JSON.stringify @result, null, 2
        actionNames = _.keys @result
        expect(actionNames).to.contain.all(          
          "getAllPets"
          "createPet"
          "deletePet"
          "getPetById"
        )
