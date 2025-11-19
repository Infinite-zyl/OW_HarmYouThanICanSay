#!mainFile "../main.opy"

# rule "游戏结束条件":
#     @Event eachPlayer
#     @Condition isGameInProgress() == true
#     @Condition eventPlayer.getScore() >= finish_score
    
#     declarePlayerVictory(eventPlayer)


rule "自动重开":
    @Condition isMatchComplete() == true
    
    wait(8.5)
    restartMatch()

rule "按住换弹键切换英雄":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true

    wait(0.5)
    if not ruleCondition:
        return
    wait(0.5)
    if not ruleCondition:
        return
    eventPlayer.addToScore(PointsEnum.CHANGE_HERO)
    eventPlayer.setAllowedHeroes([i for i in getAllHeroes() if i != eventPlayer.getHero()])
    eventPlayer.setAllowedHeroes(getAllHeroes())

rule "按下互动绑定":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.getRealPlayerClosestToReticle(Team.ALL) != null
    @Condition isInLoS(eventPlayer, eventPlayer.getRealPlayerClosestToReticle(Team.ALL)) == true

    # 找到新的绑定目标
    eventPlayer.bind_new_target = eventPlayer.getRealPlayerClosestToReticle(Team.ALL)

    # 如果已有绑定对象，先解除旧绑定
    if eventPlayer.bind_target != "":
        eventPlayer.bind_target.bound_players.remove(eventPlayer)

    # 更新绑定对象
    eventPlayer.bind_target = eventPlayer.bind_new_target

    # 把自己加入新目标的绑定列表
    eventPlayer.bind_new_target.bound_players.append(eventPlayer)

rule "小字体提示先绑定再互动":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.bind_target == ""
    @Condition eventPlayer.getRealPlayerClosestToReticle(Team.ALL) != null
    @Condition isInLoS(eventPlayer, eventPlayer.getRealPlayerClosestToReticle(Team.ALL)) == true

    wait(5)
    if not ruleCondition:
        return
    smallMessage(eventPlayer, "按下【 {} 】绑定你要整蛊的玩家".format(inputBindingString(Button.INTERACT)))
    wait(5)
    smallMessage(eventPlayer, "请先绑定目标再互动，否则不计得分！！！")
    if ruleCondition:
        loop()

rule "玩家违规死亡处理":
    @Event eachPlayer
    @Condition eventPlayer.bind_target.bind_kill == true

    eventPlayer.addToScore(PointsEnum.BIND_KILL_REWARD)
    smallMessage(eventPlayer, "获得积分【 {} 】".format(PointsEnum.BIND_KILL_REWARD))
    eventPlayer.bind_target = ""

rule "存活计时器":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isAlive() == true
    
    wait(1)
    eventPlayer.survival_timer++
    if ruleCondition:
        loop()

rule "存活积分":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition eventPlayer.survival_timer != 0
    @Condition eventPlayer.survival_timer % 60 == 0
    
    eventPlayer.addToScore(1)
    smallMessage(eventPlayer, "存活一分钟，获得积分【 {} 】".format(PointsEnum.SURVIVAL_POINT))

rule "换词条计时器":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.change_word_timer > 0
    
    wait(1)
    eventPlayer.change_word_timer--
    if ruleCondition:
        loop()    

rule "词条更换":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.change_word_timer == 0 # 冷却结束
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.getRealPlayerClosestToReticle(Team.ALL) != null
    @Condition isInLoS(eventPlayer, eventPlayer.getRealPlayerClosestToReticle(Team.ALL)) == true

    eventPlayer.getRealPlayerClosestToReticle(Team.ALL).player_last_word = eventPlayer.getRealPlayerClosestToReticle(Team.ALL).player_word
    eventPlayer.getRealPlayerClosestToReticle(Team.ALL).player_word = random.choice(all_words)
    smallMessage(eventPlayer.getRealPlayerClosestToReticle(Team.ALL), "小心！有人更换了你的词条！")

    eventPlayer.change_word_timer = change_word_cd # 重置词条更换计时器

rule "开关教程":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true

    wait(0.5)
    if not ruleCondition:
        return
    wait(0.5)
    if not ruleCondition:
        return
    if eventPlayer.tutorial_flag == true:
        eventPlayer.tutorial_flag = false
    else:
        eventPlayer.tutorial_flag = true