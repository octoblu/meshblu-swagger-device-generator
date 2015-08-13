_ = require 'lodash'
MessageSchemaToForm = require '../message-schema-to-form.coffee'
describe 'MessageSchemaToForm', ->
  it 'should exist', ->
    expect(MessageSchemaToForm).to.exist

  describe 'constructor', ->
    describe 'when called with a swagger object', ->
      beforeEach ->
        @sut = new MessageSchemaToForm

      it 'should exist', ->
        expect(@sut).to.exist

  describe '.transform ->', ->
    beforeEach ->
      @sut = new MessageSchemaToForm ''
    it 'should exist', ->
      expect(@sut.transform).to.exist

    describe 'when MessageSchemaToForm is constructed with a path', ->
      describe 'when called', ->
        beforeEach ->
          @result = @sut.transform './message-schema/little-bits-message-schema.json'

        it 'should return an array', ->
          expect(@result).to.be.an 'array'

        it 'should return an array that references the subschema', ->
          subschemaForm = _.findWhere @result, key: 'subschema'

          expect(subschemaForm.title).to.equal 'Action'
          expect(subschemaForm.titleMap).to.be.an 'array'

    describe '.getSubschemaTitleMap ->', ->
      beforeEach ->
        @sut = new MessageSchemaToForm

      it 'should exist', ->
        expect(@sut.getSubschemaTitleMap).to.exist

      describe 'when called with message schema properties', ->
        beforeEach ->
          @result = @sut.getSubschemaTitleMap [
                subschema:
                  type: "string"
                  enum: [
                    "getDevices"
                    "sendEventToSubscribers"
                  ]
                getDevices: true
                sendEventToSubscribers: true
          ]

        xit 'should create the appropriate title map', ->
          titleMap = [
              {
                value: "getDevice"
                name: "Returns An Array Of Device Objects"
              }
              {
                value: "sendEventToSubscribers"
                name: "Post Devices Output"
              }
            ]

          expect(@result).to.deep.equal titleMap
