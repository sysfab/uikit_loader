local loader = {}

local loadModule = function(s, module)
	if type(module) ~= "table" then
		error("uikit_loader:load(module) - module should be a table", 3)
	end
	if module.Name == nil then
		error("uikit_loader:load(module) - module must have .Name", 3)
	end
	if module.Create == nil then
		error("uikit_loader:load(module) - module must have .Create", 3)
	end
	if module.Requirements == nil then
		module.Requirements = {}
	end
	if s["create"..module.Name] ~= nil then
		error("uikit_loader:load(module) - '".. module.Name .."' is already loaded", 3)
	end

	for i, requirementName in ipairs(module.Requirements) do
		if s["create"..requirementName] == nil then
			error("uikit_loader:load(module) - To load '".. module.Name .."' you need to load '".. requirementName .."' first.", 3)
		end
	end

	s["create"..module.Name] = module.Create
end

local _mt = {
	__index = function(self, key)
		if key == "load" then
			return function(s, modules)
				if #modules == 0 then 
					loadModule(s, modules)
				else
					for i, module in ipairs(modules) do
						loadModule(s, module)
					end
				end
			end
		end

		if string.sub(key, 1, #"create") == "create" then
			if self.values.ui[key] ~= nil then
				return function(s, ...)
					return self.values.ui[key](self.values.ui, ...)
				end
			elseif self.values[key] ~= nil then
				return function(s, ...)
					return self.values[key](self.values.ui, ...)
				end
			end
		end

		if self.values.ui[key] ~= nil then
			return self.values.ui[key]
		else
			return self.values[key]
		end
	end,
	__newindex = function(self, key, value)
		if key == "ui" then return end
		self.values[key] = value
	end
}

loader.load = function(ui)
	local l = {}
	l.values = {}

	l.values.ui = ui
	if l.values.ui == nil then
		l.values.ui = require("uikit")
	end

	setmetatable(l, _mt)
	return l
end

setmetatable(loader, {__call = function(self, ui) return self.load(ui) end})

return loader