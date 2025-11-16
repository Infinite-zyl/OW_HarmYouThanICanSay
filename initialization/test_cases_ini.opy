#!mainFile "../main.opy"

rule "测试用例变量初始化":
    @Event global

    test_cases_pipeline_state = PipLineState.IDLE # 测试用例流水线状态(默认闲置)
    
    test_cases_group_index = 0 # 默认第一个测试用例组
    test_cases_group_list = [] # 测试用例组列表
    test_cases_group_name = null # 当前测试用例组名称

    test_cases_index = 0 # 测试用例索引
    test_cases_list = [] # 测试用例列表
    test_cases_name = null # 测试用例名称

    test_case_hud_list = [] # 测试用例HUD列表
    
    check_faliled_list = [] # 初始化失败检查项列表

    mark_test_case_status = false # 标记测试用例状态