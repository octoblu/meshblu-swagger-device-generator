_ = require 'lodash'
MessageSchemaToForm = require '../message-schema-to-form.coffee'
xdescribe 'MessageSchemaToForm', ->
  beforeEach ->
    @sut = new MessageSchemaToForm
  it 'should exist', ->
    expect(MessageSchemaToForm).to.exist
    expect(@sut).to.exist

  describe '.transform ->', ->
    it 'should exist', ->
      expect(@sut.transform).to.exist

    describe 'when called', ->
      beforeEach ->
        @getFormOutput = hello: 'hi'
        @sut.getForm = sinon.stub().returns @getFormOutput
        @messageSchema = require './message-schema/pet-store-message-schema.json'
        @result = @sut.transform @messageSchema

      it 'should return the output from getForm', ->
        expect(_.keys @result).to.deep.equal [
          "getAllPets"
          "createPet"
          "deletePet"
          "getPetById"
        ]

      it 'should call getForm with the schema properties', ->
        expect(@sut.getForm).to.have.been.calledWith @messageSchema.getAllPets.properties

  describe '.getForm ->', ->
    describe 'when called with a message schema', ->
      beforeEach ->
        @messageSchema =          
          getAllPets:
            type: 'object'
            description: 'Finds all pets in the system'
            properties:
              status:
                description: 'The status to filter by'
                type: 'string'

          createPet:
            type: 'object'

          deletePet:
            type: 'object'
            properties:
              id:
                description: 'ID of pet to delete'
                type: 'integer'
                required: true

          getPetById:
            type: 'object'
            description: 'Finds the pet by id'

        @result = @sut.getForm @messageSchema.deletePet.properties

      it 'should contain options and an action', ->        
        expect(@result).to.deep.equal {
          action:
            type: "hidden"
            default: "getAllPets"  
          options:
            type: "object"
            properties:
              status:
                description: "The status to filter by",
                type: "string"
      }          

  describe '.getFormForAction ->', ->
    describe 'when called with a name and a simple action', ->
      beforeEach ->
        property =
          type: "object"
          description: "Finds all pets in the system"
          properties:
            status:
              description: "The status to filter by"
              type: "string"

        @result = @sut.getFormForAction "getAllPets", property

      it 'should return the form for that action', ->
        propertyForm =  [
          {
            key: 'getAllPets'
            notitle: true
            type: 'hidden'
          }
          {
            key: 'getAllPets.status'
            title: 'The status to filter by'
            condition: 'model.subschema === \'getAllPets\''
          }
        ]
        expect(@result).to.deep.equal propertyForm

    describe 'when called with a name and a more complex action', ->
      beforeEach ->
        property =
            description: 'The Pet to create'
            type: 'object'
            properties:
              category:
                properties:
                  id:
                    format: 'int64'
                    type: 'integer'

              id:
                description: 'unique identifier for the pet'
                format: 'int64'
                maximum: 100
                minimum: 0
                type: 'integer'

              name:
                type: 'string'

              status:
                description: 'pet status in the store'
                enum: [
                  'available'
                  'pending'
                  'sold'
                ]
                type: 'string'

              tags:
                items:
                  properties:
                    id:
                      format: 'int64'
                      type: 'integer'
                    name:
                      type: 'string'
                  type: 'object'
                type: 'array'

        @result = @sut.getFormForAction 'createPet', property

      it 'should return the form for that action', ->
        propertyForm =  [
          {
            key: 'createPet'
            notitle: true
            type: 'hidden'
          }
          {
            key: 'createPet.category'
            condition: 'model.subschema === \'createPet\''
          }
          {
            key: 'createPet.id'
            title: 'unique identifier for the pet'
            condition: 'model.subschema === \'createPet\''
          }
          {
            key: 'createPet.name'
            condition: 'model.subschema === \'createPet\''
          }
          {
            key: 'createPet.status'
            title: 'pet status in the store'
            condition: 'model.subschema === \'createPet\''
          }
          {
            key: 'createPet.tags'
            condition: 'model.subschema === \'createPet\''
          }
        ]
        expect(@result).to.deep.equal propertyForm

  describe '.getSubschemaTitleMap ->', ->
    it 'should exist', ->
      expect(@sut.getSubschemaTitleMap).to.exist

    describe 'when called with message schema properties', ->
      beforeEach ->
        @result = @sut.getSubschemaTitleMap(
              subschema:
                type: "string"
                enum: [
                  "getDevices"
                  "sendEventToSubscribers"
                ]
              getDevices:
                description: "Returns An Array Of Device Objects"
              sendEventToSubscribers:
                description: "Post Devices Output"
        )

      it 'should create the appropriate title map', ->
        titleMap = [
            {
              value: "getDevices"
              name: "Returns An Array Of Device Objects"
            }
            {
              value: "sendEventToSubscribers"
              name: "Post Devices Output"
            }
          ]

        expect(@result).to.deep.equal titleMap
