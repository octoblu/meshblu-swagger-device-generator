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
  
  describe '.getPropertiesFromPath', ->
    describe 'after being constructed with a swagger object', ->
      beforeEach ->      
        @sut = new Swagger2ToMessageSchema()
        @sut.swagger =   
          paths: 
            '/pets': 
              get: 
                security: [                  
                    oauth2: [
                      "read"
                    ]
                  
                ]
                tags: [
                  "Pet Operations"
                ]
                operationId: "getAllPets"
                parameters: [
                  
                    name: "status"
                    in: "query"
                    description: "The status to filter by"
                    type: "string"
                  
                ]
                
        @sut.setupActionIndex()      
              
      it 'should exist', ->
        expect(@sut.getPropertiesFromPath).to.exist
      
      
      describe 'when called with an action', ->
        beforeEach ->
          @result = @sut.getPropertiesFromPath 'getAllPets'
        
        it 'should return the appropriate json schema property', ->
          expect(@result).to.deep.equal(                           
              status: 
                type: "string"
                description: 'The status to filter by'                
          )