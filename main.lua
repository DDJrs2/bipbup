if not args[2] then
    print("Please specify a token!");
    os.exit();
end

local discordia = require('discordia');
local client = discordia.Client();
local commands = require("./commands");
local prefix = ".";
discordia.extensions();

local function help(message)
    local output = {};
    for word, tbl in pairs(commands) do
        table.insert(output, "`" .. word .. "`\n    -" .. tbl.description);
    end
    table.sort(output);
    message:reply(table.concat(output, "\n"));
end

client:on('ready', function ()
    p(string.format('Logged in as %s', client.user.username));
end)

client:on("messageCreate", function (message)
    if message.author.bot or not message.guild then return end

    local args = message.content:sub(prefix:len()+1, -1):split(" ");
    local command = commands[args[1]];
    if command then
        command.exec(message, args, client);
    elseif args[1] == "help" then
        help(message);
    end
end)

client:run("Bot " .. args[2])
