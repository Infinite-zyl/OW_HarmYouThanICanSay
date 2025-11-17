#!mainFile "../main.opy"

rule "猜词功能计时器":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.guess_word_timer > 0
    
    wait(1)
    eventPlayer.guess_word_timer--
    if ruleCondition:
        loop()    

rule "猜词环节计时器":
    @Condition guessing_active == true
    @Condition isGameInProgress() == true
    @Condition guessing_part != GuessingPart.NONE
    @Condition guess_timmer > 0
    
    wait(1)
    guess_timmer--
    if ruleCondition:
        loop()  

rule "发送集合进入提问环节":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition isGameInProgress() == true
    @Condition eventPlayer.guess_word_timer == 0
    @Condition eventPlayer.player_last_word != "使用交流菜单里的指令"
    @Condition eventPlayer.isCommunicating(Comms.GROUP_UP) == true

    guessing_active = true
    guessing_part = GuessingPart.QA
    guess_timmer = qa_time
    part_time = qa_time
    current_guesser = eventPlayer
    guess_word_result = GuessResult.NONE
    eventPlayer.guess_word_timer = guess_word_cd

    # 提前加载猜词列表
    guess_word_list = random.shuffle(random.shuffle(all_words.exclude(eventPlayer.player_word)).slice(0, 5).concat(eventPlayer.player_word))
    current_selection_index = 0
    correct_word_index = guess_word_list.index(current_guesser.player_word)

rule "设置猜词环节玩家状态":
    @Event eachPlayer
    @Condition guessing_active == true
    @Condition isGameInProgress() == true
    
    eventPlayer.setMoveSpeed(0)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableHeroHud()
    eventPlayer.startCamera(
        eventPlayer.getEyePosition() + updateEveryFrame(eventPlayer.getFacingDirection()) * 0.5, 
        eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 100)
    wait(0.25)
    eventPlayer.startCamera(
        guess_camera_position, 
        guess_word_plane_center, 3)

rule "退出猜词环节恢复玩家状态":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition isGameInProgress() == true
    
    eventPlayer.setMoveSpeed(100)
    eventPlayer.enableGamemodeHud()
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    eventPlayer.stopCamera()
    eventPlayer.enableHeroHud()

rule "时间耗尽进入下 注环节/猜词环节":
    @Condition guessing_active == true
    @Condition guess_timmer == 0
    @Condition guessing_part == GuessingPart.QA

    wait(0.25) # 防止与跳过提问环节规则冲突
    if betting_switch == true:
        guessing_part = GuessingPart.BETTING
        guess_timmer = betting_time
        part_time = betting_time
    else:
        guessing_part = GuessingPart.GUESSING
        guess_timmer = guessing_time
        part_time = guessing_time

rule "猜词玩家主动跳过提问环节":
    @Event eachPlayer
    @Condition eventPlayer == current_guesser
    @Condition guessing_active == true and guessing_part == GuessingPart.QA
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    if betting_switch == true:
        guessing_part = GuessingPart.BETTING
        guess_timmer = betting_time
        part_time = betting_time
    else:
        guessing_part = GuessingPart.GUESSING
        guess_timmer = guessing_time
        part_time = guessing_time
    
rule "时间耗尽进入猜词环节":
    @Condition guessing_active == true
    @Condition betting_switch == true
    @Condition guess_timmer == 0
    @Condition guessing_part == GuessingPart.BETTING

    wait(0.25) # 防止与跳过提问环节规则冲突
    guessing_part = GuessingPart.GUESSING
    guess_timmer = guessing_time
    part_time = guessing_time

rule "猜词环节选择逻辑":
    @Event eachPlayer
    @Condition eventPlayer == current_guesser
    @Condition guess_timmer > 0
    @Condition guess_word_result == GuessResult.NONE
    @Condition guessing_active == true and guessing_part == GuessingPart.GUESSING

    current_selection_row = floor(current_selection_index / 2)
    current_selection_col = current_selection_index % 2

    if eventPlayer.getThrottle().z == 1:    # 前进 → 上
        current_selection_row = max(0, current_selection_row - 1)
    if eventPlayer.getThrottle().z == -1:   # 后退 → 下
        current_selection_row = min(2, current_selection_row + 1)
    if eventPlayer.getThrottle().x == 1:    # 左
        current_selection_col = max(0, current_selection_col - 1)
    if eventPlayer.getThrottle().x == -1:   # 右
        current_selection_col = min(1, current_selection_col + 1)
    
    current_selection_index = current_selection_row * 2 + current_selection_col

    wait(0.05)
    if ruleCondition:
        loop()

rule "猜词环节确认答案":
    @Event eachPlayer
    @Condition eventPlayer == current_guesser
    @Condition guess_timmer > 0 and guess_timmer < guessing_time - 1
    @Condition guess_word_result == GuessResult.NONE
    @Condition guessing_active == true and guessing_part == GuessingPart.GUESSING
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    if current_selection_index == correct_word_index:
        guess_word_result = GuessResult.SUCCESS
    else:
        guess_word_result = GuessResult.FAILURE

rule "猜词环节击杀判定":
    @Event eachPlayer
    @Condition guessing_active == true and guessing_part == GuessingPart.GUESSING
    @Condition guess_word_result != GuessResult.NONE

    # 延迟判定
    wait(1.4)
    if guess_word_result == GuessResult.SUCCESS and eventPlayer != current_guesser:
        illegal_kill()
    if guess_word_result == GuessResult.SUCCESS and eventPlayer == current_guesser:
        eventPlayer.player_word = random.choice(all_words)
        eventPlayer.addToScore(PointsEnum.GUESS_CORRECTLY)
    if guess_word_result == GuessResult.FAILURE and eventPlayer == current_guesser:
        eventPlayer.addToScore(PointsEnum.GUESS_WRONG)
        illegal_kill()

rule "时间耗尽扣分":
    @Event eachPlayer
    @Condition eventPlayer == current_guesser
    @Condition guessing_active == true
    @Condition guess_word_result == GuessResult.NONE
    @Condition guess_timmer == 0
    @Condition guessing_part == GuessingPart.GUESSING

    eventPlayer.addToScore(PointsEnum.TIMEOUT)
    illegal_kill()

rule "正常结束猜词环节":
    @Condition guessing_active == true
    @Condition guess_word_result != GuessResult.NONE
    @Condition guess_timmer > 0
    @Condition guessing_part == GuessingPart.GUESSING

    # 延迟判定
    wait(1.6)
    guessing_active = false
    guessing_part = GuessingPart.NONE
    current_guesser = ""

rule "时间耗尽结束猜词环节":
    @Condition guessing_active == true
    @Condition guess_word_result == GuessResult.NONE
    @Condition guess_timmer == 0
    @Condition guessing_part == GuessingPart.GUESSING

    wait(0.25) # 防止与跳过提问环节规则冲突
    guessing_active = false
    guessing_part = GuessingPart.NONE
    current_guesser = ""

rule "猜词玩家离开比赛":
    @Event playerLeft
    @Condition guessing_active == true

    if entityExists(current_guesser) != true:
        guessing_active = false
        guessing_part = GuessingPart.NONE
        current_guesser = ""
        wait(1)
        bigMessage(getAllPlayers(), "猜词玩家离开了比赛，无事发生")