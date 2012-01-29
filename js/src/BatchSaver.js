
  window.BatchSaver = {
    batchSave: function(attrs, options) {
      options || (options = {});
      if (attrs && !this.set(attrs, options)) return false;
      this._batchRequestedAt = (new Date()).getTime();
      this._batchOptions = this._batchOptions || this.saveOptions || {};
      _.extend(this._batchOptions, options);
      return this._batch();
    },
    _batch: function() {
      if (this._timeTillBatch() < 10) {
        this.save({}, this._batchOptions || this.saveOptions || {});
        return this._batchOptions = void 0;
      } else {
        return this._schedule();
      }
    },
    _schedule: function() {
      return window.setTimeout(jQuery.proxy(this._batch, this), this._timeTillBatch());
    },
    _timeTillBatch: function() {
      var delay, time;
      delay = this.delay || 500;
      if (!this._batchRequestedAt) return delay;
      time = this._batchRequestedAt + delay - (new Date()).getTime();
      if (time < 0) return 0;
      return time;
    }
  };
