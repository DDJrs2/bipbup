local ORIGIN = "./data/";
local json = require("json");

local M = {}

function M.writeJson(fileName, content)
    local file = io.open(ORIGIN .. fileName, "w");
    if not file then error("Cannot write json") end
    file:write(json.encode(content));
    file:close();
end

function M.readJson(fileName)
    local file = io.open(ORIGIN .. fileName, "r");
    if not file then
        io.open(ORIGIN .. fileName, "w");
        file = io.open(ORIGIN .. fileName, "r");
    end
    local fileContent = file:read("a");
    file:close();
    return json.decode(fileContent);
end

return M;