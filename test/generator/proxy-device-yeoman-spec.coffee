_ = require 'lodash'
fs = require 'fs-extra'
os = require 'os'
path = require 'path'
assert = require('yeoman-generator').assert
helpers = require('yeoman-generator').test

ProxyDeviceYeoman = require '../../generator/index'

describe 'app', ->
  describe 'when called with a proxy-config', ->
    beforeEach (done) ->
      @optionsBuilderRoot = path.join __dirname, 'generated-files'
      @optionsBuilderPath = path.join @optionsBuilderRoot, 'options-builder.coffee'

      helpers.run(path.join(__dirname, '../../generator')).
        inDir(@optionsBuilderRoot).
        withOptions('skip-install': true).
        withArguments(['../test/samples/proxy-config/sample1.json']).
        on 'end', done

    afterEach ->
      fs.removeSync @optionsBuilderRoot

    it 'creates files', ->
      assert.file [
        'options-builder.coffee'
      ]

    describe 'when OptionsBuilder is instantiated', ->
      beforeEach ->
        OptionsBuilder = require @optionsBuilderPath
        @sut = new OptionsBuilder

      it 'should have getAllPets and createPets as keys', ->
        functions = _.keys @sut
        expect(functions).to.contain 'getAllPets', 'createPet, getPet'

      it 'should have getAllPets and createPets as keys', ->
        functions = _.keys @sut
        expect(functions).to.contain 'getAllPets', 'createPet, getPet'

      describe 'when convertMessageNames is called with message options and a map', ->
        beforeEach ->
          @result = @sut.convertMessageNames(
              {
                bandit: "Ignito Montoya"
                banditCaptain: "Tyrannosaurus Rex"
                species: "dog"
              }
              {
                bandit: "Bandit"
                banditCaptain: "bandit_captain"
              }
          )

        it 'should return a message with the transformed keys', ->
          expect(@result).to.deep.equal(
              Bandit: "Ignito Montoya"
              bandit_captain: "Tyrannosaurus Rex"
              species: "dog"
          )

      xdescribe 'when OptionsBuilder.getAllPets is run', ->
        beforeEach (done) ->
          optionsBuilderFile = fs.readFileSync @optionsBuilderPath, 'utf8'
          payload =
            petType: 'dog'
            petName: 'Andrew'

          @expectedOptions =
            method: 'GET'
            uri: 'https://petfinder.com/pets'
            qs:
              pet_type: "dog"
              pet_name: 'Andrew'

          @sut.getAllPets payload, (error, options) =>
             @result = otions
             done()

        it 'should return the appropriate request parameters', ->
          expect(@result).to.deep.equal @expectedOptions

      xdescribe 'when OptionsBuilder.createPet is run', ->
        beforeEach (done) ->
          optionsBuilderFile = fs.readFileSync @optionsBuilderPath, 'utf8'
          payload =
            petType: 'dog'
            petName: 'Andrew'
            petAttitude: 'scared'

          @expectedOptions =
            method: 'POST'
            uri: 'https://petfinder2.com/pets'
            body:
              pet_type: "dog"
              pet_name: 'Andrew'
              pet_attitude: 'scared'

          @sut.createPet payload, (error, options) =>
             @result = options
             done()

        it 'should return the appropriate request parameters', ->
          expect(@result).to.deep.equal @expectedOptions

      xdescribe 'when OptionsBuilder.getPet is run', ->
        beforeEach (done)->
          optionsBuilderFile = fs.readFileSync @optionsBuilderPath, 'utf8'
          payload =
            petId: 5

          @expectedOptions =
            method: 'GET'
            uri: 'https://petfinder2.com/pets/5'

          @sut.getPet payload, (error, options) =>
             @result = options
             done()

        it 'should return the appropriate request parameters', ->
          expect(@result).to.deep.equal @expectedOptions
