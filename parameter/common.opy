#!mainFile "../main.opy"

globalvar test_cases_pipeline # 是否启动测试用例流水线
globalvar finish_score # 完成条件分数
globalvar words_action # 动作类词库
globalvar words_attack # 攻击类词库
globalvar words_movement # 移动/位置类词库
globalvar words_survival # 生存类词库
globalvar words_interaction # 互动类词库
globalvar all_words # 词库总集合
globalvar change_word_cd # 词条更换cd
globalvar guess_word_cd # 猜词时间cd
globalvar guessing_active # 猜词环节是否激活
globalvar current_guesser # 当前猜词玩家
globalvar guessing_part # 猜词环节
globalvar guess_timmer # 猜词环节计时器(包含提问/下注/猜词)
globalvar qa_time # 提问环节时间
globalvar betting_time # 下注环节时间
globalvar guessing_time # 猜词环节时间
globalvar part_time # 当前环节时间
globalvar betting_switch # 下注环节开关
globalvar camera_mode_switch # 自由镜头模式开关
globalvar camera_presets # 摄像机预设信息列表
globalvar guess_camera_position # 猜词环节摄像机位置
globalvar guess_camera_facing # 猜词环节摄像机观察点
globalvar guess_word_list # 猜词列表
globalvar guess_word_positions # 猜词位置
globalvar guess_word_plane_center # 猜词平面位置中心
globalvar guess_word_yaw 
globalvar guess_word_pitch 
globalvar gGWP_i # 索引
globalvar gGWP_j # 索引
globalvar current_selection_index # 当前选中索引
globalvar current_selection_row
globalvar current_selection_col
globalvar correct_word_index # 正确答案索引
globalvar guess_word_result # 猜词结果


playervar cJ_i # 条件判断索引

playervar player_last_word # 玩家上一个词条
playervar player_word # 当前玩家词条
playervar player_dealt_damage_flag # 玩家是否造成伤害标记
playervar damage_amount # 玩家造成的伤害量

playervar bind_new_target # 新绑定目标名称
playervar bind_target # 当前绑定玩家名称
playervar bind_kill # 当前自己是否被违规击杀
playervar bound_players # 与之绑定的玩家列表

playervar survival_timer # 存活计时器
playervar change_word_timer # 词条更换计时器
playervar guess_word_timer # 猜词计时器

playervar testTarget # 测试用例目标玩家