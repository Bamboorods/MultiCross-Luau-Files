
shared.MODULE_LOADING = shared.MODULE_LOADING or false

if shared.MODULE_LOADING then return end

shared.MODULE_LOADING = true

-- Step 1: Define Repository Information
-- Define the repository owner, repository name, and the URL format for accessing the raw files.
local Data = {
    GithubRepOwner = "Bamboorods",
    GithubRepName = "MultiCross-Luau-Files",
    ModulesFolder = "https://raw.githubusercontent.com/%s/%s/main/Modules/%s.lua",
}

-- Step 2: Fetch the Module Source
-- Create a function to construct the URL and fetch the raw content of the Lua file using `game:HttpGet`.
local function getModuleSource(moduleName)
    local fetchedSource, returnSource = pcall(function()
        local moduleUrl = Data.ModulesFolder:format(Data.GithubRepOwner, Data.GithubRepName, moduleName)
        return game:HttpGet(moduleUrl, true)
    end)
    return fetchedSource and returnSource
end

-- Step 3: Load the Module
-- Create a function to safely load the fetched content as a Lua chunk using `loadstring`.
local function safeLoadString(source)
    local success, returnVal = pcall(loadstring, source)
    return success and returnVal
end

-- Step 4: Safe Load
-- Create a function to safely execute a loaded chunk.
local function safeLoad(callBack)
    if type(callBack) ~= "function" then return end

    local success, returnVal = pcall(callBack)
    return success and returnVal
end

-- Step 5: Store and Access Modules
-- Use the above functions to fetch, load, and store the modules in the `shared` table.
-- This ensures that the modules are loaded only once and can be accessed globally.

-- Define the modules
local Modules = {
    AimbotModule = "AimbotModule",
}

-- Initialize the shared modules table
shared.SharedModules = shared.SharedModules or {}

-- Load and store each module
for ModuleIndex, ModuleName in pairs(Modules) do
    if shared.SharedModules[ModuleIndex] ~= nil then continue end

    local moduleSource = getModuleSource(ModuleName)
    local loadedModule = safeLoadString(moduleSource)

    if loadedModule then
        local moduleData = safeLoad(loadedModule)
        if not moduleData then
            warn("Failed to load module: " .. ModuleName)
            break
        end

        shared.SharedModules[ModuleIndex] = moduleData
        continue
    end

    warn("Failed to load module: " .. ModuleName)
end

shared.MODULE_LOADING = false

-- Step 6: Access and Use the Modules
-- In another script, you can access these modules using the `shared` table.
-- This allows different parts of the script to use the same modules without needing to reload them.

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

--[[
    Summary:
    - Define Repository Information: Specify the repository owner, name, and URL format.
    - Fetch Module Source: Construct the URL and fetch the raw content using `game:HttpGet`.
    - Load Module: Use `loadstring` to execute the fetched content.
    - Store and Access Modules: Store the loaded modules in the `shared` table and access them as needed.

    This approach ensures that the script can dynamically load and use modules from a GitHub repository,
    making it modular and easy to maintain.
]]
