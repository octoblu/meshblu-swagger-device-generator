Swagger2ToMessageSchema = require '../swagger-2-to-message-schema.coffee'
fs = require 'fs'
describe 'Swagger2ToMessageSchema', ->
  it 'should exist', ->
    expect(Swagger2ToMessageSchema).to.exist

  describe 'constructor', ->
    describe 'when called with a swagger object', ->
      beforeEach ->
        @sut = new Swagger2ToMessageSchema {}

      it 'should exist', ->
        expect(@sut).to.exist

  describe '.getActionProperties', ->
    describe 'after being constructed with a swagger object', ->
      beforeEach ->
        @petsSwagger = require './swagger/pets-resolved.json'
        @sut = new Swagger2ToMessageSchema()
        @sut.swagger =
          paths:
            '/pets':
                get: @petsSwagger.paths['/pets'].get
                post: @petsSwagger.paths['/pets'].post

        @sut.setupActionIndex()

      it 'should exist', ->
        expect(@sut.getActionProperties).to.exist


      describe 'when called with an action with parameters', ->
        beforeEach ->
          @result = @sut.getActionProperties @sut.swagger.paths['/pets'].get

        it 'should return the appropriate json schema property', ->
          expect(@result).to.deep.equal(
              type: 'object'
              properties:
                status:
                  type: "string"
                  description: 'The status to filter by'
          )

      describe 'when called with an action with a schema', ->
        beforeEach ->
          @result = @sut.getActionProperties @sut.swagger.paths['/pets'].post
          fs.writeFileSync 'temp-schema.json', JSON.stringify @result, null, 2
        it 'should return the appropriate json schema property', ->
          expect(@result).to.deep.equal(
              type: 'object'
              properties:
                status:
                  type: "string"
                  description: 'The status to filter by'
          )
