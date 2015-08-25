_ = require 'lodash'
fs = require 'fs-extra'
os = require 'os'
path = require 'path'
assert = require('yeoman-generator').assert
helpers = require('yeoman-generator').test

ProxyDeviceYeoman = require '../../generators/app/index'

describe 'app', ->
  describe 'when called with a swagger file', ->
    beforeEach (done) ->
      @optionsBuilderRoot = path.join __dirname, 'generated-files'
      @optionsBuilderPath = path.join @optionsBuilderRoot, 'options-builder.coffee'

      helpers.run(path.join(__dirname, '../../generators/app')).
        inDir(@optionsBuilderRoot).
        withOptions('skip-install': true).
        withPrompts({
          swaggerFile: '../../../test/samples/swagger/pet-store-2-0-swagger.json'
        }).on 'end', =>
          console.log fs.readFileSync @optionsBuilderPath, 'utf8'
          done()

    it 'creates files', ->
      assert.file [
        'options-builder.coffee'
      ]

    afterEach ->
      fs.removeSync @optionsBuilderRoot
      _.each require.cache, (cacheValue, cacheName) =>
        delete require.cache[cacheName] if _.contains cacheName, 'options-builder'

    describe 'when OptionsBuilder is instantiated', ->
      beforeEach ->
        OptionsBuilder = require @optionsBuilderPath
        @sut = new OptionsBuilder

      it 'should have getAllPets and createPets as keys', ->
        functions = _.keys @sut
        expect(functions).to.contain 'getAllPets', 'createPet, getPet'

  describe 'when called with a proxy-config', ->
    beforeEach (done) ->
      @optionsBuilderRoot = path.join __dirname, 'generated-files'
      @optionsBuilderPath = path.join @optionsBuilderRoot, 'options-builder.coffee'

      helpers.run(path.join(__dirname, '../../generators/app')).
        inDir(@optionsBuilderRoot).
        withOptions({
        'skip-install': true
        'proxy-config': '../../samples/proxy-config/sample1.json'
        }).
        on 'end', =>
          console.log fs.readFileSync @optionsBuilderPath, 'utf8'
          done()

    afterEach ->
      fs.removeSync @optionsBuilderRoot
      _.each require.cache, (cacheValue, cacheName) =>
        delete require.cache[cacheName] if _.contains cacheName, 'options-builder'

      delete require.cache[@optionsBuilderRoot]

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

        it 'should return a message with the transformed keys', ->
          expect(@result).to.deep.equal(
              Bandit: "Ignito Montoya"
              bandit_captain: "Tyrannosaurus Rex"
              species: "dog"
          )

      describe 'when OptionsBuilder.createPet is run', ->
        beforeEach (done) ->
          payload =
            petType: 'dog'
            petName: 'Andrew'
            petId: 5

          @expectedOptions =
            method: 'GET'
            uri: 'https://petfinder2.com/pets/5'
            qs:
              pet_type: "dog"
              pet_name: 'Andrew'

          @sut.getPet payload, (error, options) =>
             @result = options
             done()

        it 'should return the appropriate request parameters', ->
          expect(@result).to.deep.equal @expectedOptions
