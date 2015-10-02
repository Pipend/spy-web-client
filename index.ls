module.exports = ({common-event-properties or (-> {}), url}) ->

    # cookies-enabled :: a -> Boolean
    cookies-enabled = ->
        if !!navigator?.cookie-enabled
            navigator.cookie-enabled 
        else
            document.cookie = \test-cookiet
            document.cookie.index-of \test-cookie != -1

    # get-load-time-object :: (LoadTimeObject -> Void) -> Void
    get-load-time-object = (callback) !->
        if !!window?.performance?.timing
            {fetch-end, fetch-start, load-event-end, navigation-end, navigation-start, response-end} = window.performance.timing
            callback do
                DOM-load-time: load-event-end - response-end
                fetch-time: response-end - fetch-start
                load-time: load-event-end - navigation-start
                navigation-time: fetch-start - navigation-start
        else 
            callback undefined

    # get-page-visibility-status
    get-page-visibility-status = ->
        hidden-property = 
            | !!document.hidden => \hidden
            | !!document.moz-hidden => \mozHidden
            | !!document.ms-hidden => \msHidden
            | !!document.webkit-hidden => \webkitHidden
            | _ => undefined
        if !!hidden-property
            hidden-property: hidden-property
            hidden: document[hidden-property]
        else 
            hidden-property: null
            hidden: null

    # record :: Event -> Void
    record = do -> 
        previous-event-time = undefined

        # Event -> (a -> Void) -> ExtendedEvent
        (event-object, done) ->

            # extend event-object with important properties
            current-date = new Date!
            current-time = current-date.get-time!
            extended-event-object = {
                client-side-referrer: document.referrer
                client-side-creation-date: current-date
                client-side-creation-time: current-time
                cookies-enabled: cookies-enabled!
                point-of-generation: \web-page
                time-since-last-event: current-time - (previous-event-time or current-time)
                url: window.location.href
                inner-width: window.inner-width
                inner-height: window.inner-height
                outer-width: window.outer-width
                outer-height: window.outer-height
                screen-width: screen.width
                screen-height: screen.height
            } <<< get-page-visibility-status! <<< common-event-properties! <<< event-object

            # post the extended event-object as plain text (to avoid OPTIONS request)
            try 
                xhr = new XMLHttpRequest!
                    ..onreadystatechange = ->
                        if xhr.ready-state == 4 and xhr.status == 200 and !!done
                            done! 
                    ..open \POST, url
                    ..set-request-header \Content-Type, 'text/plain'
                    ..send JSON.stringify(extended-event-object)
            catch exception
                console?.error exception

            previous-event-time := current-time

            extended-event-object

    {get-load-time-object, record}