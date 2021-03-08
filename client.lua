
local x, y = guiGetScreenSize ( )
local sx = guiGetScreenSize()
local Corner = 0
local CornerPlus = 1
local voz = 1
local carTable =
    {
        [550] = {["steeringLock"] = 52,},
    }

local setControls = function ()
    local theVeh = getPedOccupiedVehicle(localPlayer)
    if not theVeh then return end
    local data = getElementData(theVeh,"steeringLock") or 0
    local _,__,Z1 = getVehicleComponentRotation( theVeh,"wheel_lf_dummy")
    local _,__,Z2 = getVehicleComponentRotation( theVeh,"wheel_rf_dummy")
    local _,__ = nil,nil
    Z1,Z2 = math.ceil(Z1)-180,360-(Z2)
    if Z1 > 1 then Z2 = Z2-360 end   if math.ceil(Z1) == 1 then Z1 = 0 end  if  math.ceil(Z2) == 360 or Z2 == 359  then Z2 = 0 end
    local loc = 0.01
    local proc = 10
    local num_1 = Corner -- Это 100%
    local arip = (num_1/(data*10)*9.81)
    arip = tonumber(string.format("%.2f", arip))

        s1 = false
        s2 = false

    if tonumber(arip) < 0 then
        setAnalogControlState('vehicle_left',(-arip))
        
        if microControl == 1 then
        s1 = false
        s2 = true
        end

        if microControl == 2 then
        s1 = true
        s2 = false
        end

    elseif tonumber(arip) > 0 then
        setAnalogControlState('vehicle_right',(arip))
        
        if microControl == 1 then
        s1 = true
        s2 = false
        end

        if microControl == 2 then
        s1 = false
        s2 = true
        end

    end
    toggleControl ("vehicle_left"  , s1 )
    toggleControl ("vehicle_right" , s2 )



if  debugMode == false then return end

dxDrawRectangle(25,y/6,300,250,tocolor(0,0,0,155))
dxDrawText ("Левое  колесо:"..math.ceil(Z1),60,y/5.4, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 2, 2, "default" )
dxDrawText ("Правое колесо:"..math.ceil(Z2),60,y/4.5, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 2, 2, "default" )

    dxDrawRectangle(175,y/4.7,-Z1*2,15,tocolor(0,255,0,155))
    dxDrawRectangle(175,y/4,Z2*2,15,tocolor(255,0,0,155))
    



    dxDrawText ("Аналоговое зн: "..arip, 60,y/3.0, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 2, 2, "default" )
    dxDrawText ( "Желаемый угол "..Corner, 60,y/3.5, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 2,2, "default" )
end
addEventHandler('onClientPreRender',root,setControls)


local function drawSpeed()
    local veh = getPedOccupiedVehicle (getLocalPlayer())
    if not veh then return end
    local speedkmh = getElementSpeed(veh, 2)
    local roundedSpeedkmh =  math.floor(speedkmh) == speedkmh and speedkmh or string.format(speedkmh, "%.1f")
    local roundedSpeedkmh = tonumber(roundedSpeedkmh)
    dxDrawText(math.ceil(roundedSpeedkmh), sx - dxGetTextWidth(math.ceil(roundedSpeedkmh)), 0)
    if  math.ceil(roundedSpeedkmh) == 0 or math.ceil(roundedSpeedkmh) == 1 or math.ceil(roundedSpeedkmh) == 2   then return end
if roundedSpeedkmh <= 35 then speedReturnWh = 0.2 end 


    if Corner < 0 then  -- лево
        Corner = Corner+speedReturnWh
    end
    if Corner > 0 then -- право
        Corner = Corner-speedReturnWh
    end
Corner = tonumber(string.format("%.3f", Corner))

end
addEventHandler("onClientRender", getRootElement(), drawSpeed)


function getDriftAngle(vehicle)
	if vehicle.velocity.length < 0.12 then
		return 0
	end

	local direction = vehicle.matrix.forward
	local velocity = vehicle.velocity.normalized

	local dot = direction.x * velocity.x + direction.y * velocity.y
	local det = direction.x * velocity.y - direction.y * velocity.x

	local angle = math.deg(math.atan2(det, dot))
	if math.abs(angle) > 160 then
		return 0
	end
	if angle < 0 then
		dir = "left"
	elseif angle > 0 then
		dir = "right"
	end
	return angle, dir
end


addEventHandler("onClientVehicleEnter", getRootElement(),
    function(thePlayer, seat)
        local veh = getPedOccupiedVehicle (getLocalPlayer())
        for i,v in pairs (carTable) do
            if not veh then return end
            if i == getElementModel(veh) then
                for handling, value in pairs (v) do
                    setElementData(veh,handling,value)
                    triggerServerEvent ( "stTheBVal", resourceRoot, veh,value)
                    print("Угол выворота установлен на :"..getElementData(veh,handling))

                end
            end
        end
    end)

local key = function()
    if getKeyState("a") and getKeyState('d') then return end
    local veh = getPedOccupiedVehicle (getLocalPlayer())
    if not veh then return end
    local data = getElementData(veh,"steeringLock") or nil
    if getKeyState("lshift") then dxDrawText ("Множитель X2", x/4,y/2.02, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 1,1, "default" )  mnz = 1 else mnz = 0 end

    if getKeyState("a") then
        if data == nil then return end
        if tonumber((data-data-data) ) > Corner then return end
        Corner = Corner - CornerPlus-mnz
    end
    if getKeyState("d") then
        if data == nil then return end
        if tonumber(data) < Corner then return end
        Corner = Corner + CornerPlus+mnz
    end
end
addEventHandler('onClientRender',root,key)


function getElementSpeed(theElement, unit)
    local vehicle = getPedOccupiedVehicle(getLocalPlayer())
    if not vehicle then return end
    assert(isElement(theElement), "Чет наебнулось аргумент - 1 @ getElementSpeed (нихуя не получил от - " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end
