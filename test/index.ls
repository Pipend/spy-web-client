require! \assert
require! \sinon
{get-load-time-object, record}:spy = (require \../index.ls) do 
    url: \/something
    common-event-properties: ->
        title: "some title"

describe "spy-web-client", ->

    specify "must compute load time when performance.timing API is available", (done) ->
        window.performance = 
            timing: 
                connectEnd: 1443790315694
                connectStart: 1443790315110
                domComplete: 1443790317365
                domContentLoadedEventEnd: 1443790316540
                domContentLoadedEventStart: 1443790316538
                domInteractive: 1443790316538
                domLoading: 1443790316118
                domainLookupEnd: 1443790315110
                domainLookupStart: 1443790315110
                fetchStart: 1443790315105
                loadEventEnd: 1443790317370
                loadEventStart: 1443790317368
                navigationStart: 1443790315105
                redirectEnd: 0
                redirectStart: 0
                requestStart: 1443790315694
                responseEnd: 1443790316348
                responseStart: 1443790316105
                secureConnectionStart: 1443790315351
                unloadEventEnd: 0
                unloadEventStart: 0
        {load-time, DOM-load-time} <- get-load-time-object
        assert load-time > 0
        assert DOM-load-time > 0
        done!

    specify "record must POST event", ->
        server = sinon.fake-server.create!
            ..respond-with (xhr) ->
                xhr.respond 200, null, ""
        callback = sinon.spy!
        {event-type, point-of-generation, title} = record {event-type: \test}, callback
        server.respond!
        assert event-type == \test
        assert point-of-generation == \web-page
        assert title == "some title"
        assert callback.called-once
