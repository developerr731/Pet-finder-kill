-- // Steal a Brainrot - Auto Finder & Join
-- Busca servers que tengan brainrots específicos y solo se queda si los encuentra

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PlaceID = game.PlaceId
local JobID = game.JobId
local cursor = nil

-- 👇 nombres de brainrots que quieres buscar
local Targets = {
    "Tralalero Tralala",
    "La grande combinacion",
    "Los cocodrilitos",
    "Los tralaleritos",
}

-- función que revisa si en este server existen brainrots de la lista
local function hasBrainrots()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Folder") then
            for _, name in pairs(Targets) do
                if string.find(string.lower(obj.Name), string.lower(name)) then
                    return true
                end
            end
        end
    end
    return false
end

-- función para obtener lista de servers públicos
local function getServers()
    local url = "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
    if cursor then
        url = url.."&cursor="..cursor
    end
    local data = HttpService:JSONDecode(game:HttpGet(url))
    local servers = {}
    for _,v in pairs(data.data) do
        if v.playing < v.maxPlayers and v.id ~= JobID then
            table.insert(servers, v.id)
        end
    end
    cursor = data.nextPageCursor
    return servers
end

-- ciclo infinito: hop hasta encontrar un brainrot de la lista
while task.wait(3) do
    if hasBrainrots() then
        game.StarterGui:SetCore("SendNotification", {
            Title = "✅ FOUND!",
            Text = "Este server tiene un brainrot de tu lista 🔥",
            Duration = 10
        })
        break -- se queda en este server
    else
        local servers = getServers()
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(PlaceID, servers[math.random(1, #servers)], Players.LocalPlayer)
        end
    end
end
