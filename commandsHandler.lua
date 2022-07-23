local handler = {
    ["commands"] = {
        ["addRole"] = {
            description = "Creates a custom role for you! If you already asked for one, then your role will be replaced by the new one!\n    "..
                "-*Syntax:* `addRole \"[Name]\" #[HexValue]` e.g: `.addRole \"Average Lua enjoyer, なのら！\" #ff80fd`",
        },
        ["question"] = {
            description = "I'll answer you a yes or no question!\n    "..
            "*Syntax:* `question [bla bla bla]`",
        }
    }
}

function handler.execute(message, args, client)
    if handler["commands"][args[1]] then
        require("./commands/" .. args[1])(message, args, client);
    end
end

return handler;