_ = require 'lodash'
MessageToParameter = require '../../parser/message-to-parameter'

describe 'MessageToParameter', ->
  it 'should exist', ->
    expect(MessageToParameter).to.exist

describe 'when constructed with a parameter map', ->
  beforeEach ->
    @parameterNameMap = {
      "bandit": "Bandit"
      "banditCaptain": "bandit_captain"
      "monsterId": "monster_id"
      "braveryLevel": "bravery_level"
      "averageEducationLevel": "average_education_level"
    }

    @sut = new MessageToParameter @parameterNameMap

  describe 'when called with a message', ->
    beforeEach ->
      @message =
        bandit: "Ralph"
        mastiff: false
        banditCaptain: "Chris Matthieu"
        stats:
          monsterId: 5
          braveryLevel: 7
          strength: 5
          dexterity: 18
          nation:
            population: 15000
            averageEducationLevel: 5

      @result = @sut.getParameter @message

    it 'should return the message format we want', ->
      expect(@result).to.deep.equal (
        Bandit: "Ralph"
        mastiff: false
        bandit_captain: "Chris Matthieu"
        stats:
          monster_id: 5
          bravery_level: 7
          strength: 5
          dexterity: 18
          nation:
            population: 15000
            average_education_level: 5
      )

  describe 'when called with a message that contains an array', ->
    beforeEach ->
      @message =
        bandit: "Ralph"
        mastiff: false
        banditCaptain: "Chris Matthieu"
        stats: [
            { monsterId: 5, braveryLevel: 7 }
            { monsterId: 8, braveryLevel: 1 }
        ]

      @result = @sut.getParameter @message

    it 'should return the message format we want', ->
      expect(@result).to.deep.equal (
        Bandit: "Ralph"
        mastiff: false
        bandit_captain: "Chris Matthieu"
        stats: [
          { monster_id: 5, bravery_level: 7 }
          { monster_id: 8, bravery_level: 1 }
        ]
      )
