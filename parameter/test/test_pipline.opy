#!mainFile "../../main.opy"

enum TestCaseStatus :
    NOT_STARTED = 0
    IN_PROGRESS 
    COMPLETED
    FAILED 

enum PipLineState :
    IDLE = 0
    SELECTING
    RUNNING
    PAUSED

globalvar test_cases_pipeline_state # 测试用例流水线状态

globalvar test_cases_group_index # 测试用例组索引
globalvar test_cases_group_list # 测试用例组列表
globalvar test_cases_group_name # 当前测试用例组名称

globalvar test_cases_index # 测试用例索引
globalvar test_cases_list # 测试用例列表
globalvar test_cases_name # 测试用例名称
globalvar test_cases_state # 测试用例状态

globalvar check_list # 检查项列表
globalvar check_list_name # 当前检查项名称
globalvar check_faliled_list # 失败检查项列表
globalvar mark_test_case_status # 标记测试用例状态

globalvar test_case_hud_list # 测试用例HUD列表
globalvar tc_hud_i # 循环变量
globalvar tc_reeval_i # 循环变量