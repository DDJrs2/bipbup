# bipbup

A lua-based Discord bot that adds and gives roles throught messages with **[Discordia](https://github.com/SinisterRectus/Discordia)** API.

## How to use

After you clone this repository, follow **[Discordia](https://github.com/SinisterRectus/Discordia)**'s installation guide inside the repository's folder. To start the bot, just execute `luvit main.lua [TOKEN]` in the terminal or command prompt while inside the folder, where `[TOKEN]` is your bot's token that you get after creating a discord application online.

## Commands

Commands should be followed by the default prefix ".", or you own if you customized it.

- `addRole` to give the message's author a custom role with a color. e.g. `.addRole "Average Lua enjoyer" #ff80fd`
- `question` to answer a yes or no question with something random, made for lol porpuses. e.g. `.question is air safe to breathe?`
- `@YourBotName` to send the list of available commands