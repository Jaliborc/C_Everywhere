# C_Everywhere :stars:
[![Patreon](http://img.shields.io/badge/news%20&%20rewards-patreon-ff4d42)](https://www.patreon.com/jaliborc)
[![Paypal](http://img.shields.io/badge/donate-paypal-1d3fe5)](https://www.paypal.me/jaliborc)
[![Discord](http://img.shields.io/badge/discuss-discord-5865F2)](https://bit.ly/discord-jaliborc)

A JIT library that simplifies developing World of Wacraft addons which support multiple client versions. Code for latest expansion, run everywhere.

### Overview
Since Blizzard started refactoring the game's API, but only on it's retail servers, supporting the multiple clients often results in a choice between duplicated or unneficient code (so much spaghetti :spaghetti:!), even when using version-dependent code compilers.

Here is an implementation for printing link and quantity of the first 3 tracked currencies, running on both Dragonflight and Wrath of the Lich King:

```lua
for i = 0, 3 do
    local id, quantity
    if LE_EXPANSION_LEVEL_CURRENT >= LE_EXPANSION_DRAGONFLIGHT then
        local data = C_CurrencyInfo.GetBackpackCurrencyInfo(i)
        if data then
            id = data.currencyTypesID
            quantity = data.quantity
        end
    else
        local _, count, _, typeID = GetBackpackCurrencyInfo(i)
        id, quantity = typeID, count
    end

    local link = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyLink and C_CurrencyInfo.GetCurrencyLink(id) or GetCurrencyLink(id)
    print(link, quantity)
end
```

C_Everywhere takes all that clutter away while ensuring efficient implementation:

```lua
local C = LibStub('C_Everywhere')

for i = 0, 3 do
    local data = C.CurrencyInfo.GetBackpackCurrencyInfo(i)
    if data then
        print(C.CurrencyInfo.GetCurrencyLink(data.currencyTypesID), data.quantity)
    end
end
```

It does so by lazily just-in-time building namespaces and compiling lua functions optimized for the current client.

### Details
C_Everywhere handles the most common refactorings:

- API moving namespaces.
- Change of output from a variable list to a single structured (table) variable.

:warning: It cannot implement APIs that don't have a direct equivalent in the current client. It also does not handle modifications to input arguments.  
:bulb: If I missed implementing output packing for one function you require, please submit a pull request. It only takes a single line of code to implement. Here' is `GetBackpackCurrencyInfo` implementation:

```lua
pack(C.CurrencyInfo, 'GetBackpackCurrencyInfo', 'name, quantity, iconFileID, currencyTypesID')
```

### Reminder!
If you use this library, please list it as one of your dependencies in the CurseForge admin system. It's a big help! :+1: