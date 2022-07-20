# bipbup

A lua-based Discord bot that adds and gives roles throught messages with **[Discordia](https://github.com/SinisterRectus/Discordia)** API.

## How to use

After you clone this repository, follow **[Discordia](https://github.com/SinisterRectus/Discordia)**'s installation guide inside the repository's folder. To start the bot, just execute `luvit main.lua [TOKEN]` in the console or cmd while inside the folder, where `[TOKEN]` is your bot's token that you get after creating a discord application online.

## Syntax

Simply say `.addRole "[yourRoleName]" #[HexValue]` in any text channel. The prefix variable can be changed inside main.lua.

Usage Examples:

`.addRole "Average Lua enjoyer" #00ff00`

`.addRole #ff80fd "ルア語"`