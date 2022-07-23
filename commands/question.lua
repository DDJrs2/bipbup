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

return function (message, args)
    if args[2] == nil then
        message.channel:send("Ask me anything and I'll answer with yes or no!");
        message:addReaction("😭");
        return;
    end
    message:reply("> " ..  	table.concat(args, " ", 2) .. "\n" .. answer[math.random(1, #answer)]);
    message:addReaction("🤔");
end