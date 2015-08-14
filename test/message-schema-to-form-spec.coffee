_ = require 'lodash'
MessageSchemaToForm = require '../message-schema-to-form.coffee'
describe 'MessageSchemaToForm', ->
  beforeEach ->
    @sut = new MessageSchemaToForm
  it 'should exist', ->
    expect(MessageSchemaToForm).to.exist
    expect(@sut).to.exist

  describe '.transform ->', ->
    it 'should exist', ->
      expect(@sut.transform).to.exist

    describe 'when MessageSchemaToForm is constructed with a path', ->
      describe 'when called', ->
        beforeEach ->
          @result = @sut.transform './message-schema/pet-store-message-schema.json'

        it 'should return an array', ->
          expect(@result).to.be.an 'array'

        it 'should return an array that references the subschema', ->
          subschemaForm = _.findWhere @result, key: 'subschema'

          expect(subschemaForm.title).to.equal 'Action'
          expect(subschemaForm.titleMap).to.be.an 'array'

  describe '.getForm ->', ->
    describe 'when called with a message schema', ->
      beforeEach ->
        @messageSchema =
          'subschema':
            'type': 'string'
            'enum': [
              'getAllPets'
              'createPet'
              'deletePet'
              'getPetById'
            ]

          'getAllPets':
            'type': 'object'
            'description': 'Finds all pets in the system'
            'properties':
              'status':
                'description': 'The status to filter by'
                'type': 'string'

          'createPet':
            'type': 'object'

          'deletePet':
            'type': 'object'
            'properties': 'id':
              'description': 'ID of pet to delete'
              'type': 'integer'
              'required': true

          'getPetById':
            'type': 'object'
            'description': 'Finds the pet by id'

        @result = @sut.getForm @messageSchema

      xit 'should contain all the actions', ->
        actionNames = _.pluck @result, 'key'
        expect(actionNames).to.contain [
            "getAllPets"
            "createPet"
            "deletePet"
            "getPetById"
        ]

  describe '.getFormForAction ->', ->
    describe 'when called with a name and a property', ->
      beforeEach ->
        property =
          type: "object"
          description: "Finds all pets in the system"
          properties:
            status:
              description: "The status to filter by"
              type: "string"

        @result = @sut.getFormForAction "getAllPets", property

      it 'should return the form for that property', ->
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
