-- VentilationEntry.lua
-- Приклад використання присідання для вентиляції
-- Розміщення: В моделі вентиляції як Script

local vent = script.Parent
local entrance = vent:WaitForChild("Entrance") -- Part біля входу
local exitPoint = vent:WaitForChild("Exit") -- Part на виході

-- Створюємо ProximityPrompt
local prompt = entrance:FindFirstChildOfClass("ProximityPrompt")
if not prompt then
	prompt = Instance.new("ProximityPrompt")
	prompt.Parent = entrance
end

prompt.ActionText = "Залізти у вентиляцію"
prompt.ObjectText = "Присядь (Ctrl)"
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.MaxActivationDistance = 5
prompt.HoldDuration = 0
prompt.RequiresLineOfSight = true
prompt.Enabled = true

-- ==========================================
-- 🔥 ЛОГІКА ВХОДУ У ВЕНТИЛЯЦІЮ
-- ==========================================

prompt.Triggered:Connect(function(player)
	local character = player.Character
	if not character then return end
	
	-- 🔽 ПЕРЕВІРКА: чи гравець присів?
	local isCrouching = _G.IsCrouching and _G.IsCrouching() or false
	
	if not isCrouching then
		-- Гравець НЕ присів
		warn("⚠️ Треба присісти щоб залізти у вентиляцію!")
		
		-- Показуємо підказку (опціонально)
		local hint = Instance.new("Hint")
		hint.Text = "Присядь (Ctrl або C) щоб залізти у вентиляцію!"
		hint.Parent = workspace
		game:GetService("Debris"):AddItem(hint, 3)
		
		return
	end
	
	-- ✅ Гравець присів - дозволяємо залізти
	print("✅ " .. player.Name .. " заліз у вентиляцію")
	
	-- Телепортуємо на вихід
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if rootPart then
		rootPart.CFrame = exitPoint.CFrame + Vector3.new(0, 2, 0)
		
		-- Звук залізання в вентиляцію
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://4918033632" -- Metal crawl
		sound.Volume = 0.5
		sound.Parent = rootPart
		sound:Play()
		game:GetService("Debris"):AddItem(sound, 2)
	end
end)

-- ==========================================
-- 🔥 ДИНАМІЧНА ПІДКАЗКА
-- ==========================================

-- Оновлюємо текст промпта залежно від того чи присів гравець
task.spawn(function()
	while true do
		task.wait(0.5)
		
		-- Знаходимо найближчого гравця
		local closestPlayer = nil
		local closestDistance = prompt.MaxActivationDistance
		
		for _, player in pairs(game.Players:GetPlayers()) do
			if player.Character then
				local root = player.Character:FindFirstChild("HumanoidRootPart")
				if root then
					local distance = (root.Position - entrance.Position).Magnitude
					if distance < closestDistance then
						closestDistance = distance
						closestPlayer = player
					end
				end
			end
		end
		
		-- Оновлюємо текст
		if closestPlayer then
			local isCrouching = _G.IsCrouching and _G.IsCrouching() or false
			
			if isCrouching then
				prompt.ObjectText = "Вентиляція ✅"
				prompt.ActionText = "Залізти"
			else
				prompt.ObjectText = "Вентиляція ❌ Присядь!"
				prompt.ActionText = "Не можу залізти"
			end
		end
	end
end)

print("✅ [Ventilation] Crouch required to enter")

-- ==========================================
-- 🔥 СТРУКТУРА ВЕНТИЛЯЦІЇ
-- ==========================================

--[[
Ventilation (Model)
  ├─ Entrance (Part) - вхід у вентиляцію
  │   └─ ProximityPrompt
  ├─ Exit (Part) - вихід з вентиляції
  ├─ Tunnel (Parts) - візуальна частина тунелю
  └─ VentilationEntry (Script) - цей скрипт

ВЛАСТИВОСТІ Entrance:
- Size: 2×1×2 (низький вхід)
- Position: біля підлоги
- Transparency: 0.5 (напівпрозорий)
- Color: сірий
- CanCollide: false

ВЛАСТИВОСТІ Exit:
- Size: 2×1×2
- Position: в іншій кімнаті
- Transparency: 1 (невидимий)
- CanCollide: false
--]]
