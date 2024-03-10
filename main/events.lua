local Events = require( "events.events" )

Events.ON_CLICK = Events.create( "onClick" )
Events.ON_THREE_CLICKS = Events.create( "onThreeClicks" )

return Events

