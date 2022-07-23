local color = require("discordia").Color();
local jsonIO = require("../jsonIO");

local emoticons = {
    "❤️",
    "💜",
    "💙",
    "🖤",
    "🤎",
    "🤍",
    "💚",
    "💛",
    "🧡",
}

local function isHex(x)
    return string.byte(x) <= string.byte('f') and string.byte(x) >= string.byte('0');
end

local function getHex(str)
    local hexQtd = 0;
    for i = 1, str:len() do
        if str:sub(i,i) == '#' then
            for j = i+1, str:len() do
                local letter = str:sub(j,j):lower();
                if letter == ' ' or hexQtd == 6 or not isHex(letter) then
                    break;
                elseif isHex(letter) and letter ~= nil then
                    hexQtd = hexQtd + 1;
                end
            end
        end
        if hexQtd == 6 then
            return str:sub(i, i+6);
        else
            hexQtd = 0;
        end
    end
end

local function checkSyntax(arguments)
    local quotationQuantity = 0;
    for i = 1, arguments:len() do
        if arguments:sub(i,i) == '"' then
            quotationQuantity = quotationQuantity + 1;
        end
    end
    return quotationQuantity == 2;
end

local function deleteOldRole(message, userInfo, client)
    for index, value in ipairs(userInfo) do
        if message.author.name == value.name then
            local oldRole = client:getRole(value.roleID);
            if oldRole == nil then
                return;
            end
            oldRole:delete();
            return;
        end
    end
end

return function (message, args, client)
    if not message.guild then
        message:reply("You aren't in a server,,,,,");
        return;
    end

    local name = '';
    local hex = '';
    local argument = table.concat(args, ' ', 2);
    if checkSyntax(argument) then
        local i, j = argument:find("([\"'])(.-)%1");
        name = argument:sub(i+1, j-1);
        hex = getHex(argument);
        if hex == nil then
            message:reply("The hex syntax is wrong!");
            return;
        end
    else
        message:reply("The name syntax is wrong!");
        return;
    end

    local userInfo = jsonIO.readJson(message.guild.name .. ".json");
    if userInfo ~= nil then
        deleteOldRole(message, userInfo, client);
    end

    local role, err = message.guild:createRole(name);
    if not role then
        print(err);
        message:reply("A weird error occurred, please try again! ~~No, it's not my fault.~~");
        return;
    end
    role:setColor(color.fromHex(hex));
    message.member:addRole(role.id);

    --userInfo = jsonIO.readJson(message.guild.name .. ".json");
    jsonIO.writeJson(message.guild.name .. ".json", {});
    if userInfo == nil then
        userInfo = {};
        table.insert(userInfo, {
            ["name"] = message.author.name,
            ["roleID"] = role.id,
        });
    else
        for key, value in pairs(userInfo) do
            if userInfo == nil then break end
            if value.name == message.author.name then
                table.remove(userInfo, key);
            end
        end
        table.insert(userInfo, {
            ["name"] = message.author.name,
            ["roleID"] = role.id,
        });
    end
    jsonIO.writeJson(message.guild.name .. ".json", userInfo);

    message:addReaction(emoticons[math.random(1, #emoticons)]);
end