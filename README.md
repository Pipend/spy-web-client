[![Build Status](https://travis-ci.org/Pipend/spy-web-client.svg)](https://travis-ci.org/Pipend/spy-web-client)

# spy-web-client
client-side library for recording events to [spy-server](https://github.com/pipend/spy-server)

## Installation
`npm install --save spy-web-client`

## Usage
* livescript:
```livescript
{record} = (require! \spy-web-client) do 

    # properties included in every recorded event
    common-event-parameters: ->
        user-id: window.user-id 

    # url where the spy-server is hosted
    url: \http://localhost:3010/yourProjectName 

window.add-event-listener \load, ->
    record do 
        event-type: \page-ready
```

* javascript:
```javascript
var spy = require("spy-web-client")({

    // properties included in every recorded event
    commonEventParameters: function(){
        return {
            userId: window.userId
        };
    },
    
    // url where the spy-server is hosted
    url: "http://localhost:3010/yourProjectName" 

});

window.addEventListener("load", function(){
    spy.record({eventType: "pageReady"});
});
```

