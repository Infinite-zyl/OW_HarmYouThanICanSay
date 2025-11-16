#!mainFile "../main.opy"

rule "地图工坊调整参数":
    
    # finish_score = createWorkshopSettingInt("游戏设置", "完成游戏所需分数", 40, 30, 60, 0)
    change_word_cd = createWorkshopSettingInt("游戏设置", "换词条CD", 50, 30, 80, 0)
    # guess_word_cd = createWorkshopSettingInt("游戏设置", "猜词CD", 0, 0, 80, 0)
    guess_word_cd = createWorkshopSettingInt("游戏设置", "猜词CD", 60, 40, 80, 0)
    qa_time = createWorkshopSettingInt("猜词设置", "提问环节时间", 40, 20, 80, 0)
    betting_time = createWorkshopSettingInt("猜词设置", "下 注环节时间", 10, 5, 20, 0)
    guessing_time = createWorkshopSettingInt("猜词设置", "猜词环节时间", 30, 10, 40, 0)

    #是否启用测试用例
    # test_cases_pipeline = createWorkshopSettingBool("开发者功能", "启动测试用例流水线", false, 0)
    # camera_mode_switch = createWorkshopSettingBool("开发者功能", "自由镜头模式开关", true, 0)
    betting_switch = createWorkshopSettingBool("开发者功能", "下 注功能开关(暂无效)", false, 0)