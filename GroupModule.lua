local G = {}
local cache = {}

-- Get groups
function getData(player, cache2)
	if cache[player.UserId] and cache[player.UserId]['time'] >= os.time() - 60 and cache2 == true then
		return cache[player.UserId]['tab']
	else
		local groups = nil
		local suc,err = pcall(function()
    		groups = game:GetService('GroupService'):GetGroupsAsync(player.UserId)
		end)
		if suc then
			cache[player.UserId] = {['tab'] = groups; ['time'] = os.time()}
    		return groups
		else
			return nil
		end
	end
end


-- Get rank
function G:GetRankInGroup(player, groupid, cache2)
	if type(cache2) ~= "boolean" then cache2 = true end
	local suc = getData(player, cache2)
	if suc then
    	for place,group in pairs (suc) do
        	if group.Id == groupid then
            	return group.Rank
        	end
    	end
		return 0
	else
		return player:GetRankInGroup(groupid)
	end
end

-- Get role
function G:GetRoleInGroup(player, groupid, cache2)
	if type(cache2) ~= "boolean" then cache2 = true end
	local suc = getData(player, cache2)
	if suc then
    	for place,group in pairs (suc) do
        	if group.Id == groupid then
            	return group.Role
        	end
    	end
		return 'Guest'
	else
		return player:GetRoleInGroup(groupid)
	end
end


-- Check if in group
function G:IsInGroup(player, groupid, cache2)
   if type(cache2) ~= "boolean" then cache2 = true end
   local suc = getData(player, cache2)
	if suc then
    	for place,group in pairs (suc) do
        	if group.Id == groupid then
            	return true
	        	end
	    end
    	return false
	else
		return player:IsInGroup(groupid)
	end
end
return G
