-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local MarketplaceService = _services.MarketplaceService
local DataStoreService = _services.DataStoreService
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
-- Define the ProcessReceiptInfo interface
local getLeaderboardDataFunc = Remotes.Server:Get("GetDonationData")
local DonationSystemService
do
	DonationSystemService = setmetatable({}, {
		__tostring = function()
			return "DonationSystemService"
		end,
	})
	DonationSystemService.__index = DonationSystemService
	function DonationSystemService.new(...)
		local self = setmetatable({}, DonationSystemService)
		return self:constructor(...) or self
	end
	function DonationSystemService:constructor(profileService)
		self.profileService = profileService
		self.donationLeaderboard = DataStoreService:GetOrderedDataStore("DonationLeaderboard")
		self.productHandlers = {
			[1585639493] = function(receipt, player)
				local profile = self.profileService:getProfile(player)
				if profile then
					-- Add 100 to donation value in profile
					profile.Data.donation += 100
					print(player.Name .. (" has donated a total of ₹" .. tostring(profile.Data.donation)))
					-- Update the OrderedDataStore with the new donation amount
					self.donationLeaderboard:SetAsync(tostring(player.UserId), profile.Data.donation)
				end
			end,
		}
	end
	function DonationSystemService:onInit()
		print("DonationSystem Service initialized")
		MarketplaceService.ProcessReceipt = function(receipt)
			return self:processReceipt(receipt)
		end
	end
	function DonationSystemService:onStart()
		print("DonationSystem Service Started")
		getLeaderboardDataFunc:SetCallback(TS.async(function(player)
			-- Add print statement for debugging
			print("Fetching leaderboard data...")
			local topDonators = {}
			local dataPages = self.donationLeaderboard:GetSortedAsync(false, 10)
			-- Get first page
			local data = dataPages:GetCurrentPage()
			do
				local i = 0
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < #data and i < 10) then
						break
					end
					local donationData = data[i + 1]
					local userId = tonumber(donationData.key)
					-- Ensure userId is not undefined before passing to GetNameFromUserIdAsync
					if userId == nil then
						warn("Unable to convert " .. (donationData.key .. " to a number"))
						continue
					end
					local _arg0 = {
						name = TS.await(Players:GetNameFromUserIdAsync(userId)),
						donation = donationData.value,
					}
					table.insert(topDonators, _arg0)
				end
			end
			-- Add print statement for debugging
			print("Fetched leaderboard data")
			-- eslint-disable-next-line roblox-ts/no-array-pairs
			for player, donation in pairs(topDonators) do
				print(tostring(player + 1) .. (". " .. (donation.name .. (" - ₹" .. tostring(donation.donation)))))
			end
			return topDonators
		end))
	end
	function DonationSystemService:processReceipt(receipt)
		local handler = self.productHandlers[receipt.ProductId]
		if handler then
			local player = Players:GetPlayerByUserId(receipt.PlayerId)
			if player then
				handler(receipt, player)
				return Enum.ProductPurchaseDecision.PurchaseGranted
			else
				warn("Player not found")
			end
		end
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
end
-- (Flamework) DonationSystemService metadata
Reflect.defineMetadata(DonationSystemService, "identifier", "lobby/src/systems/MetaSystem/LeaderboardSystem/services/donation-service@DonationSystemService")
Reflect.defineMetadata(DonationSystemService, "flamework:parameters", { "lobby/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service@ProfileSystemMechanic" })
Reflect.defineMetadata(DonationSystemService, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(DonationSystemService, "$:flamework@Service", Service, { {} })
return {
	default = DonationSystemService,
}
