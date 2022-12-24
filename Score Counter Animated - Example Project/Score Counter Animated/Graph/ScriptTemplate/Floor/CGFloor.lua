local CGFloor = CGFloor or {}
CGFloor.__index = CGFloor

function CGFloor.new()
    local self = setmetatable({}, CGFloor)
    self.inputs = {}
    return self
end

function CGFloor:setInput(index, func)
    self.inputs[index] = func
end

function CGFloor:getOutput(index)
    return math.floor(self.inputs[0]())
end

return CGFloor
