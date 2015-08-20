_ = require 'lodash'
fs = require 'fs'
os = require 'os'
path = require 'path'
assert = require('yeoman-generator').assert
helpers = require('yeoman-generator').test

ProxyDeviceYeoman = require '../../generator/index'

describe 'app', ->
  describe 'when called with a proxy-config', ->
    beforeEach (done) ->
      @optionsBuilderPath = path.join os.tmpdir(), '/temp-test/options-builder.coffee'

      helpers.run(path.join(__dirname, '../../generator')).
        inDir(path.join(os.tmpdir(), './temp-test')).
        withOptions('skip-install': true).
        withArguments(['../test/samples/proxy-config/sample1.json']).
        on 'end', done

      return

    it 'creates files', ->
      assert.file [
        'options-builder.coffee'
      ]

    describe 'when OptionsBuilder is instantiated', ->
      beforeEach ->
        OptionsBuilder = require @optionsBuilderPath
        @sut = new OptionsBuilder()

      it 'should have getAllPets and createPets as keys', ->
        functions = _.keys @sut
        expect(functions).to.contain 'getAllPets', 'createPet, getPet'

      xdescribe 'when OptionsBuilder.getAllPets is run', ->
        beforeEach (done) ->
          optionsBuilderFile = fs.readFileSync @optionsBuilderPath, 'utf8'
          console.log optionsBuilderFile
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
             @result = options
             done()

        it 'should return the appropriate request parameters', ->
          expect(@result).to.deep.equal @expectedOptions

      xdescribe 'when OptionsBuilder.createPet is run', ->
        beforeEach (done) ->

          optionsBuilderFile = fs.readFileSync @optionsBuilderPath, 'utf8'
          console.log optionsBuilderFile
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
          console.log optionsBuilderFile
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
