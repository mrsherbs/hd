-- // Constants \\ --
local GroupId = game.CreatorId
local GroupModule = require(game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GroupModule"))
local Event = game.ReplicatedStorage.Events.PlayerTags
local PlayerTag = script.PlayerTag
local MarketplaceService = game:GetService("MarketplaceService")
local Badges = game.ServerStorage.Resources.Badges

-- // OnServerEvent \\ --
game.Players.PlayerAdded:Connect(function(player)

	player.CharacterAdded:Connect(function()
		
		
		-- Create tag
		local Character = player.Character
		local Head = Character:WaitForChild("Head")
		local NewTag = PlayerTag:Clone()	

		NewTag.Parent = Head
		Character:WaitForChild("Humanoid").DisplayDistanceType = "None"
		Character:WaitForChild("Humanoid").HealthDisplayType = "AlwaysOff"

		NewTag.Container.Rank.Text = GroupModule:GetRoleInGroup(player, GroupId)
		
		-- Add display name, if it exists
		if player.DisplayName == player.Name then
			NewTag.Container.Username.Text = player.Name
		elseif player.DisplayName ~= player.Name then
			NewTag.Container.Username.Text = player.DisplayName.." (@"..player.Name..")"
		end
		
		-- Check premium
		if player.MembershipType == Enum.MembershipType.Premium then
			local Badge = Badges.RobloxPremium
			local NewBadge = Badge:Clone()
			NewBadge.Parent = NewTag.Container.Badges
		end
		
		-- Rank check
		if GroupModule:GetRankInGroup(player, GroupId) >= 9 then
			local Badge = Badges.Staff
			local NewBadge = Badge:Clone()
			NewBadge.Parent = NewTag.Container.Badges
		end

		if GroupModule:GetRankInGroup(player, GroupId) == 2 then
			local Badge = Badges.Verified
			local NewBadge = Badge:Clone()
			NewBadge.Parent = NewTag.Container.Badges
		end

		if GroupModule:GetRankInGroup(player, GroupId) >= 19 then
			local Badge = Badges.Developer
			local NewBadge = Badge:Clone()
			NewBadge.Parent = NewTag.Container.Badges
			NewTag.Container.Username.UIGradient.Enabled = true
			NewTag.Container.Username.Rainbow.Disabled = false
		end
		
		-- Gamepass check
		if MarketplaceService:UserOwnsGamePassAsync(player.UserId, 20737454) then
			local Badge = Badges.Premium
			local NewBadge = Badge:Clone()
			NewBadge.Parent = NewTag.Container.Badges
			NewTag.Container.Username.UIGradient.Enabled = true
			NewTag.Container.Username.Rainbow.Disabled = false
		end
	end)
end)
