local CGMod = CGMod or {}
CGMod.__index = CGMod

function CGMod.new()
    local self = setmetatable({}, CGMod)
    self.inputs = {}
    return self
end

function CGMod:setInput(index, func)
    self.inputs[index] = func
end

function CGMod:getOutput(index)
    return self.inputs[0]() % self.inputs[1]()
end

return CGMod
