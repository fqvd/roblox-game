local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local buildRagdoll = require(script:WaitForChild("buildRagdoll"))

local TAG_NAME = "Ragdoll"


local function setRagdollEnabled(character, isEnabled)
	local ragdollConstraints = character:FindFirstChild("RagdollConstraints")
	local humanoid = character:FindFirstChild("Humanoid")
	--if humanoid and not character:HasTag("Frozen") then
	--	humanoid.PlatformStand = isEnabled -- remove this line if you want ragdolls to be able to move
	--	humanoid:ChangeState(isEnabled and Enum.HumanoidStateType.Physics or Enum.HumanoidStateType.GettingUp)
	--end

	--if isEnabled then
		
	--	for _, animation in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
	--		animation:Stop(0)
	--	end
	--end
	
	--if ragdollConstraints == nil then
	--	return
	--end
	--for _, constraint in pairs(ragdollConstraints:GetChildren()) do
	--	if not constraint:IsA("Constraint") then continue end
		
	--	local rigidJointObject: ObjectValue = constraint:FindFirstChild("RigidJoint")
	--	if rigidJointObject == nil then continue end
	--	local rigidJoint = rigidJointObject.Value
	--	local expectedValue = (not isEnabled) and constraint.Attachment1.Parent or nil

	--	if rigidJoint.Part1 ~= expectedValue then
	--		rigidJoint.Part1 = expectedValue 
	--	end
	--end
end


local function ragdollAdded(character)
	-- only build a ragdoll on the server; it'll be replicated to the client and use that one
	-- also, only build a ragdoll when it's first needed
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if humanoidRootPart == nil then
		return
	end
	
	--if not character:FindFirstChild("RagdollConstraints") then
	--	buildRagdoll(character)
	--end
	
	character:SetAttribute("ApplyRagdollKnockback", true)
	setRagdollEnabled(character, true)
end

local function ragdollRemoved(character)
	character:SetAttribute("ApplyRagdollKnockback", nil)
	character:SetAttribute("ResetRagdoll", os.clock())
	setRagdollEnabled(character, false)
end

--CollectionService:GetInstanceAddedSignal("BuildRagdoll"):Connect(function(character)
--	buildRagdoll(character)
--	setRagdollEnabled(character, false)
--end)
--CollectionService:GetInstanceRemovedSignal("BuildRagdoll"):Connect(function(character)
--	local ragdollConstraints = character:FindFirstChild("RagdollConstraints")
--	if ragdollConstraints == nil then
--		return
--	end
--	ragdollConstraints:Destroy()
--end)
CollectionService:GetInstanceAddedSignal(TAG_NAME):Connect(ragdollAdded)
CollectionService:GetInstanceRemovedSignal(TAG_NAME):Connect(ragdollRemoved)
for _, character in pairs(CollectionService:GetTagged(TAG_NAME)) do
	ragdollAdded(character)
end

return nil
