spawned = nil
Citizen.CreateThread(function()
    while true do
        local cooldown = 60
        local coords = GetEntityCoords(PlayerPedId())
        local car = Config.Cars[math.random(1,#Config.Cars)]
            if #(coords - car.coords) < Config.ShowRange then
                if car.spawned == nil then
                    SpawnCar()
                else
                    TriggerEvent("ug-standcars:spin", 0.3)
                end
            end
        Citizen.Wait(cooldown)
    end
end)

RegisterNetEvent("ug-standcars:spin")
AddEventHandler("ug-standcars:spin", function(spin)
    local car = Config.Cars[math.random(1,#Config.Cars)]
    if car.spin then
        SetEntityHeading(car.spawned, GetEntityHeading(car.spawned) - spin)
    end
end)


function SpawnCar()
    for i=1 , #Config.Cars do
        RequestModel(Config.Cars[i].car)
        while not HasModelLoaded(Config.Cars[i].car) do
            Citizen.Wait(0)
        end
        local vehicle = CreateVehicle(Config.Cars[i].car, Config.Cars[i].coords.x, Config.Cars[i].coords.y, Config.Cars[i].coords.z-1, Config.Cars[i].heading, false, false)
        SetModelAsNoLongerNeeded(Config.Cars[i].car)
        SetVehicleEngineOn(vehicle, false)
        SetVehicleBrakeLights(vehicle, false)
        SetVehicleLights(vehicle, 0)
        SetVehicleLightsMode(vehicle, 0)
        SetVehicleOnGroundProperly(vehicle)
        SetVehicleColours(
	    vehicle --[[ Vehicle ]], 
	    Config.Cars[i].colorPrimary --[[ integer ]], 
	    Config.Cars[i].colorPrimary --[[ integer ]]
        )
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
        SetVehicleNumberPlateText(vehicle, Config.Cars[i].plate)
        Config.Cars[i].spawned = vehicle
    end
end


AddEventHandler("onResourceStop", function()
    if res == GetCurrentResourceName() then
        for i=1 , #Config.Cars do
            DeleteEntity(Config.Cars[i].car)
        end
    end
end)