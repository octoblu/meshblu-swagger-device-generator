Swagger2ToMessageSchema = require '../swagger-2-to-message-schema.coffee'
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
        @petsSwagger = require './swagger/pets-resolved.json'
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

  describe '.fixSchemaProperty', ->
    beforeEach ->
        @sut = new Swagger2ToMessageSchema()

    describe 'when called with a simple schema property', ->
      beforeEach ->
        @result = @sut.fixSchemaProperty(
          type: "string"
          description: 'The status to filter by'
        )

      it 'should return the fixed schema property', ->
        expect(@result).to.deep.equal(
          type: "string"
          description: 'The status to filter by'
        )

    describe 'when called with an object schema property', ->
      beforeEach ->
        @result = @sut.fixSchemaProperty(
          required: true
          properties:
            status:
              type: "string"
              description: 'The status to filter by'
        )

      it 'should return the fixed schema property', ->
        expect(@result).to.deep.equal(
          type: "object"
          properties:
            status:
              type: "string"
              description: 'The status to filter by'
        )

    describe 'when called with an object schema property', ->
      beforeEach ->
        @result = @sut.fixSchemaProperty(
          required: true
          properties:
            limbs:
              required: true
              properties:
                legs:
                  description: "things you use to walk"
                  required: true
                  properties:
                    length:
                      type: "integer"
                      minimum: 15
                      maximum: 30
        )

      it 'should return the fixed schema property that contains objects', ->
        expect(@result).to.deep.equal(
          type: "object"
          properties:
            limbs:
              type: "object"
              properties:
                legs:
                  type: "object"
                  description: "things you use to walk"
                  properties:
                    length:
                      type: "integer"
                      minimum: 15
                      maximum: 30
        )

    describe 'when called with an array schema property', ->
      beforeEach ->
        @result = @sut.fixSchemaProperty(
          type: "array"
          required: true
          items:
            length:
              type: "integer"
              minimum: 15
              maximum: 30
        )

      it 'should return the fixed schema property', ->
        expect(@result).to.deep.equal(
          type: "array"
          items:
            length:
              type: "integer"
              minimum: 15
              maximum: 30
        )

      describe 'when called with an array schema property that contains objects', ->
        beforeEach ->
          @result = @sut.fixSchemaProperty(
            type: "array"
            required: true
            items:
              properties:
                category:
                  required: true
                  properties:
                    id:
                      required: true
                      format: "int64"
                      type: "integer"
                    name:
                      required: true
                      type: "string"
                id:
                  required: true
                  description: "unique identifier for the pet"
                  format: "int64"
                  maximum: 100
                  minimum: 0
                  type: "integer"
          )

        it 'should return the fixed schema property', ->
          expect(@result).to.deep.equal(
              type: "array"
              items:
                type: "object"
                properties:
                  category:
                    type: "object"
                    properties:
                      id:
                        required: true
                        format: "int64"
                        type: "integer"
                      name:
                        required: true
                        type: "string"
                  id:
                    required: true
                    description: "unique identifier for the pet"
                    format: "int64"
                    maximum: 100
                    minimum: 0
                    type: "integer"
          )

      describe 'when called with an array schema property that contains arrays', ->
        beforeEach ->
          @result = @sut.fixSchemaProperty(
            type: "array"
            required: true
            items:
              type: "array"
              required: true
              items:
                properties:
                  category:
                    required: true
                    properties:
                      id:
                        required: true
                        format: "int64"
                        type: "integer"
                      name:
                        required: true
                        type: "string"
                  id:
                    required: true
                    description: "unique identifier for the pet"
                    format: "int64"
                    maximum: 100
                    minimum: 0
                    type: "integer"
          )

        it 'should return the fixed schema property', ->
          expect(@result).to.deep.equal(
              type: "array"
              items:
                type: "array"
                items:
                  type: "object"
                  properties:
                    category:
                      type: "object"
                      properties:
                        id:
                          required: true
                          format: "int64"
                          type: "integer"
                        name:
                          required: true
                          type: "string"
                    id:
                      required: true
                      description: "unique identifier for the pet"
                      format: "int64"
                      maximum: 100
                      minimum: 0
                      type: "integer"
          )
