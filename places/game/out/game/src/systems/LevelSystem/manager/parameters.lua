-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local handlers = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "LevelSystem", "segment-handlers").handlers
local slice = function(arr, start, endPos)
	local result = {}
	do
		local i = start
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < endPos) then
				break
			end
			local _arg0 = arr[i + 1]
			table.insert(result, _arg0)
		end
	end
	return result
end
local randomizeHandlers = function(handlers)
	local currentIndex = #handlers
	local randomIndex
	while currentIndex ~= 0 do
		randomIndex = math.floor(math.random() * currentIndex)
		currentIndex -= 1
		local _binding = { handlers[randomIndex + 1], handlers[currentIndex + 1] }
		handlers[currentIndex + 1] = _binding[1]
		handlers[randomIndex + 1] = _binding[2]
	end
	return handlers
end
local params = {}
for _, segment in ipairs({ "LevelSegment1", "LevelSegment2" }) do
	local _array = {}
	local _length = #_array
	table.move(handlers, 1, #handlers, _length + 1, _array)
	local randomizedHandlers = randomizeHandlers(_array)
	local halfWayThrough = math.floor(#randomizedHandlers / 2)
	params[segment] = {
		sequential = slice(randomizedHandlers, 0, halfWayThrough),
		concurrent = slice(randomizedHandlers, halfWayThrough, #randomizedHandlers),
	}
end
return {
	params = params,
}
