--<<Epic Phantom Assassin Combo | Version: 1.2>> 
--[[ 
    ---------------------------------------------- 
    | Phantom Assassin Combo Script by edwynxero | 
    ---------------------------------------------- 
    ================= Version 1.2 ================ 

    Description: 
    ------------ 
        Phantom Assassin Ultimate Combo 
            - Stifling Dagger 
            - Phantom Strike 
            - Abbysal Blade (work in progress) 
        Features 
            - Excludes Illusions 
            - One Key Combo Initiator (keep key pressed to continue combo) 
]]-- 

--LIBRARIES 
require("libs.ScriptConfig") 
require("libs.TargetFind") 
require("libs.Utils") 

--CONFIGURATION 
config = ScriptConfig.new() 
config:SetParameter("ComboKey", "R", config.TYPE_HOTKEY) 
config:SetParameter("TargetLeastHP", false) 
config:Load() 

--SETTINGS 
local comboKey         = config.ComboKey 
local getLeastHP     = config.TargetLeastHP 
local registered    = false 
local range         = 1000 

--CODE 
local target        = nil 
local active        = false 

--[[Loading Script...]] 
function onLoad() 
    if PlayingGame() then 
        local me = entityList:GetMyHero() 
        if not me or me.classId ~= CDOTA_Unit_Hero_PhantomAssassin then 
            script:Disable() 
        else 
            registered = true 
            script:RegisterEvent(EVENT_TICK,Main) 
            script:RegisterEvent(EVENT_KEY,Key) 
            script:UnregisterEvent(onLoad) 
        end 
    end 
end 

--check if comboKey is pressed 
function Key(msg,code) 
    if client.chat or client.console or client.loading then return end 
    if code == comboKey then 
        active = (msg == KEY_DOWN) 
        return true 
    end 
end 

function Main(tick) 
    if not SleepCheck() then return end 

    local me = entityList:GetMyHero() 
    if not me then return end 
     
    -- Get hero abilities -- 
    local StiflingDagger = me:GetAbility(1) 
    local PhantomStrike = me:GetAbility(2) 

    if active then 
        if not inCombo then  
            if getLeastHP then 
                target = targetFind:GetLowestEHP(range,"phys") 
            else 
                FindTarget() 
            end 
        end 
     
        -- Do the combo! -- 
        if target then 
            if target.alive and target.visible and target:GetDistance2D(me) < range then 
                inCombo = true 
                me:SafeCastAbility(StiflingDagger,target) 
                me:SafeCastAbility(PhantomStrike,target) 
                me:Attack(target) 
                Sleep(200) 
                return 
            else 
                inCombo = false 
            end 
        end 
    end 
end 

function FindTarget() 
    -- Get visible enemies -- 
    local me = entityList:GetMyHero() 
    local enemies = entityList:FindEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam(),alive=true,visible=true,illusion=false}) 
    local closest = nil 
     
    for i,v in ipairs(enemies) do 
        distance = GetDistance2D(v,me) 
        if distance <= range then  
            if closest == nil then 
                closest = v 
            elseif distance < GetDistance2D(closest,me) then 
                closest = v 
            end 
        end 
    end 
    target = closest 
end 

function onClose() 
    collectgarbage("collect") 
    if registered then 
        script:UnregisterEvent(Main) 
        script:UnregisterEvent(Key) 
        script:RegisterEvent(EVENT_TICK,onLoad) 
        registered = false 
    end 
end 

script:RegisterEvent(EVENT_CLOSE,onClose) 
script:RegisterEvent(EVENT_TICK,onLoad)  
