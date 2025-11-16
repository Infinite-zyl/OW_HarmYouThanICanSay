#!mainFile "../main.opy"

macro generateGuessWordPositionsByAngle(distance, colAngleStep, rowAngleStep):
    guess_word_yaw = horizontalAngleOfDirection(guess_camera_facing)
    guess_word_pitch = verticalAngleOfDirection(guess_camera_facing)

    guess_word_plane_center = guess_camera_position + normalize(guess_camera_facing) * distance

    guess_word_positions = []
    for gGWP_i in range(3):       # 行
        for gGWP_j in range(2):   # 列
            guess_word_positions.append(guess_camera_position + directionFromAngles(guess_word_yaw + (0.5 - gGWP_j) * colAngleStep, guess_word_pitch + (gGWP_i - 1) * rowAngleStep) * distance)

rule "所有镜头信息初始化":
    
    camera_presets = [
        
        ["66号公路", vect(125.48, 49.63, -141.22), vect(-0.01, 0.11, 0.99)],
        ["伊利奥斯废墟", vect(-48.47, -60.12, -307.02), vect(-0.27, 0.4, -0.87)],
        ["伊利奥斯深井", vect(-272.86, 2.62, -75.82), vect(0.65, 0.49, 0.58)],
        ["伊利奥斯灯塔", vect(403.97, -16.76, -34.69), vect(-0.65, 0.25, -0.72)],
        ["佩特拉", vect(-45.96, -14.28, 6.16), vect(-1.0, -0.0, -0.0)],
        ["吉拉德堡", vect(199.40, 5.86, 279.10), vect(-0.01, 0.45, -0.89)],
        ["哈瓦那", vect(-34.32, 32.00, -90.47), vect(-0.01, -0.08, 1.00)],
        ["国王大道", vect(2.62, 5.19, -17.08), vect(-0.46, 0.70, -0.55)],
        ["城堡", vect(-106.90, 53.38, 90.20), vect(0.70, -0.13, -0.70)],
        ["墓园", vect(-58.14, 55.68, 78.72), vect(0.74, -0.12, -0.66)],
        ["多拉多", vect(14.74, 3.19, 90.62), vect(0.42, 0.43, -0.80)],
        ["好莱坞", vect(41.48, 58.73, -88.52), vect(-0.04, 0.67, -0.74)],
        ["尼泊尔圣坛", vect(-108.39, 15.80, -0.04), vect(0.95, 0.30, 0.00)],
        ["尼泊尔圣所", vect(69.34, 139.63, -15.90), vect(0.62, -0.33, 0.71)],
        ["尼泊尔村庄", vect(-265.04, -48.01, -0.28), vect(0.87, -0.49, 0.01)],
        ["巴黎", vect(-102.43, 12.30, 15.59), vect(-0.11, 0.44, 0.89)],
        ["暴雪世界", vect(2.60, 7.01, -50.78), vect(0.00, 0.45, -0.89)],
        ["月球基地", vect(157.01, 22.55, -39.65), vect(-0.83, 0.46, -0.31)],
        ["沃斯卡娅工业区", vect(-73.06, 28.39, 61.89), vect(-0.86, 0.03, -0.51)],
        ["漓江塔夜市", vect(1.44, 1.46, -143.09), vect(-0.00, 0.48, 0.88)],
        ["漓江塔庭院", vect(-54.63, 110.93, 128.1), vect(0.88, 0.42, -0.2)],
        ["漓江塔控制中心", vect(-238.61, 204.54, 299.94), vect(0.71, 0.63, -0.31)],
        ["生态监测站", vect(6.04, 27.81, -50.89), vect(-0.48, -0.06, 0.87)],
        ["绿洲城中心", vect(66.97, 4.51, 170.80), vect(0.68, 0.27, 0.68)],
        ["绿洲城大学", vect(255.85, 7.71, 81.84), vect(-0.87, 0.47, 0.13)],
        ["绿洲城花园", vect(199.79, 18.68, -303.64), vect(-0.66, 0.37, 0.65)],
        ["艾兴瓦尔德", vect(-2.53, 32.12, -64.82), vect(0.83, 0.46, -0.30)],
        ["花村", vect(-12.98, 12.40, -86.88), vect(-0.71, -0.00, -0.70)],
        ["铁坂", vect(-46.79, 27.45, -9.30), vect(0.82, 0.30, -0.48)],
        ["阿努比斯神殿", vect(-10.63, 16.81, 66.46), vect(0.06, 0.28, 0.96)],
        ["马莱温多", vect(33.18, 23.44, -39.51), vect(-0.81, 0.09, 0.58)],
        ["黑森林", vect(-71.68, 21.34, -4.99), vect(0.97, 0.21, 0.14)],
    ]

rule "当前地图镜头信息赋值":
    @Condition isGameInProgress() == true 

    guess_camera_position = [p for p in camera_presets if strContains("{0}".format(getCurrentMap()), p[0])][0][1]
    guess_camera_facing = [p for p in camera_presets if strContains("{0}".format(getCurrentMap()), p[0])][0][2]
    generateGuessWordPositionsByAngle(50, 40, 15)
    