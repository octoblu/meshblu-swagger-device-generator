DeviceGenerator = require '../device-generator'

describe 'DeviceGenerator', ->
  it 'should exist', ->
    expect(DeviceGenerator).to.exist

  describe 'constructor', ->
    describe 'when called with a path to a swagger file', ->
      beforeEach ->
        @sut = new DeviceGenerator './test/swagger/hello-world-swagger.json'

      it 'should exist', ->
        expect(@sut).to.exist

  describe '.toMessageSchema ->', ->
    describe 'when DeviceGenerator is called with pet-store v2.0', ->

      beforeEach ->
        @sut = new DeviceGenerator './test/swagger/pet-store-2-0-swagger.json'

      describe 'when called', ->

        beforeEach (done) ->
          @sut.toMessageSchema (@error, @result) => done()

        it 'should return the subschema enumeration', ->
          expect(@result.properties.subschema.type).to.equal 'string'
          expect(@result.properties.subschema.enum).to.deep.equal [ 'getAllPets', 'createPet', 'deletePet', 'getPetById' ]

        it 'should return the correct properties for getAllPets', ->
          getAllPetsProperties =
              type: "object"
              properties:
                status:
                  type: "string"
                  description: "The status to filter by"
                  
          expect(@result.properties.getAllPets).to.deep.equal getAllPetsProperties
