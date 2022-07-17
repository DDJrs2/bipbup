local discordia = require('discordia');
local client = discordia.Client();
local color = discordia.Color();
local jsonIO = require("./jsonIO");
discordia.extensions();

if not args[2] then
    print("Please specify a token!");
    os.exit();
end

local prefix = ".";
local commands = {
    [prefix .. "addRole"] = {
        description = "Creates a custom role for you!\n    -*Syntax:* `addRole [Name] [HexValue]`",
        exec = function (message, args)
            if (args[2] == nil or args[3] == nil) or args[3]:find("#") == nil then
                message:reply("There was an error with your syntax!");
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
                        message:reply("You already asked for a role before! Replacing it for the new role...");
                        oldRole:delete();
                        break;
                    end
                end
            end

            local role = message.guild:createRole(args[2]);
            client:waitFor("roleCreate", 4000);
            role:setColor(color.fromHex(args[3]));

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
            message:reply("Done," .. message.author.name .. "!");
        end
    },
}

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
        local output = {};
        for word, tbl in pairs(commands) do
            table.insert(output, "`" .. word .. "`\n    -" .. tbl.description);
        end
        message:reply(table.concat(output, "\n"));
    end
end)

client:run("Bot " .. args[2])
