root = this
$ = jQuery

Tester = Backbone.Model.extend(BatchSaver).extend
  delay: 300

describe "Backbone Batch Saver", ->

  beforeEach ->
    @tester = new Tester
    @tester.save = (attrs, options) ->
      @saved = true
      @savingAttrs = attrs
      @savingOptions = options

  afterEach ->
    @tester.destroy

  it "should provide a batchSave function that doesn't save until the delay time has passed", ->
    expect(@tester.saved).toEqual undefined
    @tester.batchSave()
    waits 200
    runs -> expect(@tester.saved).toEqual undefined
    waits 150
    runs -> expect(@tester.saved).toEqual true

  it "should let you pass attributes to batchSave which are set immediately, just like with the regular Backbone.Model.save", ->
    @tester.batchSave
      someAttr: 'someValue'

    expect(@tester.get('someAttr')).toEqual 'someValue'

  it "should provide let you specify a delay", ->
    @tester.delay = 600
    @tester.batchSave()
    expect(@tester.saved).toEqual undefined
    waits 300
    runs -> expect(@tester.saved).toEqual undefined
    waits 200
    runs -> expect(@tester.saved).toEqual undefined
    waits 200
    runs -> expect(@tester.saved).toEqual true

  it "should let you specify general save options", ->
    @tester.saveOptions =
      some_options:
        nothing: 'much'

    @tester.batchSave()
    expect(@tester.savingOptions).toEqual undefined
    waits 350
    runs -> expect(@tester.savingOptions.some_options).toEqual {nothing: 'much'}

  it "should let you overwrite general save options", ->
    @tester.saveOptions =
      success: 'success_func1'
      error: 'err_func1'

    @tester.batchSave({}, {success: 'replacer_success_func'})
    expect(@tester.savingOptions).toEqual undefined
    waits 350
    runs -> expect(@tester.savingOptions).toEqual {success: 'replacer_success_func', error: 'err_func1'}

  it "should delay again after each call to batchSave", ->
    @tester.batchSave()
    expect(@tester.saved).toEqual undefined
    waits 100
    runs ->
      @tester.batchSave()
      waits 200
      runs ->
        expect(@tester.saved).toEqual undefined
        @tester.batchSave()
        waits 200
        runs ->
          expect(@tester.saved).toEqual undefined
          waits 100
          runs -> expect(@tester.saved).toEqual true

  # events
  # it "should trigger a batchSave:request event when batchSave is called", ->
  #   spyOnEvent @tester, 'batchSave:request'
  #   @tester.batchSave()
  #   expect('batchSave:request').toHaveBeenTriggeredOn @tester
  # 
  # it "should trigger a batchSave:save event when an actual batched save is performed"
  #   spyOnEvent @tester, 'batchSave:save'
  #   @tester.batchSave()
  #   expect('batchSave:save').not.toHaveBeenTriggeredOn @tester
  #   waits 300
  #   expect('batchSave:save').toHaveBeenTriggeredOn @tester