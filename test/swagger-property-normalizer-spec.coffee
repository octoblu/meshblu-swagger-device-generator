_ = require 'lodash'
SwaggerPropertyNormalizer = require '../swagger-property-normalizer'

describe 'SwaggerPropertyNormalizer', ->
  beforeEach ->
    @sut = SwaggerPropertyNormalizer
  it 'should exist', ->
    expect(@sut).to.exist

  describe '.generateBaseUrl', ->
    it 'should exist', ->
      expect(@sut.getBaseUrl).to.exist

    describe 'when called with a swagger file containing an http scheme', ->
      beforeEach ->
        @result = @sut.getBaseUrl @petSwagger

      it 'should return the right base url', ->
        expect(@result).to.equal 'http://petstore.swagger.wordnik.com/api'
        
  describe '.fixSchemaProperty', ->

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
