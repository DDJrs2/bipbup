if not args[2] then
    print("Please specify a token!");
    os.exit();
end

local discordia = require('discordia');
local client = discordia.Client();
local handler = require("./commandsHandler");
local prefix = ".";
local prefixLenght = prefix:len();
discordia.extensions();

local function help(message)
    local output = {};
    for word, tbl in pairs(handler["commands"]) do
        table.insert(output, "`" .. word .. "`\n    -" .. tbl.description);
    end
    table.sort(output);
    message:reply(table.concat(output, "\n"));
end

client:on('ready', function ()
    p(string.format('Logged in as %s', client.user.username));
end)

client:on("messageCreate", function (message)
    if message.author.bot then return end

    if message.content:sub(1, prefixLenght) == prefix then
        handler.execute(message, message.content:sub(prefixLenght+1, -1):split(" "), client);
    elseif message.content == "<@" .. client.user.id .. ">" then
        help(message);
    end
end)

client:run("Bot " .. args[2])
