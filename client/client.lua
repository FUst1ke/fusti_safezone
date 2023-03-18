local function setControlData(toggle)
    DisableControlAction(0, 25,  toggle)
    DisableControlAction(0, 140, toggle)
    DisableControlAction(0, 263, toggle)
    DisableControlAction(0, 142, toggle)
    DisablePlayerFiring(cache.playerId, not toggle)
end

local notify = Config.SafeZones.notify
local vehicleConfig = Config.SafeZones.vehicle
local alpha = Config.SafeZones.alpha
local player = Config.SafeZones.player

local function hitOrLeave(state)
    if player.godMode then
        SetEntityInvincible(cache.ped, state)
    end

    SetPlayerCanDoDriveBy(cache.playerId, not state)

    if not IsPedInAnyVehicle(cache.ped, false) then
        return
    end

    if vehicleConfig.limit then
        SetEntityMaxSpeed(cache.vehicle, state and (vehicleConfig.maxSpeed * (vehicleConfig.metric == 'mph' and 2.23 or 3.6)) or 1000.0)
    end

    if alpha.setEntityAlpha then
        if state then
            return SetEntityAlpha(cache.vehicle, alpha.alphaLevel, false)
        end
        ResetEntityAlpha(cache.vehicle)
    end
end

for k,v in pairs(Config.SafeZones.positions) do
    if Config.useBlip then 
        local radius = Config.SafeZones.blip
        local blip = AddBlipForRadius(v.coord, v.radius)
        SetBlipColour(blip, radius.colour)
        SetBlipAlpha(blip, radius.alpha)
    end

    local zone = lib.zones.sphere({coords = v.coord, radius = v.radius, debug = v.debug})
    function zone:onEnter()
        lib.notify({title = notify.EnterTitle, description = notify.EnterDescription, type = notify.EnterType, duration = notify.EnterDuration})
        hitOrLeave(true)
    end
    function zone:inside()
        setControlData(true)
    end
    function zone:onExit()
        lib.notify({title = notify.LeftTitle, description = notify.LeftDescription, type = notify.LeftType, duration = notify.LeftDuration})
        hitOrLeave(false)
        setControlData(false)
    end
end