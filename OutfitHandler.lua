local repStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local boards = workspace.Main.Boards

local current = nil

-- Display via queue
local function displayOnQueue(item)
	-- Check if player exists
	local id = players:GetUserIdFromNameAsync(item)
	
	if id then
		local template = boards.Queue.Template:Clone()
		template.ImageLabel.Image = players:GetUserThumbnailAsync(id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		template.Name = item
		template.Number.Text = "#" .. tostring(#boards.Queue.SurfaceGui.Frame.Frame.ScrollingFrame:GetChildren() + 1)
		template.ID.Value = id
		template.Parent = boards.Queue.SurfaceGui.Frame.Frame.ScrollingFrame
	end
end

-- Apply descriptions on event
repStorage.OutfitSystem.TryOn.OnServerEvent:Connect(function(player, humanoidDesc)
	player.Character.Humanoid:ApplyDescription(humanoidDesc)
end)

repStorage.OutfitSystem.ResetAvatar.OnServerEvent:Connect(function(player)
	player.Character.Humanoid:ApplyDescription(players:GetHumanoidDescriptionFromUserId(player.UserId))
end)

-- Display
repStorage.OutfitSystem.Request.OnServerEvent:Connect(function(player, name)
	displayOnQueue(name)
end)

-- TODO: Update
-- Teleport to displayer zone
repStorage.OutfitSystem.Teleport.OnServerEvent:Connect(function(player)
	player.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-101.5, 5.5, -24.5))
end)
