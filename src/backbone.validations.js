(function (Backbone) {

  // Base class for describing Backbone Validations
  Backbone.Validation = (function () {

    function Validation (opts) {
      this.opts = opts || {};
    };

    Validation.prototype.addError = function (model, attribute, message) {
      var errors = model.errors || {};
      if (_.isUndefined(message)) {
        message = attribute;
        attribute = 'base';
      }
      errors[attribute] = errors[attribute] || [];
      errors[attribute].push(message);
      model.errors = errors;
    }

    Validation.prototype.isPresent = function (model, key) {
      return model.attributes.hasOwnProperty(key);
    }

    Validation.prototype.isEqual = function (model, key, attrOther) {
      return model.get(key) == model.get(attrOther);
    }

    Validation.prototype.isMatch = function (model, key, value) {
      if (_.isRegExp(value)) {
        return value.test(model.get(key));
      }
      return model.get(key) == value;
    }

    // Override the validate method to implement validation
    Validation.prototype.validate = function (model) {
      this.addError(model, 'Unable to validate');
    };

    return Validation;
  })();

  // Borrow  `extend` method from `Backbone.Model`
  Backbone.Validation.extend = Backbone.Model.extend;

  // Patch `Backbone.Collection.filter` method to support filters
  Backbone.Model.prototype.validate = function (attrs, options) {
    var self = this,
        validations;

    if (this.hasOwnProperty('validatesWith')) {
      validations = this.validatesWith;

      if (_.isFunction(validations)) {
        validations = validations();
      }

      if (!_.isArray(validations)) {
        validations = [validations];
      }

      _.each(validations, function (validation) {
        validation.validate(self);
      });

      return _.keys(this.errors).length > 0;
    }

    return null;
  };
 
})(Backbone);

