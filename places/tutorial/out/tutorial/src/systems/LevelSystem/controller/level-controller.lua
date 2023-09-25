-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
-- LevelSystemController.ts
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local segmentHandlers = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "LevelSystem", "segment-handlers")
local params = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "LevelSystem", "parameters-dev").params
-- Enabling Reflection to get the handlers from the segment-handlers.ts file
local playerLocationEvent = Remotes.Client:Get("PlayerLocationEvent")
local LevelSystemController
do
	LevelSystemController = setmetatable({}, {
		__tostring = function()
			return "LevelSystemController"
		end,
	})
	LevelSystemController.__index = LevelSystemController
	function LevelSystemController.new(...)
		local self = setmetatable({}, LevelSystemController)
		return self:constructor(...) or self
	end
	function LevelSystemController:constructor()
	end
	function LevelSystemController:onInit()
	end
	function LevelSystemController:onStart()
		print("LevelSystem Controller started")
		-- Print the params
		print(params)
		-- is client-sided, so EACH client has their own unique events...
		playerLocationEvent:Connect(function(player, location, segmentModel)
			print(player.Name .. (" is in " .. location))
			self:handleSegmentChange(location, segmentModel)
		end)
	end
	LevelSystemController.handleSegmentChange = TS.async(function(self, segment, segmentModel)
		if params[segment] then
			local segmentParams = params[segment]
			-- Handle sequential events first
			for _, handler in ipairs(segmentParams.sequential) do
				TS.await(handler(segmentModel))
			end
			-- Once sequential events are done, execute the remaining handlers simultaneously
			local _fn = TS.Promise
			local _concurrent = segmentParams.concurrent
			local _arg0 = function(handler)
				return handler(segmentModel)
			end
			-- ▼ ReadonlyArray.map ▼
			local _newValue = table.create(#_concurrent)
			for _k, _v in ipairs(_concurrent) do
				_newValue[_k] = _arg0(_v, _k - 1, _concurrent)
			end
			-- ▲ ReadonlyArray.map ▲
			TS.await(_fn.all(_newValue))
		else
			print("No parameter found for segment " .. segment)
		end
	end)
end
-- (Flamework) LevelSystemController metadata
Reflect.defineMetadata(LevelSystemController, "identifier", "tutorial/src/systems/LevelSystem/controller/level-controller@LevelSystemController")
Reflect.defineMetadata(LevelSystemController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(LevelSystemController, "$:flamework@Controller", Controller, {})
return {
	default = LevelSystemController,
}
