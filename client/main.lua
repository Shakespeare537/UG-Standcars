
Citizen.CreateThread(function()
    while true do
        local cooldown = 30
        local coords = GetEntityCoords(PlayerPedId())
        local car = Config.Cars[math.random(1,#Config.Cars)]
            if #(coords - car.coords) < Config.ShowRange then
                if car.spawned == nil then
                    SpawnCar()
                else
                    SetEntityHeading(car.spawned, GetEntityHeading(car.spawned) - spin)
                end
            end
        Citizen.Wait(cooldown)
    end
end)


function SpawnCar()
    local hash = Config.Cars[math.random(1,#Config.Cars)]
    RequestModel(hash.car)
    while not HasModelLoaded(hash.car) do
        Citizen.Wait(0)
    end
    local vehicle = CreateVehicle(hash.car, hash.coords.x, hash.coords.y, hash.coords.z-1, hash.heading, false, false)
    SetModelAsNoLongerNeeded(hash.car)
    SetVehicleEngineOn(vehicle, false)
    SetVehicleBrakeLights(vehicle, false)
    SetVehicleLights(vehicle, 0)
    SetVehicleLightsMode(vehicle, 0)
    SetVehicleOnGroundProperly(vehicle)
    FreezeEntityPosition(vehicle, true)
    SetVehicleCanBreak(vehicle, true)
    SetVehicleFullbeam(vehicle, false)
    if Config.Invisible then
        SetVehicleReceivesRampDamage(vehicle, true)
        RemoveDecalsFromVehicle(vehicle)
        SetVehicleCanBeVisiblyDamaged(vehicle, true)
        SetVehicleLightsCanBeVisiblyDamaged(vehicle, true)
        SetVehicleWheelsCanBreakOffWhenBlowUp(vehicle, false)  
        SetDisableVehicleWindowCollisions(vehicle, true)    
        SetEntityInvincible(vehicle, true)
    end
    if Config.LockCar then 
        SetVehicleDoorsLocked(vehicle, 2)
    end
    SetVehicleNumberPlateText(vehicle, hash.plate)
    hash.spawned = vehicle
end

AddEventHandler("onResourceStop", function(res)
    local car = Config.Cars[math.random(1,#Config.Cars)]
    if res == GetCurrentResourceName() then
        if car.spawned ~= nil then
            DeleteEntity(car.spawned)
        end 
    end
end)
