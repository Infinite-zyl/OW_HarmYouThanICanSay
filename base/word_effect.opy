#!mainFile "../main.opy"

def illegal_kill():
    @Name "违规动作击杀"

    eventPlayer.player_last_word = eventPlayer.player_word
    eventPlayer.player_word = ""
    eventPlayer.survival_timer = 0 # 重置存活计时器
    eventPlayer.bind_kill = true # 标记为被违规击杀
    eventPlayer.change_word_timer = change_word_cd # 重置词条更换计时器
    eventPlayer.guess_word_timer = guess_word_cd # 猜词计时器初始化为设定值

    kill(eventPlayer)
    eventPlayer.addToScore(PointsEnum.ILLEGAL_KILL) # 违规动作扣分
    # 对DVA单独处理
    if eventPlayer.getHero() == Hero.DVA:
        wait(1)
        kill(eventPlayer)

    # 清空死亡玩家的绑定者列表
    eventPlayer.bound_players = []
    eventPlayer.player_word = random.choice(all_words)

    wait(1)
    eventPlayer.bind_kill = false
    # 大字体显示上一个词条  
    bigMessage(eventPlayer, "禁止词条 ：{0}".format(eventPlayer.player_last_word))    
    

macro Player.conditionJudgment(time = 3, step_length = 1):
    for self.cJ_i in range(time / step_length):
        wait(step_length)
        if not ruleCondition:
            return

# 动作类
rule "连续跳跃":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "连续跳跃"
    @Condition eventPlayer.isJumping() == true

    eventPlayer.conditionJudgment(2)
    illegal_kill()

rule "按下跳跃键":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "按下跳跃键"
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    illegal_kill()

rule "按下蹲键":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "按下蹲键"
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true

    illegal_kill()

rule "按下装填键":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "按下装填键"
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true


    illegal_kill()

rule "抬头":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "抬头"
    @Condition eventPlayer.getVerticalFacingAngle() < -50
    
    illegal_kill()

rule "低头":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "低头"
    @Condition eventPlayer.getVerticalFacingAngle() > 50
    
    illegal_kill()

rule "按住前进键持续5秒":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "按住前进键持续{}秒".format(WordNumber.KEEPMOVINGFORWARD)
    @Condition eventPlayer.getThrottle() == vect(0, 0, 1)
    
    eventPlayer.conditionJudgment(WordNumber.KEEPMOVINGFORWARD)
    illegal_kill()

rule "按下后退键":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "按下后退键"
    @Condition eventPlayer.getThrottle() == vect(0, 0, -1)
    
    illegal_kill()

rule "使用交流菜单里的指令":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用交流菜单里的指令"
    @Condition eventPlayer.isCommunicatingAnything() == true
    @Condition eventPlayer.isCommunicatingEmote() == false
    @Condition eventPlayer.isCommunicatingVoiceline() == false
    @Condition eventPlayer.isCommunicatingSpray() == false
    
    illegal_kill()

rule "按下互动键":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "按下互动键"
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    illegal_kill()

rule "做表情":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "做表情"
    @Condition eventPlayer.isCommunicatingEmote() == true
    
    illegal_kill()

rule "打招呼":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "打招呼"
    @Condition eventPlayer.isCommunicating(Comms.HELLO) == true
    
    illegal_kill()

rule "发语音":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "发语音"
    @Condition eventPlayer.isCommunicatingVoiceline() == true
    
    illegal_kill()

rule "用光弹匣":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "用光弹匣"
    @Condition eventPlayer.getAmmo() == 0

    eventPlayer.conditionJudgment(0.5, 0.1)
    illegal_kill()

# 攻击类
rule "攻击距离自身15m以外的敌人":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "攻击距离自身{}m以外的敌人".format(WordNumber.ENEMYDISTANCEOUT)
    @Condition distance(attacker, victim) >= WordNumber.ENEMYDISTANCEOUT

    illegal_kill()

rule "攻击距离自身3m以内的敌人":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "攻击距离自身{}m以内的敌人".format(WordNumber.ENEMYDISTANCEIN)
    @Condition victim in getPlayersInRadius(eventPlayer, WordNumber.ENEMYDISTANCEIN, Team.ALL, LosCheck.SURFACES) == true

    illegal_kill()

rule "使用主要攻击":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用主要攻击"
    @Condition eventPlayer.isFiringPrimaryFire() == true

    illegal_kill()

rule "使用次要攻击":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用次要攻击"
    @Condition eventPlayer.isFiringSecondaryFire() == true

    illegal_kill()

rule "使用Shift技能":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用Shift技能"
    @Condition eventPlayer.isUsingAbility1() == true

    illegal_kill()

rule "使用E技能":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用E技能"
    @Condition eventPlayer.isUsingAbility2() == true

    illegal_kill()

rule "使用终极技能":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用终极技能"
    @Condition eventPlayer.isUsingUltimate() == true

    illegal_kill()

rule "使用快速近战攻击":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用快速近战攻击"
    @Condition eventPlayer.isMeleeing() == true
    
    illegal_kill()

rule "使用主要攻击造成伤害":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用主要攻击造成伤害"
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    illegal_kill()

rule "使用次要攻击造成伤害":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用次要攻击造成伤害"
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    illegal_kill()

rule "使用Shift造成伤害":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用Shift造成伤害"
    @Condition eventAbility == Button.ABILITY_1
    
    illegal_kill()

rule "使用E技能造成伤害":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用E技能造成伤害"
    @Condition eventAbility == Button.ABILITY_2
    
    illegal_kill()


rule "使用终极技能造成伤害":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用终极技能造成伤害"
    @Condition eventAbility == Button.ULTIMATE
    
    illegal_kill()

rule "使用快速近战造成伤害":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用快速近战造成伤害"
    @Condition eventAbility == Button.MELEE
    
    illegal_kill()

rule "攻击一名重装角色":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "攻击一名重装角色"
    
    if victim.getHero() in getTankHeroes() == true:
        illegal_kill()

rule "攻击一名输出角色":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "攻击一名输出角色"
    
    if victim.getHero() in getDamageHeroes() == true:
        illegal_kill()

rule "攻击一名辅助角色":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "攻击一名辅助角色"
    
    if victim.getHero() in getSupportHeroes() == true:
        illegal_kill()

rule "造成爆头伤害":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "造成爆头伤害"
    @Condition eventWasCriticalHit == true
    
    illegal_kill()

rule "造成击退":
    @Event playerDealtKnockback
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "造成击退"
    
    illegal_kill()

rule "造成一次大于100点的伤害":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "造成一次大于{}点的伤害".format(WordNumber.ONETIMEDAMAGE)
    @Condition eventDamage > WordNumber.ONETIMEDAMAGE
    
    illegal_kill()

rule "造成一次地形杀":
    @Event playerDealtFinalBlow
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "造成一次地形杀"
    @Condition eventWasEnvironment == true
    
    illegal_kill()

rule "累计造成500点伤害":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "累计造成{}点伤害".format(WordNumber.ALLDAMAGE)
    
    eventPlayer.damage_amount += eventDamage
    if eventPlayer.damage_amount >= WordNumber.ALLDAMAGE:
        eventPlayer.damage_amount = 0
        illegal_kill()

rule "造成击杀":
    @Event playerDealtFinalBlow
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "造成击杀"
    
    illegal_kill()

rule "30秒内不造成伤害":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "{}秒内不造成伤害".format(WordNumber.DONTHURT)
    @Condition eventPlayer.player_dealt_damage_flag == false
    
    eventPlayer.conditionJudgment(WordNumber.DONTHURT)
    illegal_kill()
    

rule "30秒内不造成伤害：恢复计时":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "{}秒内不造成伤害".format(WordNumber.DONTHURT)
    
    eventPlayer.player_dealt_damage_flag = true
    wait(0.25)
    eventPlayer.player_dealt_damage_flag = false

rule "10秒内不使用技能":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "{}秒内不使用技能".format(WordNumber.NOSKILLS)
    @Condition (eventPlayer.isHoldingButton(Button.ABILITY_1) or 
    eventPlayer.isHoldingButton(Button.ABILITY_2) or 
    eventPlayer.isHoldingButton(Button.ULTIMATE)) != true

    eventPlayer.conditionJudgment(WordNumber.NOSKILLS, 0.1)
    illegal_kill()

# 移动/位置类
rule "持续移动10秒钟":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "持续移动{}秒钟".format(WordNumber.KEEPMOVING)
    @Condition eventPlayer.isMoving() == true
    
    eventPlayer.conditionJudgment(WordNumber.KEEPMOVING)
    illegal_kill()

rule "在空中待1秒钟":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "在空中待{}秒钟".format(WordNumber.INAIR)
    @Condition eventPlayer.isInAir() == true
    
    eventPlayer.conditionJudgment(WordNumber.INAIR, 0.25)
    illegal_kill()

rule "5秒内不移动":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "{}秒内不移动".format(WordNumber.DONTMOVE)
    @Condition eventPlayer.isStanding() == true
    
    eventPlayer.conditionJudgment(WordNumber.DONTMOVE)
    illegal_kill()

rule "移速过快":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "移速过快"
    @Condition eventPlayer.getHorizontalSpeed() > 10
    
    illegal_kill()

rule "距离地面6m以上":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "距离地面{}m以上".format(WordNumber.GROUNDDISTANCE)
    @Condition eventPlayer.getAltitude() > WordNumber.GROUNDDISTANCE
    
    illegal_kill()

rule "靠近一名敌人":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "靠近一名敌人"
    @Condition distance(eventPlayer, getRealClosestPlayer(eventPlayer, Team.ALL)) <= 3
    
    illegal_kill()

#生存/治疗类
rule "吃血包":
    @Event playerReceivedHealing
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "吃血包"
    @Condition eventWasHealthPack == true
    
    illegal_kill()

rule "自己治疗自己":
    @Event playerReceivedHealing
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "自己治疗自己"
    @Condition healer == healee
    
    illegal_kill()

rule "存活100秒":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "存活{}秒".format(WordNumber.SURVIVALTIME)
    @Condition eventPlayer.survival_timer == WordNumber.SURVIVALTIME

    illegal_kill()

# 观察/互动类
rule "凝视敌人超过五秒":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "凝视敌人超过{}秒".format(WordNumber.STAREENEMY)
    @Condition eventPlayer.isInViewAngle(eventPlayer.getRealPlayerClosestToReticle(Team.ALL), 20) == true
    @Condition isInLoS(eventPlayer, eventPlayer.getRealPlayerClosestToReticle(Team.ALL)) == true
    
    eventPlayer.conditionJudgment(WordNumber.STAREENEMY)
    illegal_kill()

rule "头像框火力全开":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "头像框火力全开"
    @Condition eventPlayer.isOnFire() == true
    
    illegal_kill()

rule "受伤超过5秒不还手 : 初始化阶段":
    @Event playerTookDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_injured_flag == false
    @Condition eventPlayer.player_word == "受伤超过{}秒不还手".format(WordNumber.FIGHTBACK)

    eventPlayer.player_injured_flag = true

rule "受伤超过5秒不还手":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_injured_flag == true
    @Condition eventPlayer.player_word == "受伤超过{}秒不还手".format(WordNumber.FIGHTBACK)

    eventPlayer.conditionJudgment(WordNumber.FIGHTBACK)
    illegal_kill()
    eventPlayer.player_injured_flag = false

rule "受伤超过5秒不还手":
    @Event playerDealtDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "受伤超过{}秒不还手".format(WordNumber.FIGHTBACK)
    
    eventPlayer.player_injured_flag = false

rule "周围有3名以上的敌人":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "周围有3名以上的敌人"
    @Condition len([player for player in getAllPlayers() if distance(eventPlayer.getPosition(), player.getPosition()) <= 2]) >= 3

    illegal_kill()

# 状态类
rule "被入侵":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.hasStatus(Status.HACKED) == true
    @Condition eventPlayer.player_word == "被入侵"
    
    illegal_kill()

rule "被点燃":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.hasStatus(Status.BURNING) == true
    @Condition eventPlayer.player_word == "被点燃"
    
    illegal_kill()

rule "被击倒":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.hasStatus(Status.KNOCKED_DOWN) == true
    @Condition eventPlayer.player_word == "被击倒"
    
    illegal_kill()

rule "被沉睡":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.hasStatus(Status.ASLEEP) == true
    @Condition eventPlayer.player_word == "被沉睡"
    
    illegal_kill()

rule "被击晕":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.hasStatus(Status.STUNNED) == true
    @Condition eventPlayer.player_word == "被击晕"
    
    illegal_kill()

rule "生命值少于200":
    @Event playerTookDamage
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "生命值少于200"

    if eventPlayer.getHealth() < 200:
        illegal_kill()

# 角色类
rule "使用重装英雄":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用重装英雄"

    wait(1)
    if eventPlayer.getHero() in getTankHeroes() == true:
        illegal_kill()

rule "使用辅助英雄":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用辅助英雄"

    wait(1)
    if eventPlayer.getHero() in getSupportHeroes() == true:
        illegal_kill()

rule "使用输出英雄":
    @Event eachPlayer
    @Condition guessing_active == false
    @Condition eventPlayer.player_word == "使用输出英雄"

    wait(1)
    if eventPlayer.getHero() in getDamageHeroes() == true:
        illegal_kill()