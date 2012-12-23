require './helper.coffee'
require '../src/backbone.validations.js'

class MyValidator extends Backbone.Validation
  validate: (model) ->
    @addError model, 'failed' unless @opts.passes

describe 'Backbone.Validation', ->

  beforeEach ->
    @model = new TestModel

  it 'fails by default', ->
    validation = new Backbone.Validation
    validation.validate @model
    expect(@model.errors.base.length).toEqual 1

  it 'can be extended', ->
    Vtoo = Backbone.Validation.extend
      validate: (@model) ->
    expect(new Vtoo instanceof Backbone.Validation).toBeTruthy()

  it 'can add errors to a model', ->
    Vthree = Backbone.Validation.extend
      validate: (model) ->
        @addError model, 'Failed.'

  it 'can add errors to model attributes', ->
    Vfour = Backbone.Validation.extend
      validate: (model) ->
        @addError model, 'attribute', 'Failed.'

describe 'Adjustments to Backbone.Model', ->

  describe 'default validate method', ->
    beforeEach ->
      @model = new TestModel
      @validator = new MyValidator passes: false
      @opts =
        error: jasmine.createSpy()
        silent: false

    expectModelToFail = (model, opts) ->
      expect(model._validate model.attributes, opts).toBeFalsy()
      expect(opts.error).toHaveBeenCalled()

    expectModelToPass = (model, opts) ->
      expect(model._validate model.attributes, opts).toBeTruthy()

    it 'passes when no validator is provided', ->
      expectModelToPass @model, @opts

    it 'runs validations when provided individually', ->
      @model.validatesWith = @validator
      expectModelToFail @model, @opts

    it 'runs validations when provided as an array', ->
      @model.validatesWith = [@validator]
      expectModelToFail @model, @opts

    it 'runs validations when provided as a function', ->
      @model.validatesWith = => @validator
      expectModelToFail @model, @opts

    it 'can still be mashed', ->
      name = 'Gordon Krantz'
      model = _.extend new TestModel,
        validate: (attrs) ->
          return 'not Gordon' unless attrs.name == name
      expect(model.isValid()).toBeFalsy()
      model.set 'name', name
      expect(model.isValid()).toBeTruthy()

