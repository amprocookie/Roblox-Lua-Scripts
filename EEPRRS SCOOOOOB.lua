local module = {}
local StorageService = game:GetService("DataStoreService")
local LoginData
function module:SetDatastore(Datastore, Scope)
	LoginData = StorageService:GetDataStore(Datastore, Scope)
end
function module.Read(UUID, ShowInfo)
	if ShowInfo then warn("Request to require data was called.") end
	local Data
	local Success, Failed = pcall(function()
		Data = LoginData:GetAsync(UUID)
	end)
	if not Success then
		if ShowInfo then warn(Failed) end
	end
	if ShowInfo then warn("Returning data to src...") end
	return Success and Data or false
end
function module.Write(UUID, Value, ShowInfo)
	if ShowInfo then warn("Request to create data was called.") end
	local Success, Failed = pcall(function()
		LoginData:SetAsync(UUID, Value)
	end)
	if not Success then
		if ShowInfo then warn(Failed) end
	end
	if ShowInfo then warn("Returning bool to src...") end
	return Success
end
return module
