#!mainFile "../main.opy"

rule "完成条件初始化":
    @Condition isGameInProgress()
    
    disableInspector()
    disableScoring()
    # disableGamemodeCompletion()
    pauseMatchTime()
    setMatchTime(600)
    
rule "集结时间初始化":
    @Condition isAssemblingHeroes() == true
    
    setMatchTime(10)

rule "全局变量初始化":
    
    guessing_active = false # 猜词环节是否激活初始化为假
    guessing_part = GuessingPart.NONE # 猜词环节阶段初始化为无
    current_guesser = "" # 当前猜词玩家初始化为空字符串

rule "玩家变量初始化":
    @Event eachPlayer
    @Condition isGameInProgress()
    
    eventPlayer.tutorial_flag = true # 教程默认为开

    eventPlayer.setScore(10) # 玩家分数初始化为10
    eventPlayer.player_dealt_damage_flag = false # 玩家是否造成伤害标记初始化为假
    eventPlayer.player_injured_flag = false # 玩家受到伤害标记初始化为假
    eventPlayer.damage_amount = 0 # 玩家造成的伤害量初始化为0

    eventPlayer.bind_new_target = "" # 新绑定目标名称初始化为空字符串
    eventPlayer.bind_target = "" # 当前绑定玩家名称初始化为空字符串
    eventPlayer.bind_kill = false # 绑定目标违规击杀初始化为假
    eventPlayer.bound_players = [] # 与之绑定的玩家列表初始化为空

    eventPlayer.survival_timer = 0 # 存活计时器初始化为0
    eventPlayer.change_word_timer = change_word_cd # 词条更换计时器初始化为设定值
    eventPlayer.guess_word_timer = guess_word_cd # 猜词计时器初始化为设定值
