local Valkyrie = _G.Valkyrie;
local RemoteCommunication = Valkyrie:GetComponent("RemoteCommunication");
local DataTypes = Valkyrie:GetComponent("DataTypes");

local Controller = {};
local extract;

-- |: Increment
-- |~ IncrementStep, Step
-- |< Instance<Player> Player, string AchievementName, int ?Increment = 1
-- |> bool Success, int NewStep, bool Awarded
Controller.Increment = function(...)
	local Player, AchievementName, Increment = extract(...);
	Increment = Increment or 1;
	assert(
		DataTypes(Player) == 'Instance' and Player:IsA('Player'),
		"[Error][Valkyrie Achievements] (in Increment): You need to supply a Player as #1",
		2
	);
	assert(
		type(AchievementName) == 'string',
		"[Error][Valkyrie Achievements] (in Increment): You need to supply a string as #2",
		2
	);
	assert(
		type(Increment) == 'number',
		"[Error][Valkyrie Achievements] (in Increment): You need to supply a number as #3",
		2
	);
	Increment = math.floor(Increment+.5);
	return RemoteCommunication.Achievement:Increment{
	    Player = Player;
	    Achievement = AchievementName;
	    Value = Increment;
	};
end;
Controller.IncrementStep = Controller.Increment;
Controller.Step = Controller.Increment;

-- |: Reveal
-- |~ Show
-- |< Instance<Player> Player, string AchievementName
-- |> bool Success
Controller.Reveal = function(...)
	local Player, AchievementName = extract(...);
	assert(
		DataTypes(Player) == 'Instance' and Player:IsA('Player'),
		"[Error][Valkyrie Achievements] (in Reveal): You need to supply a Player as #1",
		2
	);
	assert(
		type(AchievementName) == 'string',
		"[Error][Valkyrie Achievements] (in Reveal): You need to supply a string as #2",
		2
	);
	return RemoteCommunication.Achievement:Reveal{
	    Player = Player;
	    Achievement = AchievementName;
	};
end;
Controller.Show = Controller.Reveal

-- |: Award
-- |~ Unlock, Give, GiveAchievement, AwardAchievement
-- |< Instance<Player> Player, string AchievementName
-- |> bool Success, bool AlreadyAwarded
Controller.Award = function(...)
	local Player, AchievementName = extract(...);
	assert(
		DataTypes(Player) == 'Instance' and Player:IsA('Player'),
		"[Error][Valkyrie Achievements] (in Award): You need to supply a Player as #1",
		2
	);
	assert(
		type(AchievementName) == 'string',
		"[Error][Valkyrie Achievements] (in Award): You need to supply a string as #2",
		2
	);
	return RemoteCommunication.Achievement:Award{
	    Player = Player;
	    Achievement = AchievementName;
	};
end;
Controller.Unlock = Controller.Award;
Controller.Give = Controller.Award;
Controller.GiveAchievement = Controller.Award;
Controller.AwardAchievement = Controller.Award;

-- |: SetStep
-- |~ SetStage, SetState
-- |< Instance<Player> Player, string AchievementName, int NewStep
-- |> bool Success, int NewStep, bool Awarded
Controller.SetStep = function(...)
	local Player, AchievementName, NewStep = extract(...);
	assert(
		DataTypes(Player) == 'Instance' and Player:IsA('Player'),
		"[Error][Valkyrie Achievements] (in SetStep): You need to supply a Player as #1",
		2
	);
	assert(
		type(AchievementName) == 'string',
		"[Error][Valkyrie Achievements] (in SetStep): You need to supply a string as #2",
		2
	);
	assert(
		type(AchievementName) == 'number',
		"[Error][Valkyrie Achievements] (in SetStep): You need to supply a number as #3",
		2
	);
	NewStep = math.floor(NewStep+.5);
	-- If NewStep is less than the current step, keep the current.
	return RemoteCommunication.Achievement:SetStep{
	    Player = Player;
	    Achievement = AchievementName;
	    Value = NewStep;
	};
end;
Controller.SetStage = Controller.SetStep;
Controller.SetState = Controller.SetStep;

-- |: List
-- |~ ListAchievements, GetAchievements
-- |< Instance<Player> Player
-- |> table {
--      ... = {
--        DisplayName = string AchievementDisplayName,
--        Name = string AchievementIdentifierName,
--        ?Steps = int Steps,
--        Awarded = bool HasAchievement,
--        Hidden = bool IsHidden
--      }
--    } AchievementsList
Controller.List = function(...)
	local Player = extract(...);
	assert(
		DataTypes(Player) == 'Instance' and Player:IsA('Player'),
		"[Error][Valkyrie Achievements] (in List): You need to supply a Player as #1",
		2
	);
    return RemoteCommunication.Achievement:GetAchievements{
        Player = Player;
    };
end;
Controller.ListAchievements = Controller.List;
Controller.GetAchievements = Controller.List;

-- |: Info
-- |~ GetInfo, AchievementInfo, GetAchievementInfo
-- |< string AchievementName
-- |> table {
--      Name = string AchievementTrueName,
--      MaxSteps = int MaxSteps
--      Description = string Description,
--      Image = int AssetId,
--      Reward = int PointsReward
--    } AchievementInfo
Controller.Info = function(...)
	local AchievementName = extract(...);
	assert(
		type(AchievementName) == 'string',
		"[Error][Valkyrie Achievements] (in Info): You need to supply a string as #1",
		2
	);
	return RemoteCommunication.Achievement:GetAchievementInfo{
	    Name = AchievementName;
	};
end;
Controller.GetInfo = Controller.Info;
Controller.AchievementInfo = Controller.Info;
Controller.GetAchievementInfo = Controller.GetAchievementInfo;

local _controller = newproxy(true);
local mt = getmetatable(_controller);
mt.__index = Controller;
mt.__metatable = "Locked metatable: Valkyrie";
mt.__tostring = function()
	return "Valkyrie Achievements controller";
end;

extract = function(...)
	if ... == _controller then
		return select(2,...);
	else
		return ...
	end;
end;

return _controller;
