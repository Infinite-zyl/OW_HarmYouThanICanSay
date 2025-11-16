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
        "按住前进键持续5秒",
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
        "攻击距离自身25m以外的敌人",
        "攻击距离自身3m以内的敌人",
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
        "造成一次大于100点的伤害",
        "造成一次地形杀",
        "累计造成500点伤害",
        "造成击杀",
        "30S内不造成伤害",
    ]

    # 移动/位置类
    words_movement = [
        "持续移动10秒钟",
        "在空中待一秒钟",
        "5秒内不移动",
        "移速过快",
        "距离地面6m以上",
        "靠近一名敌人"
    ]

    # 生存/治疗类
    words_survival = [
        "吃血包",
        "自己治疗自己",
        "存活100秒"
    ]

    # 观察/互动类
    words_interaction = [
        "凝视敌人超过五秒",
        "头像框火力全开"
    ]

    all_words = words_action.concat(words_attack).concat(words_movement).concat(words_survival).concat(words_interaction)


rule "初始化玩家词条":
    @Event eachPlayer
    @Condition isGameInProgress()

    eventPlayer.player_last_word = ""
    eventPlayer.player_word = random.choice(all_words)
