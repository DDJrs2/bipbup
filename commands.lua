local color = require("discordia").Color();
local jsonIO = require("./jsonIO");

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

local answer = {
	"Of course!",
	"That's a strong yes!",
	"Indeed!",
	"Hell yeah!",
	"Hmmmm... I guess?",
	"I don't think so.",
	"Well, yes, but no.",
	"I think that perhaps it's a maybe!",
	"Haha no.",
	"I think it's better not to answer.",
	"No that's cringe!",
	"You just invented these words.",
}

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

return {
    ["addRole"] = {
        description = "Creates a custom role for you! If you already asked for one, then your role will be replaced by the new one!\n    "..
            "-*Syntax:* `addRole \"[Name]\" #[HexValue]` e.g: `.addRole \"Average Lua enjoyer, なのら！\" #ff80fd`",
        exec = function (message, args, client)
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
                for index, value in ipairs(userInfo) do
                    if message.author.name == value.name then
                        local oldRole = client:getRole(value.roleID);
                        if oldRole == nil then
                            break;
                        end
                        oldRole:delete();
                        break;
                    end
                end
            end

            local role, err = message.guild:createRole(name);
            if not role then
                print(err);
                message:reply("A weird error occurred, please try again! ~~No, it's not my fault.~~");
                return;
            end
            role:setColor(color.fromHex(hex));

            userInfo = jsonIO.readJson(message.guild.name .. ".json");
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

            message.member:addRole(role.id);
            message:addReaction(emoticons[math.random(1, #emoticons)]);
        end
    },
    ["question"] = {
        description = "I'll answer you a yes or no question!\n    "..
        "*Syntax:* `question [bla bla bla]`",
        exec = function (message, args)
            if args[2] == nil then
                message.channel:send("Ask me anything and I'll answer with yes or no!");
                message:addReaction("😭");
                return;
            end
            message:reply("> " ..  	table.concat(args, " ", 2) .. "\n" .. answer[math.random(1, #answer)]);
            message:addReaction("🤔");
        end
    }
}