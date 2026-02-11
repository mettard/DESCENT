-- ПРИКЛАДИ ВИКОРИСТАННЯ СИСТЕМИ ЗДОРОВ'Я

====================================================
1. НАНЕСТИ УРОН ГРАВЦЮ (з серверного скрипта)
====================================================

-- Варіант А: через глобальну функцію (рекомендовано)
_G.DamagePlayer(player, 25, "Monster")
-- player — Player об'єкт
-- 25 — кількість HP
-- "Monster" — джерело урону (для логів)

-- Варіант Б: напряму через атрибут (не рекомендовано, бо без логіки)
local currentHP = player:GetAttribute("HP")
player:SetAttribute("HP", currentHP - 25)

====================================================
2. ВБИТИ ГРАВЦЯ МИТТЄВО
====================================================

_G.KillPlayer(player, "Fall")
-- Наприклад: падіння в яму, обрив троса ліфта

====================================================
3. ВИЛІКУВАТИ ГРАВЦЯ (з клієнтського скрипта)
====================================================

-- Приклад: гравець натискає Q щоб використати аптечку

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HealEvent = ReplicatedStorage:WaitForChild("HealEvent")

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.Q then
        -- Перевірити чи є аптечка в інвентарі (коли буде система інвентаря)
        local hasMedkit = true -- TODO: перевірка інвентаря
        
        if hasMedkit then
            HealEvent:FireServer(25) -- Лікує 25 HP
            print("Used medkit")
        end
    end
end)

====================================================
4. ПРИКЛАД: МОНСТР БЕ ГРАВЦЯ
====================================================

-- В скрипті монстра (ServerScript)

local monsterPart = script.Parent.HitPart -- Part що торкається гравця
local DAMAGE = 25
local COOLDOWN = 2 -- секунди між ударами

local lastHitTime = {}

monsterPart.Touched:Connect(function(hit)
    local character = hit.Parent
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local player = game.Players:GetPlayerFromCharacter(character)
    if not player then return end
    
    -- Перевірка чи гравець живий
    if not player:GetAttribute("IsAlive") then return end
    
    -- Cooldown
    local now = tick()
    if lastHitTime[player.UserId] and (now - lastHitTime[player.UserId]) < COOLDOWN then
        return
    end
    lastHitTime[player.UserId] = now
    
    -- Нанести урон
    _G.DamagePlayer(player, DAMAGE, "Monster")
end)

====================================================
5. ПРИКЛАД: ПАСТКА (МІНА)
====================================================

-- В скрипті міни (ServerScript)

local minePart = script.Parent
local DAMAGE = 50
local EXPLOSION_RADIUS = 10
local triggered = false

minePart.Touched:Connect(function(hit)
    if triggered then return end
    
    local character = hit.Parent
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    triggered = true
    
    -- Візуальний ефект вибуху (опціонально)
    local explosion = Instance.new("Explosion")
    explosion.Position = minePart.Position
    explosion.BlastRadius = EXPLOSION_RADIUS
    explosion.BlastPressure = 0 -- Не відкидати гравців
    explosion.Parent = workspace
    
    -- Пошкодити всіх гравців в радіусі
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local distance = (root.Position - minePart.Position).Magnitude
                if distance <= EXPLOSION_RADIUS then
                    _G.DamagePlayer(player, DAMAGE, "Mine")
                end
            end
        end
    end
    
    -- Знищити міну
    minePart:Destroy()
end)

====================================================
6. ПРИКЛАД: ОТРУЄННЯ (періодичний урон)
====================================================

-- Коли гравець заходить в газ

local function ApplyPoison(player, duration)
    local POISON_DAMAGE = 5 -- HP кожні 3 секунди
    local TICK_INTERVAL = 3
    
    local startTime = tick()
    
    while tick() - startTime < duration do
        if not player:GetAttribute("IsAlive") then break end
        
        _G.DamagePlayer(player, POISON_DAMAGE, "Poison")
        task.wait(TICK_INTERVAL)
    end
    
    print(player.Name .. " poison ended")
end

-- Виклик:
task.spawn(function()
    ApplyPoison(player, 30) -- 30 секунд отруєння
end)

====================================================
7. ПЕРЕВІРИТИ ЧИ ГРАВЕЦЬ ЖИВИЙ
====================================================

-- З будь-якого скрипта

local isAlive = player:GetAttribute("IsAlive")
if isAlive then
    print("Player is alive")
else
    print("Player is dead (spectator)")
end

====================================================
8. ОТРИМАТИ ПОТОЧНЕ HP
====================================================

local currentHP = player:GetAttribute("HP")
local maxHP = player:GetAttribute("MaxHP")
local percentage = (currentHP / maxHP) * 100

print("HP: " .. currentHP .. " / " .. maxHP .. " (" .. percentage .. "%)")

====================================================
ГОТОВО!
====================================================

Тепер система здоров'я повністю інтегрована.
Наступний крок — інвентар і аптечки, або перший монстр.
