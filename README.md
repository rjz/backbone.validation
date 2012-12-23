Backbone Validations
====================

Recycleable validations for Backbone models. Define, apply, and evaluate
your own!

    var StringValidator = Backbone.Validator.extend({
    });

    var ValidatableModel = Backbone.Model.extend({
      validatesWith: [
        new StringValidator('name')
      ]    
    });
