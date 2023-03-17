Config = {}

Config.useBlip = true

Config.SafeZones = {
    player = {
        godMode = true
    },
    vehicle = {
        limit = true,
        metric = 'mph',  -- 'kph' (*3.6) / 'mph' (*2.23)
        maxSpeed = 5.0
    },
    alpha = {
        setEntityAlpha = true,
        alphaLevel = 151 -- The alpha level ranges from 0 to 255, but changes occur every 20% (every 51).
    },
    blip = {
        size = 40.0,
        colour = 1,
        alpha = 150
    },
    positions = {
        {coord = vector3(245.4583, -771.6877, 30.7168), radius = 70.0, debug = false}
    },
    notify = {
        EnterTitle = 'Information',
        EnterDescription = 'You entered to the safezone',
        EnterType = 'inform',
        EnterDuration = 3000,
        -----------------------------------------------------
        LeftTitle = 'Information',
        LeftDescription = 'You have left from the safezone',
        LeftType = 'inform',
        LeftDuration = 3000
    }
}