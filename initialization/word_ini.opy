#!mainFile "../main.opy"

rule "初始化词库":

    # 动作类
    words_action = [
        "连续跳跃",
        "按下跳跃键",
        "按下蹲键",
        "按下装填键",
        "抬头",
        "低头",
        "按住前进键持续{}秒".format(WordNumber.KEEPMOVINGFORWARD),
        "按下后退键",
        "使用交流菜单里的指令",
        "按下互动键",
        "做表情",
        "打招呼",
        "发语音",
        "用光弹匣"
    ]

    # 攻击类
    words_attack = [
        "攻击距离自身{}m以外的敌人".format(WordNumber.ENEMYDISTANCEOUT),
        "攻击距离自身{}m以内的敌人".format(WordNumber.ENEMYDISTANCEIN),
        "使用主要攻击",
        "使用次要攻击",
        "使用Shift技能",
        "使用E技能",
        "使用终极技能",
        "使用快速近战攻击",
        "使用主要攻击造成伤害",
        "使用次要攻击造成伤害",
        "使用Shift造成伤害",
        "使用E技能造成伤害",
        "使用终极技能造成伤害",
        "使用快速近战造成伤害",
        "攻击一名重装角色",
        "攻击一名输出角色",
        "攻击一名辅助角色",
        "造成爆头伤害",
        "造成击退",
        "造成一次大于{}点的伤害".format(WordNumber.ONETIMEDAMAGE),
        "造成一次地形杀",
        "累计造成{}点伤害".format(WordNumber.ALLDAMAGE),
        "造成击杀",
        "{}秒内不造成伤害".format(WordNumber.DONTHURT),
        "{}秒内不使用技能".format(WordNumber.NOSKILLS),
    ]

    # 移动/位置类
    words_movement = [
        "持续移动{}秒钟".format(WordNumber.KEEPMOVING),
        "在空中待{}秒钟".format(WordNumber.INAIR),
        "{}秒内不移动".format(WordNumber.DONTMOVE),
        "移速过快",
        "距离地面{}m以上".format(WordNumber.GROUNDDISTANCE),
        "靠近一名敌人"
    ]

    # 生存/治疗类
    words_survival = [
        "吃血包",
        "自己治疗自己",
        "存活{}秒".format(WordNumber.SURVIVALTIME)
    ]

    # 观察/互动类
    words_interaction = [
        "凝视敌人超过{}秒".format(WordNumber.STAREENEMY),
        "头像框火力全开",
        "受伤超过{}秒不还手".format(WordNumber.FIGHTBACK)
    ]

    # 状态类
    words_status = [
        "被入侵",
        "燃烧",
        "被击倒",
        "被沉睡",
        "被击晕",
        "生命值少于100"
    ]

    # 角色类
    words_character = [
        "使用重装英雄",
        "使用辅助英雄",
        "使用输出英雄"
    ]

    all_words = words_action.concat(words_attack).concat(words_movement).concat(words_survival).concat(words_interaction).concat(words_status).concat(words_character)


rule "初始化玩家词条":
    @Event eachPlayer
    @Condition isGameInProgress()

    eventPlayer.player_last_word = ""
    eventPlayer.player_word = random.choice(all_words)
