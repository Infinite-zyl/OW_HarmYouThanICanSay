settings {
    "main": {
        "description": "代码：2N28M\n规则同桌游：害你在心口难开\n创意&词条借鉴：傲娇青冥君#5952\n二次开发：来一瓶可乐#51797\n源码参见：https://github.com/Infinite-zyl/OW_HarmYouThanICanSay",
        "modeName": "不要做挑战【团队死斗】 v1.0.0"
    },
    "lobby": {
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "spectatorSlots": 12,
        "returnToLobby": "afterGame",
        "allowPlayersInQueue": true,
        "useExperimentalUpdate": true
    },
    "gamemodes": {
        "clash": {
            "enabled": false,
            "captureSpeed%": 45
        },
        "ffa": {
            "disabledMaps": [
                "workshopChamber",
                "workshopIsland",
                "workshopIslandNight",
                "workshopExpanse",
                "workshopExpanseNight",
                "workshopGreenScreen"
            ],
            "enableSelfInitiatedRespawn": false,
            "scoreToWin": 40
        },
        "general": {
            "respawnTime%": 0,
            "spawnHealthPacks": "enabled",
            "healthPackRespawnTime%": 50,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off"
        }
    },
    "heroes": {
        "allTeams": {
            "general": {
                "health%": 200
            }
        }
    }
}