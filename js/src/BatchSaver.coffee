# root = this
# $ = jQuery
# _ = Underscore

# CautiousInput
window.BatchSaver =
  
  batchSave: (attrs, options) ->
    options || (options = {})
    return false if attrs && !this.set(attrs, options)
    @_batchRequestedAt = (new Date()).getTime()
    # apply the provided options to our batch options, overwriting any previous options
    @_batchOptions = @_batchOptions || @saveOptions || {}
    _.extend(@_batchOptions, options)

    # save or schedules timeout for 
    @_batch()

  # perform save when it's time, otherwise schedule new appointment
  _batch: ->
    # an accuracy of 10ms should be decent
    if @_timeTillBatch() < 10
      @save({}, @_batchOptions || @saveOptions || {})
      # reset batchOptions
      @_batchOptions = undefined
    else
      # schedule new timeout
      @_schedule()

  # schedule an appointment 
  _schedule: ->
    window.setTimeout jQuery.proxy(@_batch, this), @_timeTillBatch()

  # time left until next batch (ms)
  _timeTillBatch: ->
    delay = @delay || 500 # 500 ms; default delay when unspecified
    # no request time; simply return delay
    return delay if !@_batchRequestedAt
    time = @_batchRequestedAt + delay - (new Date()).getTime()
    return 0 if time < 0
    return time

