# Events

A simple event bus to allow for scripts in Defold to be notified of events they are interested in. Depending on the type of event, callbacks can make use of all values the source provides.

Thanks to https://github.com/DanEngelbrecht/LuaScriptInstance, there are no restrictions for the consumer to access go / gui functions as the callbacks are always handled in the right context.

Within your game, it is good practice to define your own, game-specific events for easy access, e.g. in a Lua module, you may define:

```lua
-- original events module as provided by the library
local Events = require( "events.events" )

-- your game specific events
Events.ON_CLICK = Events.create( "onClick" )
Events.ON_THREE_CLICKS = Events.create( "onThreeClicks" )

-- extended Events object to be used in your game
return Events
```

Then, in order to be notified of events, you subscribe to one of the defined event types:

```lua
-- react to an event happening somewhere else
self.subscription = Events.ON_CLICK:subscribe( function( attr ) 
	pprint( "Click!" )
	pprint( attr ) 
end )
```

As a parameter to event:subscribe(), you provide a callback function to be called once an instance of that event is triggered. Your handler function will receive all parameters a triggering object will provide.

The event:subscribe() method returns a handle that you need in order to unsubscribe from further events of that type. It is important to unsubscribe  from an event before the subscriber itself gets deleted. 

So, to be on the save side, you should always call the event:unsubscribe() method in the finalize function of an object that subscribes to an event:

```lua
-- unsubscribe from further events
function final( self )
	Events.ON_CLICK:unsubscribe( self.subscription )
end
```

To trigger a new instance of an event, any script or module may call the event:trigger() method with any number of useful parameters. 

```lua
-- inform all subscribers that a new event 
-- has occurred with given data to handle
Events.ON_CLICK:trigger( { txt = "Hello Click" } )

```

Depending on the type of event, you may want to provide different arguments to the consumers. All parameters will be passed to the callback function you have defined upon subscribing to that event.

It is also possible to only temporarily pause receiving events and to turn them back on later without having to redefine the callback function as you would have to if you unsubscribed and resubscribed again. A common usecase would be to e.g. temporarily disable receiving a spaceship's steering events after opening a GUI menu and reacting to a different type of input. Upon closing the GUI dialog, you would simply unpause receiving the events as before:

```lua
-- pause receiving events temporarily
Events.ON_CLICK:pause( self.subscription )

-- receive events again 
Events.ON_CLICK:unpause( self.subscription )
```


