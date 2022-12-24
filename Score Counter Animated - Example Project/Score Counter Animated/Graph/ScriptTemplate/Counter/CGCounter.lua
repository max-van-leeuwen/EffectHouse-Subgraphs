local CGCounter = CGCounter or {}
CGCounter.__index = CGCounter

function CGCounter.new()
    local self = setmetatable({}, CGCounter)
    self.inputs = {}
    self.outputs = {}
    self.nexts = {}
    self.value = nil
    return self
end

function CGCounter:setNext(index, func)
    self.nexts[index] = func
end

function CGCounter:setInput(index, func)
    self.inputs[index] = func
end

function CGCounter:getOutput(index)
    if self.outputs[index] then
        return self.outputs[index]
    end
    if self.inputs[2]() < self.inputs[3]() or self.inputs[2]() > self.inputs[4]() then
        return nil
    end
    return self.inputs[2]()
end

function CGCounter:execute(index)
    if self.inputs[2] == nil then
        return
    end
    -- stuck here if base value out of range
    if self.inputs[2]() < self.inputs[3]() or self.inputs[2]() > self.inputs[4]() then
        return
    end

    if index == 0 then
        if self.value == nil then
            self.value = self.inputs[2]()
        end
        self.value = self.value + 1
    end

    if index == 1 then
        if self.value == nil then
            self.value = self.inputs[2]()
        end
        self.value = self.value - 1
    end

    if self.value > self.inputs[4]() then
        self.value = self.inputs[3]()
    end
    if self.value < self.inputs[3]() then
        self.value = self.inputs[4]()
    end
     
    self.outputs[1] = self.value

    if self.nexts[0] then
        self.nexts[0]()
    end
end

return CGCounter
