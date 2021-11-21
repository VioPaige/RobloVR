-- Services
local rStorage = game:GetService("ReplicatedStorage")
local sStorage = game:GetService("ServerStorage")



-- Instances
	-- Folders
local remoteFolder = rStorage:WaitForChild("Remotes")
local partFolder = sStorage:WaitForChild("Test")
	-- Other
local printRemote = remoteFolder:WaitForChild("print")
local movementRemote = remoteFolder:WaitForChild("movement")


-- Variables
local baseplaced = {}




-- Functions
function serverPrint(plr, msg)
	
	print("(" ..plr.Name.. ") - " ..msg)
	
end





function movement(plr, controller, newCframe)
	coroutine.wrap(function()
		if not baseplaced[plr.Name] then
			if controller == "Head" then
				local base = partFolder:WaitForChild("Base"):Clone()
				if not baseplaced[plr.Name] then
					base.CFrame = newCframe
					base.Parent = workspace:WaitForChild(plr.Name .. "objects")
					baseplaced[plr.Name] = true
				end
			end
		end
	end)()

	if controller == "Head" then
		newCframe = newCframe * CFrame.new(0, 5.5, 0)
	else
		newCframe = newCframe * CFrame.new(0, 2.4, 0)
	end

	
	if not workspace:FindFirstChild(plr.Name .. "objects") then
		local targetPart = partFolder:WaitForChild(controller):Clone()
		targetPart.CFrame = newCframe
		targetPart.Position += newCframe.Position --+ plr.Character.HumanoidRootPart.Position
		
		local folder = Instance.new('Folder')
		folder.Name = plr.Name .. "objects"
		folder.Parent = workspace
		
		targetPart.Parent = folder
		
	else
		if not workspace[plr.Name .. "objects"]:FindFirstChild(controller) then
			local targetPart = partFolder:WaitForChild(controller):Clone()
			targetPart.Parent = workspace[plr.Name .. "objects"]
			targetPart.CFrame = workspace[plr.Name .. "objects"]:WaitForChild("Base").CFrame * newCframe
			targetPart.Position = newCframe.Position + workspace[plr.Name .. "objects"]:WaitForChild("Base").CFrame.Position
		else
			local folder = workspace[plr.Name .. "objects"]
			local targetPart = folder[controller]
			targetPart.CFrame = workspace[plr.Name .. "objects"]:WaitForChild("Base").CFrame * newCframe
			targetPart.Position = newCframe.Position + workspace[plr.Name .. "objects"]:WaitForChild("Base").CFrame.Position
		end
	end
end










-- Events
printRemote.OnServerEvent:Connect(serverPrint)
movementRemote.OnServerEvent:Connect(movement)

