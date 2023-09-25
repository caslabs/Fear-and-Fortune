-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local UpdateCurrencyEvent = Remotes.Server:Get("UpdateCurrency")
local TradeMechanicService
do
	TradeMechanicService = setmetatable({}, {
		__tostring = function()
			return "TradeMechanicService"
		end,
	})
	TradeMechanicService.__index = TradeMechanicService
	function TradeMechanicService.new(...)
		local self = setmetatable({}, TradeMechanicService)
		return self:constructor(...) or self
	end
	function TradeMechanicService:constructor(inventoryService, currencyService)
		self.inventoryService = inventoryService
		self.currencyService = currencyService
	end
	function TradeMechanicService:onStart()
		local TradeRequestEvent = Remotes.Server:Get("TradeRequest")
		TradeRequestEvent:Connect(function(player, currency, new_inventory)
			print("NEW STASH DATA 2", new_inventory)
			self:afterTrade(player, currency, new_inventory)
			print("[TRADE] Player " .. player.Name .. " requested trade SUCESS!")
		end)
		print("TradeMechanic Service started")
	end
	TradeMechanicService.afterTrade = TS.async(function(self, player, currency, new_inventory)
		print("NEW STASH DATA 3", new_inventory)
		if currency >= 0 then
			self.currencyService:addCurrency(player, currency)
			self.inventoryService:setInventory(player, new_inventory)
			print("new stash data 4.0 " .. tostring(new_inventory))
			print("[TRADE] Player gaind money from trade!")
		else
			-- if player can afford the trade, update currency
			if (TS.await(self.currencyService:getCurrency(player))) >= currency then
				self.currencyService:removeCurrency(player, currency)
				self.inventoryService:setInventory(player, new_inventory)
				print("[TRADE] Player paid for trade!")
			else
				print("[TRADE] Player cannot afford trade")
			end
		end
		print("NEW STASH DATA 5", new_inventory)
	end)
end
-- (Flamework) TradeMechanicService metadata
Reflect.defineMetadata(TradeMechanicService, "identifier", "lobby/src/mechanics/PlayerMechanics/TradeMechanic/services/trade-service@TradeMechanicService")
Reflect.defineMetadata(TradeMechanicService, "flamework:parameters", { "lobby/src/systems/InventorySystem/services/inventory-service@InventorySystemService", "lobby/src/mechanics/PlayerMechanics/CurrencyMechanic/services/currency-service@CurrencyMechanicService" })
Reflect.defineMetadata(TradeMechanicService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(TradeMechanicService, "$:flamework@Service", Service, { {
	loadOrder = 99999,
} })
return {
	TradeMechanicService = TradeMechanicService,
}
