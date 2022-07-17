local discordia = require('discordia');
local client = discordia.Client();
local color = discordia.Color();
local jsonIO = require("./jsonIO");
local prefix = ".";
discordia.extensions();

if not args[2] then
    print("Please specify a token!");
    os.exit();
end

local function getName(str)
    for i = 1, str:len() do
        if str:sub(i,i) == '"' then
           for j = i+1, str:len() do
                if str:sub(j,j) == '"' then
                    return str:sub(i+1, j-1);
                end
           end
        end
    end
end

local function isHex(x)
    return string.byte(x) <= string.byte('f') and string.byte(x) >= string.byte('0');
end

local function getHex(str)
    local hexQtd = 0;
    for i = 1, str:len() do
        if str:sub(i,i) == '#' then
            for j = i+1, str:len() do
                local letter = str:sub(j,j);
                if letter == ' ' or hexQtd == 6 or not isHex(letter:lower()) then
                    break;
                elseif isHex(letter:lower()) and letter ~= nil then
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
    if quotationQuantity == 2 then
        return true;
    else
        return false;
    end
end

local commands = {
    [prefix .. "addRole"] = {
        description = "Creates a custom role for you! If you already asked for one, then your role will be replaced by the new one!\n    -*Syntax.* `addRole \"[Name]\" #[HexValue]` e.g: `.addRole \"Average Lua enjoyer, なのら！\" #ff80fd`",
        exec = function (message, args)
            local name = '';
            local hex = '';
            local argument = table.concat(args, ' ', 2);
            if checkSyntax(argument) then
                name = getName(argument);
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
            message:reply("Done, " .. message.author.name .. "!");
        end
    },
}

local function help(message)
    local output = {};
    for word, tbl in pairs(commands) do
        table.insert(output, "`" .. word .. "`\n    -" .. tbl.description);
    end
    message:reply(table.concat(output, "\n"));
end

client:on('ready', function ()
    p(string.format('Logged in as %s', client.user.username))
end)

client:on("messageCreate", function (message)
    if message.author.bot or not message.guild then return end
    local args = message.content:split(" ");

    local command = commands[args[1]];
    if command then
        command.exec(message, args);
    elseif args[1] == prefix.."help" then
        help(message);
    end
end)

client:run("Bot " .. args[2])
