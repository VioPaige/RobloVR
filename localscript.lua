-- Services
local vService = game:GetService("VRService")
local rStorage = game:GetService("ReplicatedStorage")
local rService = game:GetService("RunService")


-- Instances
	-- Folders
local remoteFolder = rStorage:WaitForChild("Remotes")


	-- Other
local printRemote = remoteFolder:WaitForChild("print")
local movementRemote = remoteFolder:WaitForChild("movement")

local plr = game.Players.LocalPlayer


-- Variables
local CFrames = {}
local CFrames2 = { -- you can ignore this
	Head = {
		CFrame.new(0, 0, 0)	
	},
	LeftHand = {
		CFrame.new(0, 0, 0)
	},
	RightHand = {
		CFrame.new(0, 0, 0)
	}
}




-- Functions
function init() -- init function
	if vService.VREnabled then
		workspace.Gravity = 0

		print("Input type: " ..vService.GuiInputUserCFrame.Name)
		serverPrint("Input type: " ..vService.GuiInputUserCFrame.Name)
	else 
		print("Non-VR player.")
		serverPrint("Non-VR player")
	end
end



function initCFrames()
	wait(2)
	local succ, err = pcall(function()
		if vService.VREnabled then
			serverPrint("vService.VREnabled == true")
			local cfTypes = {
				Enum.UserCFrame.Head,
				Enum.UserCFrame.LeftHand,
				Enum.UserCFrame.RightHand
			}
			local camtrackingon = false
			for _, v in pairs(cfTypes) do
				serverPrint("type: " .. v.Name)
				coroutine.wrap(function()
					local loop = 0
					serverPrint("coroutine init")
					while wait() do

						local length = #CFrames2[v.Name]
						local usercframe = vService:GetUserCFrame(v)
						usercframe = usercframe * CFrame.new(0, 5.5, 0)

						CFrames2[v.Name][length] = usercframe


						if length >= 60 then
							CFrames2[v.Name][1] = nil
						end
						if camtrackingon == false then
							coroutine.wrap(function()

								serverPrint("started the cam coroutine")
								local folder = workspace:WaitForChild(plr.Name .. "objects")
								local head = folder:WaitForChild("Head")
								workspace.CurrentCamera.CameraSubject = head	
								workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
								plr.CameraMaxZoomDistance = .5
								plr.CameraMinZoomDistance = .5
								camtrackingon = true
								while wait(1/90) do
									workspace.CurrentCamera.CFrame = head.CFrame
								end
							end)()
						end
						if loop >= 2 then
							movementRemote:FireServer(v.Name, usercframe)
							loop = 0
						else
							loop +=1
						end
					end
				end)()
			end
		else
			serverPrint("vService.VREnabled == false")
		end
	end)
	
	if not succ then
		serverPrint(err)
	end
	
end




function initCamera()
	local succ, err = pcall(function()
		serverPrint("initCamera")
		local folder = workspace:WaitForChild(plr.Name .. "objects")
		folder:WaitForChild("LeftHand")
		folder:WaitForChild("RightHand")
		local head = folder:WaitForChild("Head")
		workspace.CurrentCamera.CameraSubject = head
		plr.CameraMaxZoomDistance = 0
		plr.CameraMinZoomDistance = 0
		serverPrint("initCamera ready")
	end)
	
	if not succ then
		serverPrint(err)
	end
end



function resetCFrame() -- recenters user CFrame to headset position
	
	vService:RecenterUserHeadCFrame()
	serverPrint("Recentered user CFrame")
	
end



function serverPrint(msg)
	
	printRemote:FireServer(msg)
	
end




-- Events
init()
initCFrames()
