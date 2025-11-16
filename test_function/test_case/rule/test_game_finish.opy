#!mainFile "../../../main.opy"

enum TestCase1 :
    CASE1 = "游戏胜利检测"


enum CheckList :
    CASE1 = "玩家大于目标得分，看是否胜利"

enum CheckResult :
    PASS = "通过"
    FAIL = "失败"

macro loadTestCases():
    test_cases_index = 0
    test_cases_list = [
        TestCase1.CASE1,
    ]
    test_cases_name = test_cases_list[test_cases_index]
    test_cases_state = TestCaseStatus.NOT_STARTED

    check_list = [
        [CheckList.CASE1, null],
    ]
    check_list_name = check_list[test_cases_index][0]

macro setCaseHudHeader():
    hudHeader(
        hostPlayer, 
        "检查项:{}".format(check_list_name if check_list_name != null else "无"),
        HudPosition.RIGHT, 
        0,
        Color.GREEN, 
        HudReeval.VISIBILITY_AND_STRING)

    test_case_hud_list[1] = getLastCreatedText()


rule "预加载起跑线测试":
    @Event global
    @Condition test_cases_group_name == TcGroup.TC1

    loadTestCases() # 预加载测试用例列表


rule "执行测试用例组":
    @Event global
    @Condition isGameInProgress() == true
    @Condition test_cases_pipeline_state == PipLineState.RUNNING

    setCaseHudHeader() # 设置检查项HUD
    for tc_reeval_i in range(len(test_cases_list)):
        wait(1)
        test_cases_index = tc_reeval_i  # 更新当前测试用例索引
        smallMessage(hostPlayer, "即将执行：{}".format(
            test_cases_name if test_cases_name != null else "无"))
        test_cases_name = test_cases_list[tc_reeval_i]
        check_list_name = check_list[tc_reeval_i][0]
        test_cases_state = TestCaseStatus.IN_PROGRESS
        waitUntil(
            test_cases_state == TestCaseStatus.COMPLETED or 
            test_cases_state == TestCaseStatus.FAILED, 99999)
    bigMessage(hostPlayer, "{}：执行完毕".format(
        test_cases_group_name if test_cases_group_name != null else "无"))
    destroyHudText(test_case_hud_list[1])
    test_cases_pipeline_state = PipLineState.PAUSED # 暂停流水线，等待下一组选择
    

rule "标记测试用例通过":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition test_cases_pipeline_state == PipLineState.RUNNING
    @Condition test_cases_state == TestCaseStatus.IN_PROGRESS
    @Condition mark_test_case_status == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    check_list[test_cases_index][1] = CheckResult.PASS
    mark_test_case_status = false


rule "标记测试用例失败":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition test_cases_pipeline_state == PipLineState.RUNNING
    @Condition test_cases_state == TestCaseStatus.IN_PROGRESS
    @Condition mark_test_case_status == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    check_list[test_cases_index][1] = CheckResult.FAIL
    mark_test_case_status = false

rule "测试用例：游戏胜利判定":
    @Event global
    @Condition isGameInProgress() == true
    @Condition test_cases_pipeline_state == PipLineState.RUNNING
    @Condition test_cases_group_name == TcGroup.TC1
    @Condition test_cases_name == TestCase1.CASE1
    @Condition test_cases_state == TestCaseStatus.IN_PROGRESS

    
