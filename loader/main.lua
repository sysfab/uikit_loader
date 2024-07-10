local loader = {}

local _mt = {
	__index = function(self, key)
		if key == "load" then
			return function(s, module)
				
			end
		end

		if self.ui[key] ~= nil then
			return self.ui[key]
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

	l.ui = ui
	if l.ui == nil then
		l.ui = require("uikit")
	end

	return l
end

setmetatable(loader, {__call = function(self, ...) self.load(...) end})

return loader