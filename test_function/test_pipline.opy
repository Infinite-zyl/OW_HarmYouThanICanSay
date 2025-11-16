#!mainFile "../../main.opy"

enum TcGroup:
    TC1 = "游戏胜利测试组"


macro loadTestCasesFromGroup():
    test_cases_group_list = [
        TcGroup.TC1,
    ]
    test_cases_group_name = test_cases_group_list[test_cases_group_index]


macro setGroupHudHeader():
    hudHeader(
        hostPlayer, 
        "当前用例组:{}\n当前用例:{}\n状态:{}".format(
            test_cases_group_name if test_cases_group_name != null else "无",
            test_cases_name if test_cases_name != null else "无",
            "失败" if test_cases_state == TestCaseStatus.FAILED else
            "完成" if test_cases_state == TestCaseStatus.COMPLETED else
            "进行中" if test_cases_state == TestCaseStatus.IN_PROGRESS else
            "未开始" if test_cases_state == TestCaseStatus.NOT_STARTED else "无"),
        HudPosition.RIGHT, 
        -1,
        Color.YELLOW, 
        HudReeval.VISIBILITY_AND_STRING)

    test_case_hud_list[0] = getLastCreatedText()


rule "启动测试用例流水线":
    @Event eachPlayer
    @Condition test_cases_pipeline == true
    @Condition test_cases_pipeline_state == PipLineState.IDLE
    @Condition hostPlayer.isHoldingButton(Button.INTERACT)

    eventPlayer.buttonHoldPrint(
        button = Button.INTERACT, 
        msg_box = ["按住{}启动测试用例流水线".format(Button.INTERACT), "3", "2", "1"])
    if eventPlayer.is_holding:
        check_faliled_list = [] # 初始化失败检查项列表
        loadTestCasesFromGroup() # 加载测试用例组列表
        setGroupHudHeader() # 设置流水线HUD
        test_cases_pipeline_state = PipLineState.SELECTING


rule "上一个测试用例组":
    @Event eachPlayer
    @Condition test_cases_pipeline == true
    @Condition test_cases_pipeline_state == PipLineState.SELECTING
    @Condition hostPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    test_cases_group_index = (test_cases_group_index - 1) % len(test_cases_group_list)
    test_cases_group_name = test_cases_group_list[test_cases_group_index]


rule "下一个测试用例组":
    @Event eachPlayer
    @Condition test_cases_pipeline == true
    @Condition test_cases_pipeline_state == PipLineState.SELECTING
    @Condition hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    test_cases_group_index = (test_cases_group_index - 1) % len(test_cases_group_list)
    test_cases_group_name = test_cases_group_list[test_cases_group_index]


rule "确认测试用例组":
    @Event eachPlayer
    @Condition test_cases_pipeline == true
    @Condition test_cases_pipeline_state == PipLineState.SELECTING
    @Condition hostPlayer.isHoldingButton(Button.MELEE)

    test_cases_pipeline_state = PipLineState.RUNNING


rule "结束测试用例流水线":
    @Event global
    @Condition test_cases_pipeline == true
    @Condition test_cases_pipeline_state == PipLineState.PAUSED
    
    destroyHudText(test_case_hud_list[0])

    test_case_hud_list = []

    test_cases_group_index = 0 # 默认第一个测试用例组
    test_cases_group_list = [] # 测试用例组列表
    test_cases_group_name = null # 当前测试用例组名称

    test_cases_index = 0 # 测试用例索引
    test_cases_list = [] # 测试用例列表
    test_cases_name = null # 测试用例名称

    test_cases_pipeline_state = PipLineState.IDLE