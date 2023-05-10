require 'ffxi.weather'
require 'common'

_addon.author   = 'Almavivaconte';
_addon.name     = 'Weathervane';
_addon.version  = '0.0.1';

local partymessage = true;
local playsound = true;

weather_table = {
    [0] = "WEATHER_NONE",
    [1] = "WEATHER_SUNSHINE",
    [2] = "WEATHER_CLOUDS",
    [3] = "WEATHER_FOG",
    [4] = "WEATHER_HOT_SPELL",
    [5] = "WEATHER_HEAT_WAVE",
    [6] = "WEATHER_RAIN",
    [7] = "WEATHER_SQUALL",
    [8] = "WEATHER_DUST_STORM",
    [9] = "WEATHER_SAND_STORM",
    [10] = "WEATHER_WIND",
    [11] = "WEATHER_GALES",
    [12] = "WEATHER_SNOW",
    [13] = "WEATHER_BLIZZARDS",
    [14] = "WEATHER_THUNDER",
    [15] = "WEATHER_THUNDERSTORMS",
    [16] = "WEATHER_AURORAS",
    [17] = "WEATHER_STELLAR_GLARE",
    [18] = "WEATHER_GLOOM",
    [19] = "WEATHER_DARKNESS"
}

function weatherupdate()
    local currWeather = tonumber(ashita.ffxi.weather.get_weather());
    print("\30\201[\30\82Weathervane\30\201]\31\255 Current weather: "  .. weather_table[currWeather])
    local fullpath = string.format('%s\\sounds\\weatherupdate.wav', _addon.path);
    if playsound then
        ashita.misc.play_sound(fullpath);
    end
    if partymessage then
        ashita.timer.once(2, party_message, currWeather)
    end
end;

function party_message(currWeather)
    AshitaCore:GetChatManager():QueueCommand("/p Weather update: " .. weather_table[currWeather], 0)
end;

ashita.register_event('incoming_packet', function(id, size, data, modified, blocked)
    if (id == 0x057) then
        ashita.timer.once(2, weatherupdate, playsound)
    end
    return false;
end);

ashita.register_event('command', function(command, ntype)
    local args = command:args();
    if args[1] == '/weather' then
        if args[2] == 'party' then
            if partymessage then
                print("\30\201[\30\82Weathervane\30\201]\31\255 Will not send party messages on weather updates.")
            else
                print("\30\201[\30\82Weathervane\30\201]\31\255 Will send party messages on weather updates.")
            end
            partymessage = not partymessage
        elseif args[2] == 'sound' then
            if playsound then
                print("\30\201[\30\82Weathervane\30\201]\31\255 Will not play sound on weather updates.")
            else
                print("\30\201[\30\82Weathervane\30\201]\31\255 Will play sound on weather updates.")
            end
            playsound = not playsound
        else
            weatherupdate()
        end
    end
    return false;
end);

ashita.register_event('load', function()
    print("\30\201[\30\82Weathervane\30\201]\31\255 Prints a message, optionally sends a party chat message, and plays a sound on weather changes.")
    print("\30\201[\30\82Weathervane\30\201]\31\255 Type /weather to print the current weather.")
    print("\30\201[\30\82Weathervane\30\201]\31\255 Type /weather party to enable or disable party messages on weather changes.")
    print("\30\201[\30\82Weathervane\30\201]\31\255 Type /weather sound to enable or disable sound on weather changes.")
end);