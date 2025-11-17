#!mainFile "../main.opy"

enum PointsEnum:
    ILLEGAL_KILL = -2 # 被违规击杀扣2分
    CHANGE_HERO = 0 # 换英雄不扣分
    BIND_KILL_REWARD = 2 # 绑定玩家死亡得2分
    SURVIVAL_POINT = 1 # 存活1分钟得1分
    GUESS_CORRECTLY = 8 # 猜词正确得8分
    GUESS_WRONG = -2 # 猜词错误扣2分+违规死亡共计4分
    TIMEOUT = -2 # 猜词超时未回答扣2分+违规死亡共计4分

enum WordNumber:
    KEEPMOVINGFORWARD = 5 # 按住前进键持续5秒
    ENEMYDISTANCEOUT = 15 # 攻击距离自身15m以外的敌人
    ENEMYDISTANCEIN = 3 # 攻击距离自身3m以内的敌人
    ONETIMEDAMAGE = 100 # 造成一次大于100点的伤害
    ALLDAMAGE = 500 # 累计造成500点伤害
    DONTHURT = 30 # 30S内不造成伤害
    KEEPMOVING = 10 # 持续移动10秒钟
    INAIR = 1 # 在空中待1秒钟
    DONTMOVE = 5 # 5秒内不移动
    GROUNDDISTANCE = 6 # 距离地面6m以上
    SURVIVALTIME = 100 # 存活100秒
    STAREENEMY = 5 # 凝视敌人超过5秒
    FIGHTBACK = 5 # 受伤超过5秒不还手
    NOSKILLS = 10 # 10秒内不使用技能

enum GuessingPart:
    NONE = 0 # 非猜词阶段
    QA = 1 # 提问阶段
    BETTING = 2 # 下 注阶段
    GUESSING = 3 # 猜词阶段

enum GuessResult:
    NONE = 0 # 猜词结果无
    SUCCESS = 1 # 猜词结果正确
    FAILURE = 2 # 猜词结果错误