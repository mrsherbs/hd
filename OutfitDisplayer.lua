local mps = game:GetService("MarketplaceService")
local repStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local player = players.LocalPlayer
local ui = player.PlayerGui:WaitForChild("MainUI")
local accessories = {}
local currentOutfit = nil

-- Clear UI
local function clearGui(gui)
	for i, element in pairs(gui:GetChildren()) do
		if element.Name ~= "Template" and element:IsA("ImageButton") then
			element:Destroy()			
		end
	end
end

-- Display Item
local function displayItem(item)
	local template = ui.OutfitViewer.ItemsContainer.Template:Clone()
	local url = "rbxthumb://type=Asset&id="
	local url2 = "&w=420&h=420"

	template.Image = url .. tostring(item) .. url2

	template.Activated:Connect(function()
		mps:PromptPurchase(player, item)
	end)

	template.Visible = true
	template.Name = tostring(item)
	template.Parent = ui.OutfitViewer.ItemsContainer
end

-- Display all accessories
for _, display in pairs(workspace.Displays:GetChildren()) do
	accessories[display] = {}

	for i,v in pairs(string.split(display.HumanoidDescription.BackAccessory, ",")) do
		table.insert(accessories[display], v)
	end	

	for i,v in pairs(string.split(display.HumanoidDescription.FaceAccessory, ",")) do
		table.insert(accessories[display], v)
	end	

	for i,v in pairs(string.split(display.HumanoidDescription.FrontAccessory, ",")) do
		table.insert(accessories[display], v)
	end

	for i,v in pairs(string.split(display.HumanoidDescription.HairAccessory, ",")) do
		table.insert(accessories[display], v)
	end

	for i,v in pairs(string.split(display.HumanoidDescription.HatAccessory, ",")) do
		table.insert(accessories[display], v)
	end

	for i,v in pairs(string.split(display.HumanoidDescription.NeckAccessory, ",")) do
		table.insert(accessories[display], v)
	end

	for i,v in pairs(string.split(display.HumanoidDescription.ShouldersAccessory, ",")) do
		table.insert(accessories[display], v)
	end

	for i,v in pairs(string.split(display.HumanoidDescription.WaistAccessory, ",")) do
		table.insert(accessories[display], v)
	end
	
	for i,v in pairs(string.split(display.HumanoidDescription.Shirt, ",")) do
		table.insert(accessories[display], v)
	end
	
	for i,v in pairs(string.split(display.HumanoidDescription.Pants, ",")) do
		table.insert(accessories[display], v)
	end
	
	for i,v in pairs(string.split(display.HumanoidDescription.Face, ",")) do
		if v == "0" then
		else
			table.insert(accessories[display], v)
		end
	end

	temp = {}
	for index, accescory in ipairs(accessories[display]) do
		if accescory == "" or accescory == 0 then
		else
			table.insert(temp, accescory)
		end
	end
	accessories[display] = temp
end

ui.Left.ResetAvatar.Activated:Connect(function()
	repStorage.OutfitSystem.ResetAvatar:FireServer()
end)

-- Load
ui.LoadUser.Close.Activated:Connect(function()
	ui.LoadUser.Visible = false
end)

ui.LoadUser.Request.Activated:Connect(function()
	repStorage.OutfitSystem.Request:FireServer(ui.LoadUser.TextBox.Text)
end)

-- Update when player leaves area
ui.Left.OutfitLoader.Activated:Connect(function()
	if (player.Character.HumanoidRootPart.Position - Vector3.new(-101.5, 5.5, -24.5)).Magnitude > 50 then
		repStorage.OutfitSystem.Teleport:FireServer()
	else
		ui.LoadUser.Visible = true
	end
end)

-- CLose
ui.OutfitViewer.Close.Activated:Connect(function()
	clearGui(ui.OutfitViewer.ItemsContainer)
	ui.OutfitViewer.Visible = false
end)

ui.OutfitViewer.Try.Activated:Connect(function()
	repStorage.OutfitSystem.TryOn:FireServer(currentOutfit)
end)

for _, display in pairs(workspace.Displays:GetChildren()) do
	display.ClickDetector.MouseClick:Connect(function()
		ui.OutfitViewer.Visible = true
		currentOutfit = display.HumanoidDescription

		clearGui(ui.OutfitViewer.ItemsContainer)

		for _, accessory in accessories[display] do
			displayItem(accessory)
		end
	end)
end
