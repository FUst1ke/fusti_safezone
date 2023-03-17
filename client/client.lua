function setControlData(toggle)
    if toggle then
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 263, true)
        DisableControlAction(0, 142, true)
        DisablePlayerFiring(PlayerId(), true)
    else
        DisableControlAction(0, 25, false)
        DisableControlAction(0, 140, false)
        DisableControlAction(0, 263, false)
        DisableControlAction(0, 142, false)
        DisablePlayerFiring(PlayerId(), false)
    end
end

for k,v in pairs(Config.SafeZones.positions) do
    SafeZones = {['safeZone'..k] = lib.zones.sphere({coords = v.coord, radius = v.radius, onEnter = onEnter, onExit = onExit, inside = inside, debug = v.debug})}
    if Config.useBlip then 
        local radius = Config.SafeZones.blip
        blip = AddBlipForRadius(v.coord, v.radius)
        SetBlipColour(blip, radius.colour)
        SetBlipAlpha(blip, radius.alpha)
    end
    for _,i in pairs(SafeZones) do
        local notify = Config.SafeZones.notify
        local vehicleConfig = Config.SafeZones.vehicle
        local alpha = Config.SafeZones.alpha
        local player = Config.SafeZones.player
        function i:onEnter()
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            lib.notify({title = notify.EnterTitle, description = notify.EnterDescription, type = notify.EnterType, duration = notify.EnterDuration})
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                if vehicleConfig.limit then
                    if vehicleConfig.metric == 'mph' then
                        SetEntityMaxSpeed(vehicle, vehicleConfig.maxSpeed * 2.23)
                    else
                        SetEntityMaxSpeed(vehicle, vehicleConfig.maxSpeed * 3.6)
                    end
                end
                SetPlayerCanDoDriveBy(PlayerId(), false)
                if alpha.setEntityAlpha then
                    SetEntityAlpha(vehicle, alpha.alphaLevel, false)
                end
            end
            if player.godMode then
                SetEntityInvincible(PlayerPedId(), true)
            end
        end
        function i:inside()
            setControlData(true)
        end
        function i:onExit()
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            lib.notify({title = notify.LeftTitle, description = notify.LeftDescription, type = notify.LeftType, duration = notify.LeftDuration})
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                SetEntityMaxSpeed(vehicle, 1000.0)
                SetPlayerCanDoDriveBy(PlayerId(), true)
                if alpha.setEntityAlpha then
                    ResetEntityAlpha(vehicle)
                end
            end
            if player.godMode then
                SetEntityInvincible(PlayerPedId(), false)
            end
            setControlData(false)
        end
    end
end