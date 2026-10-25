local KeySystem = {}

KeySystem.KeysURL = "https://raw.githubusercontent.com/Mixvpnv2/ProtogenLib/main/System/Keys.txt"
KeySystem.ScriptURL = "https://raw.githubusercontent.com/Mixvpnv2/CatteState/refs/heads/main/MainScripts/Main.lua"
KeySystem.SaveKey = true
KeySystem.FileName = "CatteState/key.txt"

local function httpGet(url)
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    return ok and res or nil
end

local function readSaved()
    if not KeySystem.SaveKey then return nil end
    if isfile and isfile(KeySystem.FileName) then
        return readfile(KeySystem.FileName)
    end
    return nil
end

local function saveKey(key)
    if not KeySystem.SaveKey then return end
    if makefolder then
        pcall(makefolder, "CatteState")
    end
    if writefile then
        pcall(writefile, KeySystem.FileName, key)
    end
end

function KeySystem:FetchKeys()
    local body = httpGet(self.KeysURL)
    if not body then return {} end

    local list = {}
    for line in body:gmatch("[^\r\n]+") do
        line = line:gsub("%s+", "")
        if line ~= "" and not line:find("^#") then
            list[line] = true
        end
    end
    return list
end

function KeySystem:IsValid(key)
    if type(key) ~= "string" or key == "" then return false end
    key = key:gsub("%s+", "")
    local keys = self:FetchKeys()
    return keys[key] == true
end

function KeySystem:TrySaved()
    local saved = readSaved()
    if saved and self:IsValid(saved) then
        return saved
    end
    return nil
end

function KeySystem:Accept(key)
    key = key:gsub("%s+", "")
    if not self:IsValid(key) then
        return false, "Invalid key"
    end
    saveKey(key)
    return true, "OK"
end

function KeySystem:LoadScript()
    local src = httpGet(self.ScriptURL)
    if not src then
        return false, "Failed to fetch script"
    end
    local fn, err = loadstring(src)
    if not fn then
        return false, err or "loadstring failed"
    end
    task.spawn(fn)
    return true, "Loaded"
end

return KeySystem
