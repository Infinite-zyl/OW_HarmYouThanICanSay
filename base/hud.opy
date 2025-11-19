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

rule "切换英雄HUD":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Disabled

    hudHeader(
        eventPlayer if guessing_active == false else null, 
        "QQ群：1032545322", 
        HudPosition.RIGHT, 
        0, Color.WHITE, 
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
        "更换别人词条 : {}".format(eventPlayer.change_word_timer) if eventPlayer.change_word_timer > 0 else 
        "按下【 {} 】更换目标词条".format(inputBindingString(Button.MELEE)), 
        HudPosition.RIGHT, 
        -1, 
        Color.WHITE if eventPlayer.change_word_timer > 0 else Color.LIME_GREEN, 
        HudReeval.VISIBILITY_STRING_AND_COLOR)

rule "猜词倒计时HUD":
    @Event eachPlayer
    @Condition isGameInProgress()

    hudHeader(
        eventPlayer if guessing_active == false else null,
        "猜自己的词条 : {}".format(eventPlayer.guess_word_timer) if eventPlayer.guess_word_timer > 0 and guessing_active == false else 
        "发送【 集合 】进入猜词环节" if eventPlayer.guess_word_timer == 0 and guessing_active == false else
        null, 
        HudPosition.RIGHT, 
        0, 
        Color.WHITE if eventPlayer.guess_word_timer > 0 and guessing_part == GuessingPart.NONE else 
        Color.LIME_GREEN, 
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
    
    hudHeader(
        eventPlayer if guessing_active == false else null, 
        "被【 {} 】人绑定".format(len(eventPlayer.bound_players)), 
        HudPosition.TOP, 
        0, 
        Color.LIME_GREEN if len(eventPlayer.bound_players) <= 1 else
        Color.ORANGE if len(eventPlayer.bound_players) <= 3 else
        Color.RED, 
        HudReeval.VISIBILITY_STRING_AND_COLOR)

rule "侧面教程提示":
    @Event eachPlayer
    @Condition isGameInProgress()

    hudHeader(
        eventPlayer, 
        "按 住【 {} 】关 闭 教 程".format(inputBindingString(Button.ULTIMATE)) if eventPlayer.tutorial_flag == true else
        "按 住【 {} 】查 看 教 程".format(inputBindingString(Button.ULTIMATE)), 
        HudPosition.LEFT, 
        1, 
        Color.ORANGE, 
        HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(
        eventPlayer if eventPlayer.tutorial_flag == true else null, 
        "
  【诱使对方违规得分，比单纯击杀更重要】
  代码: 02531  版本: v1.1.2  QQ群:1032545322
————————基础玩法————————

· 每人头上有禁止动作词条，违规即死亡扣分
· 按【互动键】绑定目标，其违规死亡则得分
· 冷却结束后可更换目标词条或进入猜词环节
· 猜词可提两个问题，按【跳跃键】跳过提问
· 长 按【换 弹】键 可 切 换 英 雄

————————积分展示————————
· 违规ㅤㅤㅤㅤ  ㅤㅤㅤㅤ  ㅤㅤㅤㅤ  ㅤㅤㅤ  - 2
· 绑定玩家违规ㅤㅤㅤㅤ  ㅤㅤㅤㅤ  ㅤㅤㅤ  + 2
· 一分钟未违规ㅤㅤㅤㅤ  ㅤㅤㅤㅤ  ㅤㅤㅤ  + 1
· 猜词正确ㅤㅤㅤㅤ  ㅤㅤㅤㅤ  ㅤㅤ ㅤㅤㅤ  + 8
· 猜词错误ㅤㅤㅤㅤ  ㅤㅤㅤㅤ  ㅤㅤ ㅤㅤㅤ  - 4
————————————————————
", 
        HudPosition.LEFT, 
        2, 
        Color.WHITE, 
        HudReeval.VISIBILITY_AND_STRING)

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
        Color.LIME_GREEN if guess_timmer / part_time > 0.5 else
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

rule "二维码测试":
    @Condition isGameInProgress()
    @Disabled

    createInWorldText(
        getAllPlayers(), 
        "███████            █        ███        ███████
█                    █        █                ███    █                    █
█    ███    █    █        █        █    █    █    ███    █
█    ███    █        █        ████        █    ███    █
█    ███    █        █        █    █            █    ███    █
█                    █            ███    ███    █                    █
███████    █    █    █    █    █    ███████
                                █        █    █        █
███    █████            █        ████            █
            ██                █    ████            █                    █
████        ██        █████    █    ███    ███
    █                        ███    ██        ████            █
                █    █    █    ██    █    ██    ██    █    ██
    ██    ██        ████                █    █        █        █
█        █        ██    ██        ██            ██        ███
    ██    █            █        █    ██        █        █        █
█                ██        █        █            ██████
                                █    ████    ██            ██    ██
███████    ██    ██████    █    ██    ██
█                    █    █            ███    █            ██    ██
█    ███    █    ████        █    ██████    ██
█    ███    █                █            ███    ███
█    ███    █    ███        █    █    █        █            █
█                    █    █    ██            ███        █        █
███████    ███    █            ████            ██",
        guess_word_plane_center, 
        2, 
        Clip.NONE)