DeviceGenerator = require '../device-generator'

describe 'DeviceGenerator', ->
  it 'should exist', ->    
    expect(DeviceGenerator).to.exist
    
  describe 'constructor', ->
    describe 'when called with a path to a swagger file', ->
      beforeEach ->      
        @sut = new DeviceGenerator './swagger/hello-world-swagger.json'            
      
      it 'should exist', ->
        expect(@sut).to.exist
  
  describe '.toMessageSchema ->', ->
    describe.only 'when DeviceGenerator is called with hello-world-swagger', ->
    
      beforeEach ->
        @sut = new DeviceGenerator './swagger/hello-world-swagger.json'
      
      it 'should exist', ->
        expect(@sut.toMessageSchema).to.exist
      
      describe.only 'when called', ->
        beforeEach ->
          @result = @sut.toMessageSchema()
          
        it 'should return an object', ->
          expect(@result).to.exist
        
        it 'should return an object with a type of object', ->
          expect(@result.type).to.equal 'object'
        
        it 'should return the subschema enumeration', ->
          console.log( 'result:', JSON.stringify @result)
          expect(@result.properties.subschema).to.deep.equal(
            type: 'string'
            enum: ["helloSubject"]
          )
          
    xdescribe 'when DeviceGenerator is called with pet-store v2.0', ->    
      beforeEach ->
        @sut = new DeviceGenerator './swagger/pet-store-2-0.json'