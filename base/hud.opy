#!mainFile "../main.opy"

rule "玩家头顶词条HUD显示":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Condition eventPlayer.player_word != null

    # 给非绑定玩家显示普通词条
    createInWorldText(
        getAllPlayers().exclude(eventPlayer).exclude(eventPlayer.bound_players) if guessing_active == false and eventPlayer.hasSpawned() == true else null, 
        "存活{}秒".format(WordNumber.SURVIVALTIME - eventPlayer.survival_timer) 
        if eventPlayer.player_word == "存活{}秒".format(WordNumber.SURVIVALTIME) 
        else eventPlayer.player_word, 
        updateEveryFrame(eventPlayer.getEyePosition() + vect(0, 1.25, 0)), 
        2, 
        Clip.SURFACES, 
        WorldTextReeval.VISIBILITY_POSITION_AND_STRING)

    # 给绑定玩家显示黄色词条
    createInWorldText(
        eventPlayer.bound_players if guessing_active == false and eventPlayer.hasSpawned() == true else null, 
        "存活{}秒".format(WordNumber.SURVIVALTIME - eventPlayer.survival_timer) 
        if eventPlayer.player_word == "存活{}秒".format(WordNumber.SURVIVALTIME) 
        else eventPlayer.player_word,
        updateEveryFrame(eventPlayer.getEyePosition() + vect(0, 1.25, 0)), 
        2, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_AND_STRING, 
        Color.YELLOW)

rule "给准备绑定目标显示绑定提示":
    @Event eachPlayer
    @Condition isGameInProgress()

    # 给准绑定目标显示绑定提示
    createInWorldText(
        eventPlayer if 
        eventPlayer.getRealPlayerClosestToReticle(Team.ALL) != null and
        eventPlayer.getRealPlayerClosestToReticle(Team.ALL) != eventPlayer.bind_target and 
        isInLoS(eventPlayer, eventPlayer.getRealPlayerClosestToReticle(Team.ALL)) else null, 
        "按下【 {} 】绑定".format(inputBindingString(Button.INTERACT)), 
        updateEveryFrame(eventPlayer.getRealPlayerClosestToReticle(Team.ALL).getEyePosition() + vect(0, 2.25, 0)), 
        1.5, 
        Clip.SURFACES, 
        WorldTextReeval.VISIBILITY_POSITION_AND_STRING, 
        Color.YELLOW)

rule "切换英雄HUD":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Disabled

    hudHeader(
        eventPlayer if guessing_active == false else null, 
        "按住换弹键切换英雄", 
        HudPosition.RIGHT, 
        1, Color.WHITE, 
        HudReeval.VISIBILITY_AND_STRING)

rule "当前积分显示HUD":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Disabled

    hudHeader(
        eventPlayer, 
        "当前积分 : {}".format(eventPlayer.getScore()), 
        HudPosition.RIGHT, 0, 
        Color.WHITE, 
        HudReeval.VISIBILITY_AND_STRING)

rule "换词条倒计时HUD":
    @Event eachPlayer
    @Condition isGameInProgress()

    hudHeader(
        eventPlayer if guessing_active == false else null, 
        "更换目标词条 : {}".format(eventPlayer.change_word_timer) if eventPlayer.change_word_timer > 0 else 
        "按下【 {} 】更换目标词条".format(inputBindingString(Button.MELEE)), 
        HudPosition.LEFT, 
        -1, 
        Color.WHITE if eventPlayer.change_word_timer > 0 else Color.GREEN, 
        HudReeval.VISIBILITY_STRING_AND_COLOR)

rule "猜词倒计时HUD":
    @Event eachPlayer
    @Condition isGameInProgress()

    hudHeader(
        eventPlayer if guessing_active == false else null,
        "猜词 : {}".format(eventPlayer.guess_word_timer) if eventPlayer.guess_word_timer > 0 and guessing_active == false else 
        "发送集合开始猜词" if eventPlayer.guess_word_timer == 0 and guessing_active == false else
        null, 
        HudPosition.LEFT, 
        0, 
        Color.WHITE if eventPlayer.guess_word_timer > 0 and guessing_part == GuessingPart.NONE else 
        Color.GREEN, 
        HudReeval.VISIBILITY_STRING_AND_COLOR)

rule "顶部提示提示":
    @Event eachPlayer
    @Condition isGameInProgress()

    hudHeader(
        eventPlayer if guessing_active == true else null, 
        "提 问 环 节" if guessing_part == GuessingPart.QA else
        "下 注 环 节" if guessing_part == GuessingPart.BETTING else
        "猜 词 环 节" if guessing_part == GuessingPart.GUESSING else
        null, 
        HudPosition.TOP, 
        -1, 
        Color.SKY_BLUE, 
        HudReeval.VISIBILITY_STRING_AND_COLOR)

rule "猜词环节HUD":
    @Event eachPlayer
    @Condition isGameInProgress()

    progressBarHud(
        eventPlayer if guessing_active == true else null, 
        guess_timmer / part_time * 100, 
        "按下【跳跃】跳过提问环节，剩余时间 : {}".format(guess_timmer) if guessing_part == GuessingPart.QA and eventPlayer == current_guesser else 
        "等待提问，剩余时间 : {}".format(guess_timmer) if guessing_part == GuessingPart.QA and eventPlayer != current_guesser else
        "等待其余玩家下 注，剩余时间 : {}".format(guess_timmer) if guessing_part == GuessingPart.BETTING and eventPlayer == current_guesser else
        "预测猜词玩家成功或失败，剩余时间 : {}".format(guess_timmer) if guessing_part == GuessingPart.BETTING and eventPlayer != current_guesser else
        "【方向键】选择，【跳跃】确认，剩余时间 : {}".format(guess_timmer) if guessing_part == GuessingPart.GUESSING and eventPlayer == current_guesser else
        "等待玩家选择，剩余时间 : {}".format(guess_timmer) if guessing_part == GuessingPart.GUESSING and eventPlayer != current_guesser else
        "剩余时间 : {}".format(guess_timmer), 
        HudPosition.TOP, 
        0, 
        Color.GREEN if guess_timmer / part_time > 0.5 else
        Color.YELLOW if guess_timmer / part_time > 0.2 else
        Color.RED, 
        Color.YELLOW)

    hudHeader(
        eventPlayer if eventPlayer != current_guesser and guessing_active == true else null, 
        "【{}】的词条: \n【{}】".format(current_guesser, current_guesser.player_word), 
        HudPosition.LEFT, 
        0, 
        Color.LIGHT_RED, 
        HudReeval.VISIBILITY_STRING_AND_COLOR)


rule "猜词地图文本显示猜测词语":
    @Condition isGameInProgress()
    
    createInWorldText(
        getAllPlayers() if guessing_active == true and guessing_part == GuessingPart.GUESSING else null, 
        "{}".format(guess_word_list[0]), 
        guess_word_positions[0], 
        2, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        Color.YELLOW if current_selection_index == 0 and guess_word_result == GuessResult.NONE else 
        Color.GREEN if correct_word_index == 0 and guess_word_result != GuessResult.NONE else 
        Color.RED if current_selection_index == 0 and guess_word_result == GuessResult.FAILURE else
        Color.WHITE)
    
    createInWorldText(
        getAllPlayers() if guessing_active == true and guessing_part == GuessingPart.GUESSING else null, 
        "{}".format(guess_word_list[1]), 
        guess_word_positions[1], 
        2, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        Color.YELLOW if current_selection_index == 1 and guess_word_result == GuessResult.NONE else 
        Color.GREEN if correct_word_index == 1 and guess_word_result != GuessResult.NONE else 
        Color.RED if current_selection_index == 1 and guess_word_result == GuessResult.FAILURE else
        Color.WHITE)

    createInWorldText(
        getAllPlayers() if guessing_active == true and guessing_part == GuessingPart.GUESSING else null, 
        "{}".format(guess_word_list[2]), 
        guess_word_positions[2], 
        2, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        Color.YELLOW if current_selection_index == 2 and guess_word_result == GuessResult.NONE else 
        Color.GREEN if correct_word_index == 2 and guess_word_result != GuessResult.NONE else 
        Color.RED if current_selection_index == 2 and guess_word_result == GuessResult.FAILURE else
        Color.WHITE)

    createInWorldText(
        getAllPlayers() if guessing_active == true and guessing_part == GuessingPart.GUESSING else null, 
        "{}".format(guess_word_list[3]), 
        guess_word_positions[3], 
        2, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        Color.YELLOW if current_selection_index == 3 and guess_word_result == GuessResult.NONE else 
        Color.GREEN if correct_word_index == 3 and guess_word_result != GuessResult.NONE else 
        Color.RED if current_selection_index == 3 and guess_word_result == GuessResult.FAILURE else
        Color.WHITE)

    createInWorldText(
        getAllPlayers() if guessing_active == true and guessing_part == GuessingPart.GUESSING else null, 
        "{}".format(guess_word_list[4]), 
        guess_word_positions[4], 
        2, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        Color.YELLOW if current_selection_index == 4 and guess_word_result == GuessResult.NONE else 
        Color.GREEN if correct_word_index == 4 and guess_word_result != GuessResult.NONE else 
        Color.RED if current_selection_index == 4 and guess_word_result == GuessResult.FAILURE else
        Color.WHITE)

    createInWorldText(
        getAllPlayers() if guessing_active == true and guessing_part == GuessingPart.GUESSING else null, 
        "{}".format(guess_word_list[5]), 
        guess_word_positions[5], 
        2, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        Color.YELLOW if current_selection_index == 5 and guess_word_result == GuessResult.NONE else 
        Color.GREEN if correct_word_index == 5 and guess_word_result != GuessResult.NONE else 
        Color.RED if current_selection_index == 5 and guess_word_result == GuessResult.FAILURE else
        Color.WHITE)