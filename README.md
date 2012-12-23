Backbone Validations
====================

Recycleable validations for Backbone models. Define, apply, and evaluate
your own!

    var StringValidator = Backbone.Validator.extend({
      validate: function (model) {
        var attribute = this.options.attribute;
        if (!_.isString(model.get(attribute))) {
          this.addError(model, attribute, 'must be a string');
        }
      }
    });

    var ValidatableModel = Backbone.Model.extend({
      validatesWith: [
        new StringValidator({ attribute: 'theAnswer' })
      ]    
    });

    var myModel = new ValidatableModel;

    myModel.set({ theAnswer: 'Forty Two' }); // ok
    myModel.set({ theAnswer: 42 }); // invalid!

Failing validations will set error messages on the model that can be 
used to debug over provide user feedback:

    _.each(myModel.errors.theAnswer, function (message) {
      console.log('invalid because: ' + message);    
    });


