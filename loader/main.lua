local loader = {}

local _mt = {
	__index = function(self, key)
		if key == "load" then
			return function(s, module)
				if type(module) ~= "table" then
					error("uikit_loader:load(module) - module should be a table", 2)
				end
				if module.Name == nil then
					error("uikit_loader:load(module) - module must have .Name", 2)
				end
				if module.Create == nil then
					error("uikit_loader:load(module) - module must have .Create", 2)
				end
				if s["create"..module.Name] ~= nil then
					error("uikit_loader:load(module) - '".. module.Name .."' is already loaded", 2)
				end

				s["create"..module.Name] = module.Create
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