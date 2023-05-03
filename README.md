# C_Everywhere :stars:
[![Patreon](http://img.shields.io/badge/news%20&%20rewards-patreon-ff4d42)](https://www.patreon.com/jaliborc)
[![Paypal](http://img.shields.io/badge/donate-paypal-1d3fe5)](https://www.paypal.me/jaliborc)
[![Discord](http://img.shields.io/badge/discuss-discord-5865F2)](https://bit.ly/discord-jaliborc)

A JIT library that simplifies developing World of Wacraft addons which support multiple client versions. Code for latest expansion, run everywhere.

## Overview
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
## Advanced
As shown, when a namesapce `C.Some_Namespace` is requested, C_Everywhere returns a virtual namespace that abstracts the process of finding and optimizing APIs. These virtual namespaces also provide some extra functions:

 Function | Description | Input | Return
 -------- | ----------- | ----- | ------- 
.rawfind(api) | Forces a search for the requested API, without using any of the other features or optimizations. | string | function
.locate(api) | Returns the real namespace in which the API can be found. | string | table
.hooksecurefunc(api, call) | Shorthand, equivalent to `hooksecurefunc(.locate(api), api, call)` | string, function | nil

:bulb: If I missed implementing output packing into structured code for a function you require, please submit a pull request. It only takes a single line of code to implement in the source code. Here is `GetBackpackCurrencyInfo` implementation:

```lua
pack(C.CurrencyInfo, 'GetBackpackCurrencyInfo', 'name, quantity, iconFileID, currencyTypesID')
```

## Limitations 
**C_Everywhere** is not a virtual machine. It only handles three forms of refactoring:
- API moving namespaces.
- API moving from frame type to a namespace.
- Change of output from a variable list to a single structured (table) variable.  

It cannot implement APIs that don't have a direct equivalent in the current client. It also does not handle discrepancies to input arguments.  

## :warning: Reminder!
If you use this library, please list it as one of your dependencies in the CurseForge admin system. It's a big help! :+1: