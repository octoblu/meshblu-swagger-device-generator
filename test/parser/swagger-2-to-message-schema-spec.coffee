Swagger2ToMessageSchema = require '../../parser/swagger-2-to-message-schema'
describe 'Swagger2ToMessageSchema', ->
  it 'should exist', ->
    expect(Swagger2ToMessageSchema).to.exist

  describe 'constructor', ->
    describe 'when called with a swagger object', ->
      beforeEach ->
        @sut = new Swagger2ToMessageSchema {}

      it 'should exist', ->
        expect(@sut).to.exist

  describe '.generateMessageSchema', ->
    describe 'after being constructed with a swagger object', ->
      beforeEach ->
        @petsSwagger = require '../samples/swagger/pets-resolved.json'
        @sut = new Swagger2ToMessageSchema @petsSwagger

      it 'should exist', ->
        expect(@sut.generateMessageSchema).to.exist

      describe 'when called with an action and a swagger path', ->
        beforeEach ->
          @result = @sut.generateMessageSchema 'getPetById', @sut.swagger.paths['/pets/{id}'].get

        it 'should return a proxy config with the correct uri', ->
          expect(@result).to.deep.equal(
              $schema: "http://json-schema.org/draft-04/schema#"
              description: 'Finds the pet by id'
              type: "object"
              title: 'Get Pet By Id'
              additionalProperties: false
              properties:
                action:
                  type: 'hidden'
                  default: 'getPetById'
                options:
                  additionalProperties: false
                  title: 'Get Pet By Id'
                  type: "object"
                  properties:
                    id:
                      title: 'Id'
                      type: 'integer'
                      description: "ID of pet"
                      required: true
          )
