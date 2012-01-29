(function() {
  var $, Tester, root;

  root = this;

  $ = jQuery;

  Tester = Backbone.Model.extend(BatchSaver).extend({
    delay: 300
  });

  describe("Backbone Batch Saver", function() {
    beforeEach(function() {
      this.tester = new Tester;
      return this.tester.save = function(attrs, options) {
        this.saved = true;
        this.savingAttrs = attrs;
        return this.savingOptions = options;
      };
    });
    afterEach(function() {
      return this.tester.destroy;
    });
    it("should provide a batchSave function that doesn't save until the delay time has passed", function() {
      expect(this.tester.saved).toEqual(void 0);
      this.tester.batchSave();
      waits(200);
      runs(function() {
        return expect(this.tester.saved).toEqual(void 0);
      });
      waits(150);
      return runs(function() {
        return expect(this.tester.saved).toEqual(true);
      });
    });
    it("should let you pass attributes to batchSave which are set immediately, just like with the regular Backbone.Model.save", function() {
      this.tester.batchSave({
        someAttr: 'someValue'
      });
      return expect(this.tester.get('someAttr')).toEqual('someValue');
    });
    it("should provide let you specify a delay", function() {
      this.tester.delay = 600;
      this.tester.batchSave();
      expect(this.tester.saved).toEqual(void 0);
      waits(300);
      runs(function() {
        return expect(this.tester.saved).toEqual(void 0);
      });
      waits(200);
      runs(function() {
        return expect(this.tester.saved).toEqual(void 0);
      });
      waits(200);
      return runs(function() {
        return expect(this.tester.saved).toEqual(true);
      });
    });
    it("should let you specify general save options", function() {
      this.tester.saveOptions = {
        some_options: {
          nothing: 'much'
        }
      };
      this.tester.batchSave();
      expect(this.tester.savingOptions).toEqual(void 0);
      waits(350);
      return runs(function() {
        return expect(this.tester.savingOptions.some_options).toEqual({
          nothing: 'much'
        });
      });
    });
    it("should let you overwrite general save options", function() {
      this.tester.saveOptions = {
        success: 'success_func1',
        error: 'err_func1'
      };
      this.tester.batchSave({}, {
        success: 'replacer_success_func'
      });
      expect(this.tester.savingOptions).toEqual(void 0);
      waits(350);
      return runs(function() {
        return expect(this.tester.savingOptions).toEqual({
          success: 'replacer_success_func',
          error: 'err_func1'
        });
      });
    });
    return it("should delay again after each call to batchSave", function() {
      this.tester.batchSave();
      expect(this.tester.saved).toEqual(void 0);
      waits(100);
      return runs(function() {
        this.tester.batchSave();
        waits(200);
        return runs(function() {
          expect(this.tester.saved).toEqual(void 0);
          this.tester.batchSave();
          waits(200);
          return runs(function() {
            expect(this.tester.saved).toEqual(void 0);
            waits(100);
            return runs(function() {
              return expect(this.tester.saved).toEqual(true);
            });
          });
        });
      });
    });
  });

}).call(this);
