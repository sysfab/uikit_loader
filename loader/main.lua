local loader = {}

local _mt = {
	__index = function(self, key)
		if key == "load" then
			return function(s, module)
				if s["create"..module.Name] ~= nil then
					error("uikit_loader:load(module) - '".. module.Name .."' is already loaded", 2)
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