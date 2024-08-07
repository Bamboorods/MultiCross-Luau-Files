
task.spawn(function()
    repeat
        task.wait()
    until game:IsLoaded()

    -- Accessing shared modules
    local AimbotModule = shared.SharedModules.AimbotModule

    -- Example usage of the modules
    if AimbotModule then
        AimbotModule.ShowFoV(true)
    end
end)
