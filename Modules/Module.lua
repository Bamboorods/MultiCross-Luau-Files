local module = {}

function module1.greet(name)
    return "Hello, " .. name .. "!"
end

function module1.add(a, b)
    return a + b
end

return module1
