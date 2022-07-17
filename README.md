# bipbup

A lua-based Discord bot that adds roles throught messages with **[Discordia](https://github.com/SinisterRectus/Discordia)** API.

## How to use

Follow **[Discordia](https://github.com/SinisterRectus/Discordia)** installation guide. To start the bot, just execute `luvit main.lua [TOKEN]`, where `[TOKEN]` is your bot's token that you get after creating a discord application online.

## Syntax

Simply say `.addRole "[yourRoleName]" #[HexValue]` in any text channel. The prefix variable can be changed inside main.lua.
Example: `.addRole "Average Lua enjoyer" #00ff00`