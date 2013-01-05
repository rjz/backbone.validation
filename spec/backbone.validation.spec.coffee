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
      validate: (model) ->
    expect(new Vtoo instanceof Backbone.Validation).toBeTruthy()

  it 'adds errors to model base by default', ->
    Vthree = Backbone.Validation.extend
      validate: (model) ->
        @addError model, 'Failed.'
    validator = new Vthree
    validator.validate @model
    expect(@model.errors.base.length).toEqual 1

  it 'can add errors to model attributes', ->
    Vfour = Backbone.Validation.extend
      validate: (model) ->
        @addError model, 'attribute', 'Failed.'
    validator = new Vfour
    validator.validate @model
    expect(@model.errors.attribute.length).toEqual 1

  describe 'Matching', ->

    beforeEach ->
      @validation = new Backbone.Validation

    it 'can test for presence of an attribute', ->
      attr = 'foo'
      expect(@validation.isPresent @model, attr).toBeFalsy()
      @model.set attr, 'foobar'
      expect(@validation.isPresent @model, attr).toBeTruthy()

    it 'can test for equality of two attrs', ->
      attr = 'foo'
      @model.set other = 'foz', val = 'foobar'
      expect(@validation.isEqual @model, attr, other).toBeFalsy()
      @model.set attr, val
      expect(@validation.isPresent @model, attr, other).toBeTruthy()

    it 'can test whether an attribute matches a value', ->
      attr = 'foo'
      expect(@validation.isMatch @model, attr, val = 'foobar').toBeFalsy()
      @model.set attr, val
      expect(@validation.isMatch @model, attr, val).toBeTruthy()

    it 'can test whether an attribute matches a regex', ->
      attr = 'foo'
      @model.set attr, 'foobar'
      expect(@validation.isMatch @model, attr, /obar/).toBeTruthy()


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

