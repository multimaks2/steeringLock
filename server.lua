local setsteering = function(theVeh,value)
if not theVeh then return end
if not value then return end	
setVehicleHandling(theVeh,"steeringLock",value)
setVehicleHandling(theVeh, "maxVelocity", 300.0)
setVehicleHandling(theVeh, "engineAcceleration", 40.0 )
end
addEvent( "stTheBVal", true )
addEventHandler( "stTheBVal", resourceRoot, setsteering )

