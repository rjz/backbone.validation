(function (Backbone) {

  // Base class for describing Backbone Validations
  Backbone.Validation = (function () {

    function Validation (opts) {
      this.opts = opts || {};
    };

    Validation.prototype.validate = function (model) {
      model.errors.push({ base: 'Unable to validate' });
    };

    return Validation;
  })();

  // Borrow  `extend` method from `Backbone.Model`
  Backbone.Validation.extend = Backbone.Model.extend;

  // Add error array to models
  Backbone.Model.prototype.errors = Backbone.Model.prototype.errors || [];

  // Patch `Backbone.Collection.filter` method to support filters
  Backbone.Model.prototype.validate = function(attrs, options) {
    var self = this,
        validations;

    if (this.hasOwnProperty('validatesWith')) {
      this.errors = [];

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

      return this.errors.length;
    }
    return null;
  };
 
})(Backbone);

