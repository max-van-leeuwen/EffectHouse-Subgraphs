local CGDivide = CGDivide or {}
CGDivide.__index = CGDivide

function CGDivide.new()
    local self = setmetatable({}, CGDivide)
    self.inputs = {}
    return self
end

function CGDivide:setInput(index, func)
    self.inputs[index] = func
end

function CGDivide:getOutput(index)
    local curType = self.valueType
    if curType == nil then
        -- Amaz.LOGE("ERROR: ", "CGDivide do not have node type")
        return nil
    end
    local op1 = self.inputs[0]()
    local op2 = self.inputs[1]()
    if op1 == nil or op2 == nil then
        return nil
    end
    if op2 == 0 then
        return nil
    end
    return op1 / op2
end

return CGDivide
