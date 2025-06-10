--//Camera Script//--
--Services
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
 
--Player
local Player = game.Players.LocalPlayer
repeat wait() until Player.Character
repeat wait() until Player.Character.Humanoid
repeat wait() until Player.Character.HumanoidRootPart
local Character = Player.Character
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid
local CamScript = Player.PlayerScripts.CameraScript
CamScript.Disabled = true
Humanoid.AutoRotate = false
 
--Mouse
local Mouse = Player:GetMouse()
 
--Variables
local Popper = true     --  Sets whether Popper Cam behaviour is enabled
local DeltaX = 0
local DeltaY = 0
local AngleH = 0
local AngleV = 0
local SensitivityY = 120    --  Determines how large a change in vertical angle is through a mouse rotation
local SensitivityX = 120    --  Determines how large a change in the horizontal angle is through a mouse rotation
local W = false
local A = false
local S = false
local D = false
local Offset = CFrame.new(2, 3, 15) --  Determines the CFrame by which the camera is pushed from the CFrame of the HumanoidRootPart
local MaxY = 5*math.pi/12               --  Determines maximum vertical angle
local MinY = -5*math.pi/12          --  Determines minimum vertical angle
local Combinations = {
    {true, false, false, false, 0, 0},
    {true, true, false, false, math.pi/4},
    {false, true, false, false, math.pi/2},
    {false, true, true, false, 3*math.pi/4},
    {false, false, true, false, math.pi},
    {false, false, true, true, 5*math.pi/4},
    {false, false, false, true, 3*math.pi/2},
    {true, false, false, true, 7*math.pi/4}
}
 
--Camera
local Cam = game.Workspace.CurrentCamera
Cam.CameraType = Enum.CameraType.Scriptable
UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
local FakeCam = Cam:Clone()
 
--Functions
RunService.RenderStepped:Connect(function()
    AngleH = AngleH - DeltaX/SensitivityX
    DeltaX = 0
    AngleV = math.clamp(AngleV - DeltaY/SensitivityY, MinY, MaxY)
    DeltaY = 0
    local FinalCFrame = CFrame.new(HumanoidRootPart.Position) * CFrame.Angles(0, AngleH, 0) * CFrame.Angles(AngleV, 0, 0) * Offset
    Cam.CoordinateFrame = FinalCFrame
    if(Popper == true) then
        local Direction = (FinalCFrame.p - Character.Head.Position).Unit * ((Offset.p).Magnitude)
        local CheckRay = Ray.new(Character.Head.Position, Direction)
        local Part, Position = game.Workspace:FindPartOnRay(CheckRay, Character, false, true)
        if Part then
            local Distance = Cam:GetLargestCutoffDistance({Character})
            Cam.CoordinateFrame = Cam.CoordinateFrame * CFrame.new(0, 0, -Distance)
        end
    end
    if(W == true) or (A == true) or (S == true) or (D == true) then
        for Num, Val in pairs(Combinations) do
            if(Val[1] == W) and (Val[2] == A) and (Val[3] == S) and (Val[4] == D) then
                local DirectionVector = Cam.CoordinateFrame.lookVector
                local Position = HumanoidRootPart.Position
                local TargetCFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + Vector3.new(DirectionVector.X, 0, DirectionVector.Z))
                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:lerp(TargetCFrame * CFrame.Angles(0, Val[5], 0), 0.25)
            end
        end     
    end
end)
 
UIS.InputChanged:Connect(function(Input, Bool)
    if(Bool == false) then
        if(Input.UserInputType == Enum.UserInputType.MouseMovement) then
            if(DeltaX ~= Input.Delta.X) then
                DeltaX = Input.Delta.X
            end
            if(DeltaY ~= Input.Delta.Y) then
                DeltaY = Input.Delta.Y
            end
        end
    end
end)
 
UIS.InputBegan:Connect(function(Input, Bool)
    if(Bool == false) then
        if(Input.KeyCode == Enum.KeyCode.W) then
            W = true
        elseif(Input.KeyCode == Enum.KeyCode.A) then
            A = true
        elseif(Input.KeyCode == Enum.KeyCode.S) then
            S = true
        elseif(Input.KeyCode == Enum.KeyCode.D) then
            D = true
        end
    end
end)
 
UIS.InputEnded:Connect(function(Input, Bool)
    if(Bool == false) then
        if(Input.KeyCode == Enum.KeyCode.W) then
            W = false
        elseif(Input.KeyCode == Enum.KeyCode.A) then
            A = false
        elseif(Input.KeyCode == Enum.KeyCode.S) then
            S = false
        elseif(Input.KeyCode == Enum.KeyCode.D) then
            D = false
        end
    end
end)
