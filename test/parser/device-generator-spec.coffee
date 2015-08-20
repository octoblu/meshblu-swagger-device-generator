_ = require 'lodash'
DeviceGenerator = require '../../parser/device-generator'

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
        @sut.toMessageSchema './test/samples/swagger/pet-store-2-0-swagger.json', (@error, @result) => done()

      it 'should return schemas with the correct titles', ->
        expect(@result).to.be.an 'object'
        titles = _.keys @result
        expect(titles).to.deep.equal [ 'title', 'getAllPets', 'createPet', 'deletePet', 'getPetById' ]

      it 'should return the correct properties for getAllPets', ->
        getAllPetsProperties =
          $schema: "http://json-schema.org/draft-04/schema#"
          additionalProperties: false
          type: "object"
          title: "Get All Pets"
          description: 'Finds all pets in the system'
          properties:
            action:
              type: 'hidden'
              default: 'getAllPets'
            options:
              additionalProperties: false
              title: "Get All Pets"
              type: 'object'
              properties:
                status:
                  title: "Status"
                  type: "string"
                  description: "The status to filter by"

        getAllPetsSchema = @result.getAllPets
        expect(getAllPetsSchema).to.deep.equal getAllPetsProperties

      it 'should return the correct properties for getAllPets', ->
        getPetByIdProperties =
            $schema: "http://json-schema.org/draft-04/schema#"
            additionalProperties: false
            type: "object"
            title: "Get All Pets"
            description: 'Finds all pets in the system'
            properties:
              action:
                type: 'hidden'
                default: 'getAllPets'
              options:
                additionalProperties: false
                title: "Get All Pets"
                type: 'object'
                properties:
                  status:
                    type: "string"
                    title: "Status"
                    description: "The status to filter by"
        getAllPetsSchema = @result.getAllPets
        expect(getAllPetsSchema).to.deep.equal getPetByIdProperties
