
if not myhero then
			myhero = Hero(me)


Sleep(client.latency/1000+myhero.attackRate*1000, "move")
if SleepCheck("move") then
me:Move(client.mousePosition)


me.attackBaseTime / (1 + (me.attackSpeed - 100) / 100)

https://github.com/Moones/WIP/blob/a9b04a6e3a5d8425b167fb3189621eb9436def52/Scripts/TA_beta.lua
