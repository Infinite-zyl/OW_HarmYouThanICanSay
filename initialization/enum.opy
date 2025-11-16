#!mainFile "../main.opy"

enum PointsEnum:
    ILLEGAL_KILL = -2
    CHANGE_HERO = -1
    BIND_KILL_REWARD = 1
    SURVIVAL_POINT = 1
    GUESS_CORRECTLY = 5
    GUESS_WRONG = -2
    TIMEOUT = -1


enum GuessingPart:
    NONE = 0
    QA = 1
    BETTING = 2
    GUESSING = 3

enum GuessResult:
    NONE = 0
    SUCCESS = 1
    FAILURE = 2