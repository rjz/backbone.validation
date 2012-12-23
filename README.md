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
        new StringValidator({ attribute: 'name' })
      ]    
    });

