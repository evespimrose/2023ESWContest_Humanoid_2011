'******** 2족 보행로봇 초기 영점 프로그램 ********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE
DIM 보행순서 AS BYTE
DIM 현재전압 AS BYTE
DIM 반전체크 AS BYTE
DIM 모터ONOFF AS BYTE
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER
DIM TRUE AS INTEGER
DIM FALSE AS INTEGER

DIM 곡선방향 AS BYTE

DIM 넘어진확인 AS BYTE
DIM 기울기확인횟수 AS BYTE
DIM 보행횟수 AS BYTE
DIM 보행COUNT AS BYTE

DIM 적외선거리값  AS BYTE

DIM S11  AS BYTE
DIM S16  AS BYTE
'************************************************
DIM NO_0 AS INTEGER
DIM NO_1 AS INTEGER
DIM NO_2 AS INTEGER
DIM NO_3 AS INTEGER
DIM NO_4 AS INTEGER

DIM NUM AS BYTE

DIM BUTTON_NO AS INTEGER
DIM SOUND_BUSY AS BYTE
DIM TEMP_INTEGER AS INTEGER
DIM CC AS BYTE
DIM FORNUM AS INTEGER
DIM FIFTEEN AS BYTE
DIM SIXTEEN AS BYTE
DIM BOOLEAN AS INTEGER

'**** 기울기센서포트 설정 ****
CONST 앞뒤기울기AD포트 = 0
CONST 좌우기울기AD포트 = 1
CONST 기울기확인시간 = 20  'ms

CONST 적외선AD포트  = 4


CONST min = 61	'뒤로넘어졌을때
CONST max = 107	'앞으로넘어졌을때
CONST COUNT_MAX = 3

CONST x = 15



CONST 머리이동속도 = 10
'************************************************

DIM isWalk AS INTEGER
DIM isAroundLR AS INTEGER
DIM isNeckDown AS INTEGER
DIM isRoundHoleCheck AS INTEGER
DIM isShot AS INTEGER
DIM isAroundLRUD AS INTEGER
DIM isNeckChase AS INTEGER
DIM isBodyRotate AS INTEGER
DIM isNeckDownEff AS INTEGER
DIM isWalkTwo AS INTEGER
DIM isLeft AS INTEGER
DIM isRound AS INTEGER

'**************************************************

DIM xx AS BYTE
DIM First AS BYTE
DIM Second AS BYTE
DIM ABS AS BYTE
DIM Loop AS BYTE

DIM SEVENTEEN AS BYTE
DIM SERVO_SIXTEEN AS INTEGER
DIM u AS INTEGER
DIM Neck_LR_Angle AS INTEGER
DIM	Neck_UD_Angle AS INTEGER
DIM ELEVEN AS BYTE
DIM ELEVEN_ROUND AS BYTE
DIM XAngle AS BYTE
DIM YAngle AS BYTE
DIM 샷강도 AS BYTE

'**************************************************

PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번
DIR G6D,0,1,1,0,1,1		'모터18~23번
DIR G6B,1,1,1,1,1,1		'모터6~11번
DIR G6C,0,0,0,1,1,0		'모터12~17번

'************************************************

OUT 52,0	'머리 LED 켜기
'***** 초기선언 '************************************************

보행순서 = 0
반전체크 = 0
기울기확인횟수 = 0
보행횟수 = 1
모터ONOFF = 0
TRUE = 1
FALSE = 0

'****초기위치 피드백*****************************


TEMPO 230
MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16

GOSUB 전원초기자세
GOSUB 기본자세


'GOSUB 자이로INIT
'GOSUB 자이로MID
'GOSUB 자이로ON

NO_0 = 0
NO_1 = 0
NO_2 = 0
NO_3 = 0
NO_4 = 0


isWalk = 0
isAroundLR = 0
isShot = 0
isNeckDown = 0
isBodyRotate = 0
isNeckDownEff = 0
isWalkTwo = 0
isRoundHoleCheck = 0
isLeft = 0
isRound = 0

CC = 0
xx = 0
First = 0
Second = 0
ABS = 0
u = 10
SEVENTEEN = 100
FIFTEEN = 100
SERVO_SIXTEEN = 100
Neck_LR_Angle = 100
Neck_UD_Angle = 100
FORNUM = 0
SIXTEEN = 100
ELEVEN = 100
Loop = 0
BOOLEAN = 10
ELEVEN_ROUND = 100
XAngle = 100
YAngle = 39

샷강도= 15


PRINT "VOLUME 200 !"
'PRINT "SOUND 12 !" '안녕하세요

GOSUB All_motor_mode3

SPEED 5

SERVO 16, 39

SERVO 11, 100

GOTO MAIN	'시리얼 수신 루틴으로


'************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,1,1

    RETURN
    '************************************************
    '******************************************
앞뒤기울기측정:
    FOR i = 0 TO COUNT_MAX
        A = AD(앞뒤기울기AD포트)	'기울기 앞뒤
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF A < MIN THEN
        GOSUB 기울기앞
    ELSEIF A > MAX THEN
        GOSUB 기울기뒤
    ENDIF

    RETURN
    '**************************************************
기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN
        ETX  4800,15
        GOSUB 뒤로일어나기

    ENDIF
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN
        ETX  4800,15
        GOSUB 앞으로일어나기

    ENDIF
    RETURN
    '**************************************************
좌우기울기측정:
    FOR i = 0 TO COUNT_MAX
        B = AD(좌우기울기AD포트)	'기울기 좌우
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB 기본자세	
    ENDIF
    RETURN
    '******************************************

    '************************************************
뒤로일어나기:
    ERX 4800, First,뒤로일어나기

    SERVO 16, First

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB 자이로OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB 기본자세

    MOVE G6A,90, 130, 120,  80, 110,
    MOVE G6D,90, 130, 120,  80, 110,
    MOVE G6B,150, 160,  10, 100, 100,
    MOVE G6C,150, 160,  10, 190, 100,
    WAIT

    MOVE G6B,185, 160,  10, 100, 100,
    MOVE G6C,185, 160,  10, 190, 100,
    WAIT

    SPEED 12
    MOVE G6B,185,  50, 10,  100, 100,
    MOVE G6C,185,  50, 10,  190, 100,
    WAIT

    SPEED 10
    MOVE G6A, 80, 155,  80, 150, 150,
    MOVE G6D, 80, 155,  80, 150, 150,
    MOVE G6B,185,  20, 50,  100, 100,
    MOVE G6C,185,  20, 50,  190, 100,
    WAIT

    MOVE G6A, 75, 162,  55, 162, 155,
    MOVE G6D, 75, 162,  55, 162, 155,
    MOVE G6B,188,  10, 100, 100, 100,
    MOVE G6C,188,  10, 100, 190, 100,
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145,
    MOVE G6D, 60, 162,  30, 162, 145,
    MOVE G6B,170,  10, 100, 100, 100,
    MOVE G6C,170,  10, 100, 190, 100,
    WAIT

    DELAY 200


    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140,
    MOVE G6D, 60, 150,  28, 155, 140,
    MOVE G6B,150,  60,  90, 100, 100,
    MOVE G6C,150,  60,  90, 190, 100,
    WAIT

    MOVE G6A,100, 150,  28, 140, 100,
    MOVE G6D,100, 150,  28, 140, 100,
    MOVE G6B,130,  50,  85, 100, 100,
    MOVE G6C,130,  50,  85, 190, 100,
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10
    GOSUB 기본자세

    넘어진확인 = 1

    DELAY 200
    GOSUB 자이로ON

    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************


    '**********************************************
앞으로일어나기:
    ERX 4800, First,앞으로일어나기

    SERVO 16, First

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB 자이로OFF

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset

    SPEED 15
    MOVE G6A,100, 35,  70, 130, 100,
    MOVE G6D,100, 35,  70, 130, 100,
    MOVE G6B,15,  140,  15
    MOVE G6C,15,  140,  15
    WAIT

    SPEED 12
    MOVE G6B,15,  100,  10
    MOVE G6C,15,  100,  10
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,15,  15,  75
    MOVE G6C,15,  15,  75
    WAIT

    SPEED 10
    MOVE G6A,100, 165,  75, 20, 100,
    MOVE G6D,100, 165,  75, 20, 100,
    MOVE G6B,15,  20,  95
    MOVE G6C,15,  20,  95
    WAIT

    DELAY 200

    GOSUB Leg_motor_mode3

    SPEED 8
    MOVE G6A,100, 165,  85, 20, 100,
    MOVE G6D,100, 165,  85, 20, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 8
    MOVE G6A,100, 165,  85, 30, 100,
    MOVE G6D,100, 165,  85, 30, 100,
    WAIT

    SPEED 8
    MOVE G6A,100, 155,  45, 110, 100,
    MOVE G6D,100, 155,  45, 110, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 6
    MOVE G6A,100, 145,  45, 130, 100,
    MOVE G6D,100, 145,  45, 130, 100,
    WAIT


    SPEED 8
    GOSUB All_motor_mode2
    GOSUB 기본자세
    넘어진확인 = 1

    '******************************
    DELAY 200
    GOSUB 자이로ON
    RETURN

    '******************************************

    '******************************************
골프_민초파피샷1:

    ERX 4800, 샷강도, 골프_민초파피샷1

    SPEED 8

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    MOVE G6C, ,  ,  ,  ,  39
    WAIT

    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT
    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 109,  53,  81,  ,  ,
    WAIT
    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 155,  32,  81,  ,  ,
    WAIT
    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  35,  90,  ,  ,
    MOVE G6C, 153,  88,  10,  120,  ,
    WAIT
    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  35,  90,  ,  ,
    MOVE G6C, 157, 145,  30,  120,  ,
    WAIT
    DELAY 1000

    SPEED 샷강도
    'SPEED 3

    'HIGHSPEED SETON

    'MOVE G6A,  94,  60, 152, 122, 108,
    'MOVE G6D,  87,  59, 154, 120, 112,
    'MOVE G6B, 100,  35,  90,  ,  ,
    'MOVE G6C, 154, 90,  27,  70,  ,

    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  35,  90,  ,  ,
    MOVE G6C, 157,  77,  27,  10,  ,

    'MOVE G6A,  94,  60, 152, 122, 108,
    'MOVE G6D,  87,  59, 154, 120, 112,
    'MOVE G6B, 100,  35,  90,  ,  ,
    'MOVE G6C, 154,  65,  30,  10,  ,

    MOVE G6C, 157,  45,  30,  10,  ,

    WAIT
    DELAY 1000

    'HIGHSPEED SETOFF

    SPEED 8

    MOVE G6C, 157,  77,  27,  10,  ,
    WAIT

    MOVE G6C, 157,  77,  27,  120,  ,
    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100	'차렷
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOSUB 기본자세

    ETX 4800, 50

    GOTO RX_EXIT

골프_민초파피샷2:

    ERX 4800, 샷강도, 골프_민초파피샷2

    SPEED 8

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    MOVE G6C, ,  ,  ,  ,  39
    WAIT

    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6C, 109,  53,  81,  ,  ,
    WAIT


    MOVE G6C, 190,  53,  81,  ,  ,
    WAIT

    MOVE G6C, 190,  32,  10,  20,  ,
    WAIT

    MOVE G6B, 100,  35,  90,  ,  ,
    MOVE G6C, 157,  20,  10,  20,  ,
    WAIT

    MOVE G6C, 157,  20,  10,  20,  ,
    WAIT
    DELAY 1000

    SPEED 샷강도
    'SPEED 15

    'HIGHSPEED SETON

    MOVE G6C, 157,  77,  27,  10,  ,

    'MOVE G6A,  94,  60, 152, 122, 108,
    'MOVE G6D,  87,  59, 154, 120, 112,
    'MOVE G6B, 100,  35,  90,  ,  ,
    'MOVE G6C, 154,  65,  30,  10,  ,

    MOVE G6C, 157,  145,  30,  10,  ,

    WAIT
    DELAY 1000

    'HIGHSPEED SETOFF

    SPEED 8

    MOVE G6C, 154,  145,  27,  10,  ,
    WAIT

    MOVE G6C, 154,  145,  27,  120,  ,
    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100	'차렷
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOSUB 기본자세

    ETX 4800, 50

    GOTO RX_EXIT

골프_민초파피샷3:

    ERX 4800, 샷강도, 골프_민초파피샷3

    SPEED 8

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    MOVE G6C, ,  ,  ,  ,  39
    WAIT

    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT
    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 109,  53,  81,  ,  ,
    WAIT
    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 155,  32,  81,  ,  ,
    WAIT
    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  35,  90,  ,  ,
    MOVE G6C, 153,  88,  10,  120,  ,
    WAIT
    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  35,  90,  ,  ,
    MOVE G6C, 157, 145,  30,  120,  ,
    WAIT
    DELAY 1000

    SPEED 샷강도
    'SPEED 3

    HIGHSPEED SETON

    'MOVE G6A,  94,  60, 152, 122, 108,
    'MOVE G6D,  87,  59, 154, 120, 112,
    'MOVE G6B, 100,  35,  90,  ,  ,
    'MOVE G6C, 154, 90,  27,  70,  ,

    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  35,  90,  ,  ,
    MOVE G6C, 157,  77,  27,  10,  ,

    'MOVE G6A,  94,  60, 152, 122, 108,
    'MOVE G6D,  87,  59, 154, 120, 112,
    'MOVE G6B, 100,  35,  90,  ,  ,
    'MOVE G6C, 154,  65,  30,  10,  ,

    MOVE G6C, 157,  45,  30,  10,  ,

    WAIT
    DELAY 1000

    HIGHSPEED SETOFF

    SPEED 8

    MOVE G6C, 157,  77,  27,  10,  ,
    WAIT

    MOVE G6C, 157,  77,  27,  120,  ,
    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100	'차렷
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOSUB 기본자세

    ETX 4800, 50

    GOTO RX_EXIT

골프_민초파피샷4:

    ERX 4800, 샷강도, 골프_민초파피샷4

    SPEED 8

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    MOVE G6C, ,  ,  ,  ,  39
    WAIT

    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT


    MOVE G6C, 109,  53,  81,  ,  ,
    WAIT


    MOVE G6C, 190,  53,  81,  ,  ,
    WAIT

    MOVE G6C, 190,  32,  10,  20,  ,
    WAIT

    MOVE G6B, 100,  35,  90,  ,  ,
    MOVE G6C, 157,  20,  10,  20,  ,
    WAIT

    MOVE G6C, 157,  20,  10,  20,  ,
    WAIT
    DELAY 1000

    SPEED 샷강도
    'SPEED 15

    HIGHSPEED SETON

    MOVE G6C, 157,  77,  27,  10,  ,

    'MOVE G6A,  94,  60, 152, 122, 108,
    'MOVE G6D,  87,  59, 154, 120, 112,
    'MOVE G6B, 100,  35,  90,  ,  ,
    'MOVE G6C, 154,  65,  30,  10,  ,

    MOVE G6C, 157,  145,  30,  10,  ,

    WAIT
    DELAY 1000

    HIGHSPEED SETOFF

    SPEED 8

    MOVE G6C, 154,  145,  27,  10,  ,
    WAIT

    MOVE G6C, 154,  145,  27,  120,  ,
    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100	'차렷
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOSUB 기본자세

    ETX 4800, 50

    GOTO RX_EXIT

골프_민초파피샷:

    SPEED 8

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    MOVE G6C, ,  ,  ,  ,  39
    WAIT

    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT
    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 109,  53,  81,  ,  ,
    WAIT
    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 155,  32,  81,  ,  ,
    WAIT
    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  35,  90,  ,  ,
    MOVE G6C, 153,  88,  10,  120,  ,
    WAIT
    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  35,  90,  ,  ,
    MOVE G6C, 157, 145,  30,  120,  ,
    WAIT
    DELAY 1000

    SPEED 6

    'HIGHSPEED SETON

    'MOVE G6A,  94,  60, 152, 122, 108,
    'MOVE G6D,  87,  59, 154, 120, 112,
    'MOVE G6B, 100,  35,  90,  ,  ,
    'MOVE G6C, 154, 90,  27,  70,  ,

    MOVE G6A,  94,  60, 152, 122, 108,
    MOVE G6D,  87,  59, 154, 120, 112,
    MOVE G6B, 100,  35,  90,  ,  ,
    MOVE G6C, 157,  77,  27,  10,  ,

    'MOVE G6A,  94,  60, 152, 122, 108,
    'MOVE G6D,  87,  59, 154, 120, 112,
    'MOVE G6B, 100,  35,  90,  ,  ,
    'MOVE G6C, 154,  65,  30,  10,  ,

    MOVE G6C, 157,  45,  30,  10,  ,

    WAIT
    DELAY 1000

    'HIGHSPEED SETOFF

    SPEED 8

    MOVE G6C, 157,  77,  27,  10,  ,
    WAIT

    MOVE G6C, 157,  77,  27,  120,  ,
    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100	'차렷
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOSUB 기본자세

    ETX 4800, 50

    GOTO RX_EXIT

    '******************************************

세레머니:
    GOSUB All_motor_mode3

    SPEED 15

    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    MOVE G6B,100,  30,  120,
    MOVE G6C,100,  190,  100, 10,  130
    WAIT
    'SPEED 15
    'HIGHSPEED SETON

    'MOVE G6A,100,  190, 190,  50, 100, 100
    'MOVE G6D,100,  190, 190,  50, 100, 100

    'HIGHSPEED SETOFF

    GOTO RX_EXIT


걷기:
    GOSUB All_motor_mode3

    SPEED 15

    'MOVE G6D,101,  76, 147,  93, 98
    'MOVE G6A,95,  76, 147,  93, 101
    'MOVE G6B,100
    'MOVE G6C,100
    'WAIT

    'MOVE G6D,103,  76, 146,  93,  102
    'MOVE G6A,95,  90, 125, 100, 104
    'MOVE G6B, 90
    'MOVE G6C,115
    'WAIT

    'MOVE G6D, 90,  93, 146,  75, 102
    'MOVE G6A,107,   73, 140, 103,  100
    'WAIT

    'MOVE G6D,93,  90, 125, 95, 104
    'MOVE G6A,107,  76, 145,  91,  102
    'MOVE G6C, 100
    'MOVE G6B,100
    'WAIT


    'MOVE G6D,93,  76, 147,  93, 101
    'MOVE G6A,104,  76, 147,  93, 98
    'MOVE G6B,100
    'MOVE G6C,100
    'WAIT

    'MOVE G6D,95,  88, 125, 103, 104
    'MOVE G6A,107,  76, 146,  93,  102
    'MOVE G6C, 85
    'MOVE G6B,110
    'WAIT

    'MOVE G6D,102,    74, 140, 103,  100
    'MOVE G6A, 97,  83, 146,  85, 102
    'WAIT

    'MOVE G6D,104,  76, 145,  91,  102
    'MOVE G6A,97,  90, 130, 95, 104
    'MOVE G6B, 100
    'MOVE G6C,100
    'WAIT

    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6D,103,  76, 146,  93,  102
    MOVE G6A,95,  90, 130, 100, 104
    MOVE G6B, 90
    MOVE G6C,115
    WAIT

    MOVE G6D, 90,  93, 146,  75, 102
    MOVE G6A,109,   73, 140, 103,  100
    WAIT

    MOVE G6D,93,  90, 125, 95, 104
    MOVE G6A,109,  76, 145,  91,  102
    MOVE G6C,100
    MOVE G6B,100
    WAIT


    MOVE G6D,93,  76, 147,  93, 101
    MOVE G6A,104,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6D,95,  88, 125, 103, 104
    MOVE G6A,109,  76, 146,  93,  102
    MOVE G6C, 85
    MOVE G6B,110
    WAIT

    MOVE G6D,102,    74, 140, 103,  100
    MOVE G6A, 97,  83, 146,  85, 102
    WAIT

    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6A,97,  90, 130, 95, 104
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT

    ETX 4800, 54

    GOTO RX_EXIT

걷기_2:
    GOSUB All_motor_mode3

    SPEED 15

    MOVE G6D,93,  76, 147,  93, 101
    MOVE G6A,104,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6D,95,  88, 125, 103, 104
    MOVE G6A,107,  76, 146,  93,  102
    MOVE G6C, 85
    MOVE G6B,110
    WAIT

    MOVE G6D,102,  71, 140, 113, 100
    MOVE G6A, 97,  83, 146,  85, 102
    WAIT

    'MOVE G6D,102,    74, 140, 103,  100
    'MOVE G6A, 97,  83, 146,  85, 102
    'WAIT

    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6A,97,  90, 130, 95, 104
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6D,103,  76, 146,  93,  102
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6B, 90
    MOVE G6C,115
    WAIT

    MOVE G6D, 100,  89, 146,  80, 102
    MOVE G6A,107,   75, 140, 90,  100
    WAIT

    'MOVE G6D, 90,  93, 146,  95, 102
    'MOVE G6A,107,   75, 140, 90,  100
    'WAIT

    MOVE G6D,93,  76, 145, 95, 104
    MOVE G6A,107,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT

    'MOVE G6D,93,  76, 147,  93, 101
    'MOVE G6A,103,  76, 147,  93, 99
    'MOVE G6B,100
    'MOVE G6C,100
    'WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT

    ETX 4800, 54

    GOTO RX_EXIT



무한루프걷기:
    GOSUB All_motor_mode3

    SPEED 15

    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6D,103,  76, 146,  93,  102
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6B, 90
    MOVE G6C,115
    WAIT

    MOVE G6D, 90,  93, 146,  75, 102
    MOVE G6A,107,   73, 140, 103,  100
    WAIT

    MOVE G6D,93,  90, 125, 95, 104
    MOVE G6A,107,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT


    MOVE G6D,93,  76, 147,  93, 101
    MOVE G6A,104,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6D,95,  88, 125, 103, 104
    MOVE G6A,107,  76, 146,  93,  102
    MOVE G6C, 85
    MOVE G6B,110
    WAIT

    MOVE G6D,102,    74, 140, 103,  100
    MOVE G6A, 97,  83, 146,  85, 102
    WAIT

    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6A,97,  90, 130, 95, 104
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    GOSUB 기본자세

    ETX 4800, 54

    GOTO RX_EXIT

걷기_역순:
    SPEED 15

    MOVE G6D,104,  76, 145,  95,  102
    MOVE G6A,93,  90, 120, 95, 104
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    MOVE G6D,102,    74, 140, 103,  100
    MOVE G6A, 97,  83, 146,  85, 102
    WAIT

    MOVE G6D,95,  88, 125, 103, 104
    MOVE G6A,107,  76, 146,  93,  102
    MOVE G6C, 85
    MOVE G6B,110
    WAIT

    MOVE G6D,93,  76, 147,  93, 101
    MOVE G6A,104,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6D,93,  90, 125, 95, 104
    MOVE G6A,107,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT

    MOVE G6D, 90,  93, 146,  75, 102
    MOVE G6A,107,   73, 140, 103,  100
    WAIT

    MOVE G6D,103,  76, 146,  93,  102
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6B, 90
    MOVE G6C,115
    WAIT

    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    IF First = 254 THEN
        ETX 4800, 51
    ELSE
        ETX 4800, 54
    ENDIF

    GOSUB 기본자세

    GOTO RX_EXIT

걷기_오른:

    SPEED 15

    '원본
    'MOVE G6A,  99,  76, 145,  93, 100,
    'MOVE G6D,  88,  76, 145,  93, 112,
    'MOVE G6B, 100,  30,  80,  ,  ,
    'MOVE G6C, 100,  30,  80,  ,  ,
    'WAIT

    '지원 세이브본
    'MOVE G6A,  99,  76, 145,  93, 100,
    'MOVE G6D,  89,  76, 145,  92, 111,
    'MOVE G6B, 100,  30,  80,  ,  ,
    'MOVE G6C, 100,  30,  80,  ,  ,
    'WAIT

    MOVE G6A,  99,  76, 145,  93, 100,
    MOVE G6D,  89,  76, 145,  93, 111,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    '원본
    'MOVE G6A,  93,  61, 172,  80, 100,
    'MOVE G6D,  89,  76, 145,  93, 111,
    'MOVE G6B, 100,  30,  80,  ,  ,
    'MOVE G6C, 100,  30,  80,  ,  ,
    'WAIT

    '지원 세이브본
    'MOVE G6A,  93,  58, 172,  80, 100,
    'MOVE G6D,  89,  76, 145,  90, 111,
    'MOVE G6B, 100,  30,  80,  ,  ,
    'MOVE G6C, 100,  30,  80,  ,  ,
    'WAIT

    MOVE G6A,  75,  72, 155,  83, 100,
    MOVE G6D,  99,  76, 145,  93, 111,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    '원본
    'MOVE G6A,  80,  74, 155,  83, 100,
    'MOVE G6D,  99,  76, 145,  93, 111,
    'MOVE G6B, 100,  30,  80,  ,  ,
    'MOVE G6C, 100,  30,  80,  ,  ,
    'WAIT

    '지원 세이브본
    'MOVE G6A,  80,  76, 155,  82, 100,
    'MOVE G6D,  99,  81, 145,  85, 111,
    'MOVE G6B, 100,  30,  80,  ,  ,
    'MOVE G6C, 100,  30,  80,  ,  ,
    'WAIT

    'MOVE G6A,  80,  66, 155,  87, 100,
    'MOVE G6D,  99,  76, 145,  90, 111,
    'MOVE G6B, 100,  30,  80,  ,  ,
    'MOVE G6C, 100,  30,  80,  ,  ,
    'WAIT

    MOVE G6A,  85,  64, 165,  79, 100,
    MOVE G6D, 104,  81, 140,  90, 111,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT			''바꿔야됨.

    MOVE G6A,  85,  73, 155,  77, 100,
    MOVE G6D, 104,  81, 140,  90, 111,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,



    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 144,  93, 100, 100
    MOVE G6B,100,  30,  80, , , 100
    MOVE G6C,100,  30,  80, 190
    WAIT

    ETX 4800, 57

    GOTO RX_EXIT

오른쪽옆으로70연속_골프:
    MOTORMODE G6A,3,3,2,3,2
    MOTORMODE G6D,3,3,2,3,2

    DELAY  10

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,103,  77, 147,  93, 107, 100
    WAIT

    SPEED 13
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,83,  77, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6D,98,  77, 147,  93, 100, 100
    MOVE G6A,98,  77, 147,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    WAIT


    SPEED 3

    GOTO RX_EXIT



걷기_왼:
    MOTORMODE G6A,2,2,2,2,1
    MOTORMODE G6D,2,2,2,2,1

    SPEED 15
    MOVE G6A,  89,  76, 145,  93, 111, 		' 왼다리
    MOVE G6D,  95,  76, 145,  93, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  89,  76, 145,  93, 116,
    MOVE G6D,  93,  61, 172,  80, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,  99,  76, 145,  93, 111,
    MOVE G6D,  80,  74, 155,  83, 95,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    GOSUB 기본자세

    ETX 4800, 57

    GOTO RX_EXIT

걷기_종종걸음:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON

    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,103,  76, 146,  93,  102
    MOVE G6B, 90
    MOVE G6C,115
    WAIT

    MOVE G6A,107,   73, 140, 103,  100
    MOVE G6D, 90,  83, 146,  85, 102
    WAIT

    MOVE G6A, 97,  83, 146,  85, 102
    MOVE G6D,102,    74, 140, 103,  100
    WAIT

    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0
    SPEED 5
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT

걷기_종종걸음_4발짝:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON

    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,103,  76, 146,  93,  102
    MOVE G6B, 90
    MOVE G6C,115
    WAIT

    MOVE G6A,107,   73, 140, 103,  100
    MOVE G6D, 90,  83, 146,  85, 102
    WAIT

    MOVE G6A, 97,  83, 146,  85, 102
    MOVE G6D,102,    74, 140, 103,  100
    WAIT

    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0
    SPEED 5
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT
    SPEED 7
    HIGHSPEED SETON

    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,103,  76, 146,  93,  102
    MOVE G6B, 90
    MOVE G6C,115
    WAIT

    MOVE G6A,107,   73, 140, 103,  100
    MOVE G6D, 90,  83, 146,  85, 102
    WAIT

    MOVE G6A, 97,  83, 146,  85, 102
    MOVE G6D,102,    74, 140, 103,  100
    WAIT

    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0
    SPEED 5
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT
    SPEED 7
    HIGHSPEED SETON

    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,103,  76, 146,  93,  102
    MOVE G6B, 90
    MOVE G6C,115
    WAIT

    MOVE G6A,107,   73, 140, 103,  100
    MOVE G6D, 90,  83, 146,  85, 102
    WAIT

    MOVE G6A, 97,  83, 146,  85, 102
    MOVE G6D,102,    74, 140, 103,  100
    WAIT

    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0
    SPEED 5
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT

    '**********************

전진종종걸음_골프_222:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON

    MOVE G6D,93,  76, 147,  93, 101
    MOVE G6A,104,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    GOTO 전진종종걸음_골프_4

전진종종걸음_골프_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,103,  76, 146,  93,  102
    MOVE G6B, 90
    MOVE G6C,115
    WAIT


전진종종걸음_골프_2:

    MOVE G6A,107,   73, 140, 103,  100
    MOVE G6D, 90,  83, 146,  85, 102
    WAIT

전진종종걸음_골프_2_stop:
    MOVE G6D,93,  90, 125, 95, 104
    MOVE G6A,107,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0
    SPEED 5
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    'DELAY 400
    GOTO RX_EXIT

    '*********************************

전진종종걸음_골프_4:
    MOVE G6D,95,  88, 125, 103, 104
    MOVE G6A,107,  76, 146,  93,  102
    MOVE G6C, 85
    MOVE G6B,110
    WAIT


전진종종걸음_골프_5:
    MOVE G6D,102,    74, 140, 103,  100
    MOVE G6A, 97,  83, 146,  85, 102
    WAIT

    GOTO 전진종종걸음_골프_1
    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0
    SPEED 5
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT
    'DELAY 400
    GOTO RX_EXIT

걷기_종종걸음_후진:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON

    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  76, 145,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    MOVE G6A, 103,  79, 140,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    MOVE G6A,95,   69, 147, 103,  102
    MOVE G6D, 104,  76, 140,  89, 100
    WAIT

    MOVE G6A,95,  85, 130, 100, 104
    MOVE G6D,104,  77, 146,  93,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0
    SPEED 5
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT

걷기_종종걸음_후진2:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON

    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  76, 145,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    MOVE G6D,95,  85, 130, 100, 104
    MOVE G6A,104,  77, 146,  93,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT

    HIGHSPEED SETOFF


    SPEED 15
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT

    mode = 0
    SPEED 5
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT

우회전30: '90도 회전시 9~10회

    'MOTORMODE G6A,1,1,1,1,1
    'MOTORMODE G6D,1,1,1,1,1

    SPEED 7	
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,91,  86, 145,  83, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,,  40,  90,
    MOVE G6C,,  40,  90,
    WAIT

    'GOSUB All_motor_mode3
    'SPEED 4
    'MOVE G6A,100,  76, 145,  93, 100, 100
    'MOVE G6D,100,  76, 145,  93, 100, 100

    'WAIT
    'DELAY 500
    SPEED 6

    GOSUB 기본자세

    RETURN

좌회전30: '90도 회전시 16회
    'MOTORMODE G6A,2,2,2,2,1
    'MOTORMODE G6D,2,2,2,2,1

    SPEED 5
    MOVE G6A,100,  86, 145,  83, 106, 100
    MOVE G6D,94,  66, 145, 103, 100, 100
    WAIT

    'MOVE G6A,100,  86, 145,  83, 106, 100
    'MOVE G6D,94,  66, 145, 103, 100, 100

    SPEED 15
    MOVE G6A,95,  86, 145,  83, 104, 100
    MOVE G6D,91,  66, 145, 103, 96, 100
    WAIT

    SPEED 8
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  40,  90,
    MOVE G6C,100,  40,  90,
    WAIT

    GOSUB 기본자세

    RETURN

우회전_루프: '90도 회전시 9~10회

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    FOR i = 0 TO 20

        SPEED 5
        MOVE G6A,100,  86, 145,  83, 106, 100
        MOVE G6D,94,  66, 145, 103, 100, 100
        WAIT

        SPEED 12
        MOVE G6A,97,  86, 145,  83, 104, 100
        MOVE G6D,91,  66, 145, 103, 96, 100
        WAIT

        SPEED 6
        MOVE G6A,101,  76, 146,  93, 98, 100
        MOVE G6D,101,  76, 146,  93, 98, 100
        WAIT

        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  30,  80,
        MOVE G6C,100,  30,  80, 190
        WAIT

        mode = 0

    NEXT i

    ETX 4800, 58

    GOTO RX_EXIT

좌회전_루프: '90도 회전시 16회
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    FOR i = 0 TO 21

        SPEED 5
        MOVE G6A,100,  86, 145,  83, 106, 100
        MOVE G6D,94,  66, 145, 103, 100, 100
        WAIT

        SPEED 12
        MOVE G6A,97,  86, 145,  83, 104, 100
        MOVE G6D,91,  66, 145, 103, 96, 100
        WAIT

        SPEED 6
        MOVE G6A,101,  76, 146,  93, 98, 100
        MOVE G6D,101,  76, 146,  93, 98, 100
        WAIT

        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  30,  80,
        MOVE G6C,100,  30,  80, 190
        WAIT

        mode = 0

    NEXT i

    ETX 4800, 58

    GOTO RX_EXIT

목상하:

    SPEED 5

    SERVO 11, 100

    SERVO 16, 75

    RETURN

목숙이기_대입:

    SPEED 5

    MOVE G6C, ,  ,  ,  ,  39
    WAIT

    ETX 4800, 51

    GOTO RX_EXIT

목숙이기_39:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    MOVE G6C, ,  ,  ,  ,  39
    WAIT

    ETX 4800,59

    GOTO RX_EXIT

목숙이기_75:
    SPEED 5

    MOVE G6C, ,  ,  ,  ,  75
    WAIT

    ETX 4800, 59

    GOTO RX_EXIT

목돌리기_X100Y75:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    MOVE G6C, ,  ,  ,  ,  75
    WAIT

    ETX 4800, 59

    GOTO RX_EXIT

목돌리기_X10Y75:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  10
    WAIT

    MOVE G6C, ,  ,  ,  ,  75
    WAIT

    ETX 4800, 59

    GOTO RX_EXIT

목돌리기_X100:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    ETX 4800,65

    GOTO RX_EXIT

목돌리기_X100Y100:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    MOVE G6C, ,  ,  ,  ,  100
    WAIT

    'ETX 4800,65

    GOTO RX_EXIT

목돌리기_X55Y55:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  55
    WAIT

    MOVE G6C, ,  ,  ,  ,  55
    WAIT

    'ETX 4800,65

    GOTO RX_EXIT

목돌리기_X145Y55:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  145
    WAIT

    MOVE G6C, ,  ,  ,  ,  55
    WAIT

    'ETX 4800,65

    GOTO RX_EXIT

목돌리기_X190Y75:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  190
    WAIT

    MOVE G6C, ,  ,  ,  ,  75
    WAIT

    'ETX 4800,65

    GOTO RX_EXIT

목돌리기_X10:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  10
    WAIT

    ETX 4800, 61

    GOTO RX_EXIT

목돌리기_X70:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  70
    WAIT

    'ETX 4800, 60

    GOTO RX_EXIT

목돌리기_X40:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  40
    WAIT

    'ETX 4800, 62

    GOTO RX_EXIT

목돌리기_X190:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  190
    WAIT

    ETX 4800, 63

    GOTO RX_EXIT

목돌리기_X130:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  130
    WAIT

    'ETX 4800, 63

    GOTO RX_EXIT

목돌리기_X160:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  160
    WAIT

    'ETX 4800, 63

    GOTO RX_EXIT

    '    MOVE G6C, ,  ,  ,  ,  75
    '    WAIT

목돌리기_XY10씩:
    XAngle = XAngle - 6
    YAngle = YAngle + 1

    SPEED 5

    SERVO 11, XAngle
    SERVO 16, YAngle
    WAIT

    'ETX 4800, 63

    GOTO RX_EXIT

목돌리기_XY10마이너스씩:
    XAngle = XAngle + 6
    YAngle = YAngle - 1

    SPEED 5

    SERVO 11, XAngle
    SERVO 16, YAngle
    WAIT

    'ETX 4800, 63

    GOTO RX_EXIT

몸돌리기_하나:
    ERX 4800, Second, 몸돌리기_하나
    SPEED 1
    GOTO 몸돌리기_둘

몸돌리기_둘:
    ERX 4800, ABS, 몸돌리기_둘
    FORNUM = Second / 15

    IF ABS = 1 THEN
        FOR i = 0 TO FORNUM
            GOSUB 우회전30
        NEXT i
    ELSE
        FOR i = 0 TO FORNUM
            GOSUB 좌회전30
        NEXT i

    ENDIF

    ETX 4800, 52

    GOTO RX_EXIT

공추적_하나:

    ERX 4800, First, 공추적_하나

    GOTO 공추적_둘

공추적_둘:

    ERX 4800, ABS, 공추적_둘

    IF ABS = 0 THEN
        SERVO_SIXTEEN = SERVO_SIXTEEN - First
    ELSEIF ABS = 1 THEN
        SERVO_SIXTEEN = SERVO_SIXTEEN + First
    ENDIF

    SPEED 1

    SERVO 16, SERVO_SIXTEEN

    ETX 4800, 53

    GOTO RX_EXIT

날개펼치기:
    SPEED 15
    MOVE G6C, , ,  ,  80,  ,
    WAIT

    'ETX 4800, 53

    GOTO RX_EXIT

골프_오른쪽으로_어드레스1:

    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT


    MOVE G6C,135,  40,  40, 10
    WAIT

    MOVE G6C,135,  10,  80, 10
    WAIT

    GOTO RX_EXIT

오른쪽옆으로20_골프: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 107, 100
    MOVE G6A,107,  77, 147,  93, 117 , 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 12
    MOVE G6D,95,  76, 147,  93, 98, 100
    MOVE G6A,95,  76, 147,  93, 98, 100
    WAIT

    SPEED 3
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    mode = 0

    ETX 4800, 57

    GOTO RX_EXIT

오른쪽옆으로10연속_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 97,  90, 123, 100, 104, 100
    MOVE G6A,104,  76, 144,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 103,  76, 144, 93, 100, 100
    MOVE G6A,  90,  80, 138, 95, 104, 100
    WAIT

    SPEED 12
    MOVE G6D,98,  76, 144,  93, 98, 100
    MOVE G6A,98,  76, 144,  93, 98, 100
    WAIT

    SPEED 3
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT

왼쪽옆으로20_골프: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 107, 100
    MOVE G6D,105,  76, 146,  93, 117, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  76, 146, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 12
    MOVE G6A,95,  76, 146,  93, 98, 100
    MOVE G6D,95,  76, 146,  93, 98, 100
    WAIT

    SPEED 3
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    mode = 0

    ETX 4800, 57

    GOTO RX_EXIT

왼쪽옆으로10연속_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 105, 100
    MOVE G6D,105,  76, 146,  93, 105, 100
    WAIT

    SPEED 12

    MOVE G6A, 102,  76, 146, 93, 100, 100
    MOVE G6D,  90,  80, 140, 95, 107, 100
    WAIT

    SPEED 12
    MOVE G6D,98,  76, 144,  93, 98, 100
    MOVE G6A,98,  76, 144,  93, 98, 100
    WAIT

    SPEED 3
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOTO RX_EXIT

왼쪽턴5_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 5
    MOVE G6A,100,  81, 145,  88, 106, 100
    MOVE G6D,94,  71, 145, 98, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,97,  81, 145,  88, 104, 100
    MOVE G6D,91,  71, 145, 98, 96, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    'SPEED 5
    'MOVE G6A,100,  81, 145,  88, 106, 100
    'MOVE G6D,94,  71, 145, 98, 100, 100
    'WAIT

    'SPEED 12
    'MOVE G6A,97,  81, 145,  88, 104, 100
    'MOVE G6D,91,  71, 145, 98, 96, 100
    'WAIT

    'SPEED 6
    'MOVE G6A,101,  76, 146,  93, 98, 100
    'MOVE G6D,101,  76, 146,  93, 98, 100
    'WAIT

    'MOVE G6A,100,  76, 145,  93, 100, 100
    'MOVE G6D,100,  76, 145,  93, 100, 100
    'MOVE G6B,100,  30,  80,
    'MOVE G6C,100,  30,  80, 190
    'WAIT

    mode = 0

    GOTO RX_EXIT
    '**********************************************
오른쪽턴5_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 5
    MOVE G6A,93,  72, 145,  99, 107, 100
    MOVE G6D,93,  82, 145,  87, 107, 100
    WAIT

    '40회
    'MOVE G6A,95,  71, 145,  98, 107, 100
    'MOVE G6D,95,  81, 145,  88, 107, 100

    SPEED 12
    MOVE G6A,94,  71, 145,  98, 101, 100
    MOVE G6D,94,  81, 145,  88, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    'SPEED 5
    'MOVE G6A,97,  71, 145,  98, 103, 100
    'MOVE G6D,97,  81, 145,  88, 103, 100
    'WAIT

    'SPEED 12
    'MOVE G6A,94,  71, 145,  98, 101, 100
    'MOVE G6D,94,  81, 145,  88, 101, 100
    'WAIT

    'SPEED 6
    'MOVE G6A,101,  76, 146,  93, 98, 100
    'MOVE G6D,101,  76, 146,  93, 98, 100
    'WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    mode = 0

    GOTO RX_EXIT

왼쪽턴10_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 5
    MOVE G6A,100,  86, 145,  83, 106, 100
    MOVE G6D,94,  66, 145, 103, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,97,  86, 145,  83, 104, 100
    MOVE G6D,91,  66, 145, 103, 96, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    mode = 0

    RETURN
    '**********************************************
오른쪽턴10_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    mode = 0

    RETURN

왼쪽턴20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    mode = 0

    GOTO RX_EXIT
    '**********************************************
오른쪽턴20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,100,  73, 145,  93, 100, 100
    MOVE G6D,100,  79, 145,  93, 100, 100
    WAIT


    SPEED 6
    MOVE G6A,100,  84, 145,  78, 100, 100
    MOVE G6D,100,  68, 145,  108, 100, 100
    WAIT

    SPEED 9
    MOVE G6A,90,  90, 145,  78, 102, 100
    MOVE G6D,104,  71, 145,  105, 100, 100
    WAIT
    SPEED 7
    MOVE G6A,90,  80, 130, 102, 104
    MOVE G6D,105,  76, 146,  93,  100
    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    mode = 0

    GOTO RX_EXIT

목돌려공찾기_좌우:

    ERX 4800, ELEVEN, 목돌려공찾기_좌우

    SPEED 5
    SERVO 11, ELEVEN

    ETX 4800, 51

    GOTO RX_EXIT

목돌려공찾기_좌우_2:

    ERX 4800, ELEVEN, 목돌려공찾기_좌우_2

    SPEED 5
    SERVO 11, ELEVEN

    ETX 4800, 56

    GOTO RX_EXIT


목돌려공찾기_좌우_3:

    ERX 4800, ELEVEN, 목돌려공찾기_좌우_3

    SPEED 5
    SERVO 11, ELEVEN
    WAIT

    ETX 4800, 56

    GOTO RX_EXIT

    '=========================================================
    '=========================================================

목돌려공찾기_상하:

    ERX 4800, SIXTEEN, 목돌려공찾기_상하

    SPEED 5
    SERVO 16, SIXTEEN

    ETX 4800, 51

    GOTO RX_EXIT

목돌려공찾기_상하_2:

    ERX 4800, SIXTEEN, 목돌려공찾기_상하_2

    SPEED 5
    SERVO 16, SIXTEEN

    ETX 4800, 56

    GOTO RX_EXIT

목돌려공찾기_좌우상하_하나:

    ERX 4800, ELEVEN, 목돌려공찾기_좌우상하_하나

    GOTO 목돌려공찾기_좌우상하_둘

목돌려공찾기_좌우상하_둘:

    ERX 4800, ELEVEN, 목돌려공찾기_좌우상하_둘

    GOTO 목돌려공찾기_좌우상하_셋

목돌려공찾기_좌우상하_셋:
    ERX 4800, SIXTEEN, 목돌려공찾기_좌우상하_셋

    SPEED 5
    SERVO 11, ELEVEN
    SERVO 16, SIXTEEN

    ETX 4800, 51

    GOTO RX_EXIT

목돌려공찾기_좌우상하_2_하나:

    ERX 4800, ELEVEN, 목돌려공찾기_좌우상하_2_하나

    GOTO 목돌려공찾기_좌우상하_2_둘

목돌려공찾기_좌우상하_2_둘:

    ERX 4800, ELEVEN, 목돌려공찾기_좌우상하_2_둘

    GOTO 목돌려공찾기_좌우상하_2_셋

목돌려공찾기_좌우상하_2_셋:
    ERX 4800, SIXTEEN, 목돌려공찾기_좌우상하_2_셋

    SPEED 5
    SERVO 11, ELEVEN
    SERVO 16, SIXTEEN

    ETX 4800, 56

    GOTO RX_EXIT

목돌려공찾기_좌우상하_3_하나:

    ERX 4800, ELEVEN, 목돌려공찾기_좌우상하_3_하나

    GOTO 목돌려공찾기_좌우상하_3_둘

목돌려공찾기_좌우상하_3_둘:

    ERX 4800, ELEVEN, 목돌려공찾기_좌우상하_3_둘

    GOTO 목돌려공찾기_좌우상하_3_셋

목돌려공찾기_좌우상하_3_셋:
    ERX 4800, SIXTEEN, 목돌려공찾기_좌우상하_3_셋

    SPEED 5
    SERVO 11, ELEVEN
    SERVO 16, SIXTEEN
    WAIT

    ETX 4800, 56

    GOTO RX_EXIT

    '=====================================

목읽어몸돌리기:

    ERX 4800, ELEVEN_ROUND, 목읽어몸돌리기									' 목좌우모터값을 읽어 저장한다.

    MOVE G6B, ,  ,  ,  ,  ,  100
    MOVE G6C, ,  ,  ,  ,  39
    WAIT

    IF ELEVEN_ROUND < 100 THEN
        BOOLEAN = 0
        ELEVEN_ROUND = 100 - ELEVEN_ROUND
    ELSEIF ELEVEN_ROUND > 100 THEN
        BOOLEAN = 1
        ELEVEN_ROUND = ELEVEN_ROUND - 100
    ELSE
        ELEVEN_ROUND = 0	
    ENDIF

    IF ELEVEN_ROUND = 0 THEN
        ELEVEN_ROUND = 100

    ELSE

        FORNUM = ELEVEN_ROUND / 5										' 몸을 돌릴 횟수를 정한다

        IF FORNUM = 0 THEN
            IF ELEVEN_ROUND > 3 THEN
                FORNUM = 1
            ENDIF
        ENDIF

        IF BOOLEAN = 1 THEN												' 부호에 따라
            FOR i = 1 TO FORNUM											' 방향을 정해 몸을 돌린다.
                GOSUB 오른쪽턴10_골프
            NEXT i
        ELSEIF BOOLEAN = 0 THEN
            FOR i = 1 TO FORNUM
                GOSUB 왼쪽턴10_골프
            NEXT i
        ENDIF

    ENDIF

    ETX 4800, 51		'eco										' 에코값을 송신한다

    GOTO RX_EXIT													'라벨을 종료하고 메인으로 돌아간다.

목읽어몸돌리기_2:

    ERX 4800, ELEVEN_ROUND, 목읽어몸돌리기									' 목좌우모터값을 읽어 저장한다.

    MOVE G6B, ,  ,  ,  ,  ,  100
    MOVE G6C, ,  ,  ,  ,  39
    WAIT

    IF ELEVEN_ROUND < 100 THEN
        BOOLEAN = 0
        ELEVEN_ROUND = 100 - ELEVEN_ROUND
    ELSEIF ELEVEN_ROUND > 100 THEN
        BOOLEAN = 1
        ELEVEN_ROUND = ELEVEN_ROUND - 100
    ELSE
        ELEVEN_ROUND = 0	
    ENDIF

    IF ELEVEN_ROUND = 0 THEN
        ELEVEN_ROUND = 100

    ELSE

        FORNUM = ELEVEN_ROUND / 5										' 몸을 돌릴 횟수를 정한다

        IF FORNUM = 0 THEN
            IF ELEVEN_ROUND > 3 THEN
                FORNUM = 1
            ENDIF
        ENDIF

        IF BOOLEAN = 1 THEN												' 부호에 따라
            FOR i = 1 TO FORNUM											' 방향을 정해 몸을 돌린다.
                GOSUB 오른쪽턴10_골프
            NEXT i
        ELSEIF BOOLEAN = 0 THEN
            FOR i = 1 TO FORNUM
                GOSUB 왼쪽턴10_골프
            NEXT i
        ENDIF

    ENDIF

    ETX 4800, 51		'eco										' 에코값을 송신한다

    GOTO RX_EXIT

목읽어몸돌리기3:

    ERX 4800, ELEVEN_ROUND, 목읽어몸돌리기3									' 목좌우모터값을 읽어 저장한다.

    GOTO 목읽어몸돌리기3_2

목읽어몸돌리기3_2:

    ERX 4800, SIXTEEN, 목읽어몸돌리기3_2		

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    SERVO 16, SIXTEEN
    WAIT

    IF ELEVEN_ROUND < 100 THEN
        BOOLEAN = 0
        ELEVEN_ROUND = 100 - ELEVEN_ROUND
    ELSEIF ELEVEN_ROUND > 100 THEN
        BOOLEAN = 1
        ELEVEN_ROUND = ELEVEN_ROUND - 100
    ELSE
        ELEVEN_ROUND = 0	
    ENDIF

    IF ELEVEN_ROUND = 0 THEN
        ELEVEN_ROUND = 100

    ELSE

        FORNUM = ELEVEN_ROUND / 5										' 몸을 돌릴 횟수를 정한다

        IF FORNUM = 0 THEN
            IF ELEVEN_ROUND > 3 THEN
                FORNUM = 1
            ENDIF
        ENDIF

        IF BOOLEAN = 1 THEN												' 부호에 따라
            FOR i = 1 TO FORNUM											' 방향을 정해 몸을 돌린다.
                GOSUB 오른쪽턴10_골프
            NEXT i
        ELSEIF BOOLEAN = 0 THEN
            FOR i = 1 TO FORNUM
                GOSUB 왼쪽턴10_골프
            NEXT i
        ENDIF

    ENDIF

    ETX 4800, 59		'eco										' 에코값을 송신한다

    GOTO RX_EXIT

목읽어몸돌리기4:
    ERX 4800, SIXTEEN, 목읽어몸돌리기4									' 목좌우모터값을 읽어 저장한다.	

    SERVO 16, SIXTEEN
    WAIT

    GOSUB 왼쪽턴10_골프

    ETX 4800, 56		'eco										' 에코값을 송신한다

    GOTO RX_EXIT

목읽어몸돌리기_X75:
    ERX 4800, ELEVEN_ROUND, 목읽어몸돌리기									' 목좌우모터값을 읽어 저장한다.

    MOVE G6B, ,  ,  ,  ,  ,  100
    MOVE G6C, ,  ,  ,  ,  75
    WAIT

    IF ELEVEN_ROUND < 100 THEN
        BOOLEAN = 0
        ELEVEN_ROUND = 100 - ELEVEN_ROUND
    ELSEIF ELEVEN_ROUND > 100 THEN
        BOOLEAN = 1
        ELEVEN_ROUND = ELEVEN_ROUND - 100
    ELSE
        ELEVEN_ROUND = 0	
    ENDIF

    IF ELEVEN_ROUND = 0 THEN
        ELEVEN_ROUND = 100

    ELSE

        FORNUM = ELEVEN_ROUND / 5										' 몸을 돌릴 횟수를 정한다

        IF FORNUM = 0 THEN
            IF ELEVEN_ROUND > 3 THEN
                FORNUM = 1
            ENDIF
        ENDIF

        IF BOOLEAN = 1 THEN												' 부호에 따라
            FOR i = 1 TO FORNUM											' 방향을 정해 몸을 돌린다.
                GOSUB 오른쪽턴10_골프
            NEXT i
        ELSEIF BOOLEAN = 0 THEN
            FOR i = 1 TO FORNUM
                GOSUB 왼쪽턴10_골프
            NEXT i
        ENDIF

    ENDIF

    GOTO RX_EXIT

목돌리기:

    SERVO 16, 100

    GOTO RX_EXIT

목돌리기2:

    SERVO 16, 39

    GOTO RX_EXIT

    '******************************************

전원초기자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0

    RETURN
    '************************************************

기본자세:
    SPEED 15

    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, , ,
    MOVE G6C,100,  30,  80, 190
    WAIT
    mode = 09

    '원본
    'MOVE G6A,100,  76, 145,  93, 100, 100
    'MOVE G6D,100,  76, 145,  93, 100, 100
    'MOVE G6B,100,  30,  80, , ,
    'MOVE G6C,100,  30,  80, 190
    'WAIT
    mode = 09

    RETURN
    '******************************************	

    '***********************************************
    '***********************************************
    '**** 자이로감도 설정 ****
자이로INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** 자이로감도 설정 ****
자이로MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
자이로MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
자이로MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '***********************************************
자이로ON:

    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    자이로ONOFF = 1

    RETURN
    '***********************************************
자이로OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    자이로ONOFF = 0
    RETURN

    '************************************************

MOTOR_ON: '전포트서보모터사용설정

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    모터ONOFF = 0

    GOSUB 시작음			

    RETURN

    '************************************************
    '위치값피드백
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,1,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************

All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,3,3

    RETURN
    '************************************************
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,2,2

    RETURN
    '************************************************

시작음:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
    '************************************************
종료음:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
    '******************************************
앉은자세:
    SPEED 5
    GOSUB 자이로OFF
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT
    mode = 1

    RETURN
    '******************************************
    '***********************************************
GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '**********************************************

    '**********************************************
RX_EXIT:

    ERX 4800, A, MAIN

    GOTO RX_EXIT
    '**********************************************

    '************************************************
    '전포트서보모터사용설정
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    모터ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB 종료음	
    RETURN
    '************************************************

일회용변수초기화:
    isAroundLR = 0
    isWalk = 0
    isShot = 0
    isNeckDown = 0
    isNeckChase = 0
    isBodyRotate = 0
    RETURN

MAIN: '라벨설정

    'ETX 4800, 38 ' 동작 멈춤 확인 송신값

MAIN_2:

    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정	

    A_old = A					' 현재 사용 X

    ERX 4800, A, MAIN_2

    '**** 입력된 A값이 0 이면 MAIN 라벨로 가고
    '**** 1이면 KEY1 라벨, 2이면 key2로... 가는문
    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15

    IF A = 250 THEN
        GOSUB All_motor_mode3
        SPEED 4
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  40,  90,
        MOVE G6C,100,  40,  90,
        WAIT
        DELAY 500
        SPEED 6
        GOSUB 기본자세

    ELSEIF A = 100 THEN
        GOTO 세레머니

    ELSEIF A = 101 THEN
        GOTO 목돌리기_X100

    ELSEIF A = 102 THEN			'샷 포트. 연결 완료.
        GOTO 골프_민초파피샷1

    ELSEIF A = 103 THEN			'고개를 들어 좌우로 고개 회전 포트. 미구현.
        GOTO 목숙이기_75

    ELSEIF A = 104 THEN			'걸어라.연결 완료
        GOTO 무한루프걷기

    ELSEIF A = 105 THEN			'공을 추적해라.
        GOTO 왼쪽옆으로20_골프															

    ELSEIF A = 106 THEN			'고개 숙여라.연결 완료
        GOTO 오른쪽옆으로20_골프																				

    ELSEIF A = 107 THEN			' 몸 돌려라.
        GOTO 걷기_종종걸음

    ELSEIF A = 108 THEN			' 목을 특정 각도로 돌려라
        GOTO 걷기_종종걸음_후진

    ELSEIF A = 109 THEN
        IF 보행횟수= 0 THEN
            보행횟수 = 1
            GOTO 걷기
        ELSE
            보행횟수 = 0
            GOTO 걷기_2
        ENDIF
        'GOTO 걷기

    ELSEIF A = 110 THEN
        GOTO 목숙이기_39																		

    ELSEIF A = 111 THEN
        GOTO 목돌리기_X100Y75																		

    ELSEIF A = 112 THEN
        GOTO 목돌려공찾기_좌우상하_2_둘

    ELSEIF A = 113 THEN
        GOTO 목돌려공찾기_좌우_2

    ELSEIF A = 114 THEN
        GOTO 목돌려공찾기_상하_2

    ELSEIF A = 115 THEN
        GOTO 목돌려공찾기_좌우상하_3_둘

    ELSEIF A = 116 THEN
        GOTO 목돌려공찾기_좌우_3

    ELSEIF A = 117 THEN
        GOTO 왼쪽옆으로10연속_골프

    ELSEIF A = 118 THEN
        GOTO 오른쪽옆으로10연속_골프

    ELSEIF A = 119 THEN
        GOTO 목돌리기_X10Y75

    ELSEIF A = 120 THEN
        GOTO 목읽어몸돌리기

    ELSEIF A = 121 THEN
        GOTO 목돌려공찾기_좌우상하_둘

    ELSEIF A = 122 THEN
        GOTO 목돌려공찾기_좌우

    ELSEIF A = 123 THEN
        GOTO 목돌려공찾기_상하

    ELSEIF A = 124 THEN
        GOTO 목읽어몸돌리기_2

    ELSEIF A = 125 THEN
        GOTO 우회전_루프

    ELSEIF A = 126 THEN
        GOTO 좌회전_루프

    ELSEIF A = 127 THEN
        GOTO 목돌리기_X70

    ELSEIF A = 128 THEN
        GOTO 목돌리기_X10

    ELSEIF A = 129 THEN
        GOTO 목돌리기_X40

    ELSEIF A = 130 THEN
        GOTO 목돌리기_X190

    ELSEIF A = 131 THEN
        GOTO 날개펼치기

    ELSEIF A = 132 THEN
        GOTO 목돌리기_X130

    ELSEIF A = 133 THEN
        GOTO 목돌리기_X160

    ELSEIF A = 134 THEN
        GOTO 목돌리기_X100Y100

    ELSEIF A = 135 THEN
        SPEED 15
        MOVE G6C,,  ,  , 190
        WAIT
        GOTO RX_EXIT

    ELSEIF A = 136 THEN
        GOTO 목돌리기_X55Y55

    ELSEIF A = 137 THEN
        GOTO 목읽어몸돌리기_X75

    ELSEIF A = 138 THEN
        GOTO 목읽어몸돌리기3

    ELSEIF A = 139 THEN
        GOTO 골프_민초파피샷2

    ELSEIF A = 140 THEN
        GOTO 골프_민초파피샷3

    ELSEIF A = 141 THEN
        GOTO 골프_민초파피샷4

    ELSEIF A = 142 THEN
        GOTO 목돌리기_X145Y55

    ELSEIF A = 142 THEN
        GOTO 목돌리기_X190Y75

    ELSEIF A = 143 THEN
        GOTO 목읽어몸돌리기4

    ENDIF

    'GOSUB 기본자세

    GOTO MAIN	
    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************

KEY1:
    GOTO RX_EXIT

    '***************	
KEY2:
    GOTO 왼쪽턴20
    GOTO RX_EXIT

    '***************

KEY3:
    GOTO 오른쪽턴20

    GOTO RX_EXIT
    '***************
KEY4:

    GOTO 오른쪽턴5_골프

    GOTO RX_EXIT
    '***************
KEY5:

    GOSUB 앉은자세
    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF

    GOTO RX_EXIT
    '***************
KEY6:

    GOSUB 걷기_2

    GOTO RX_EXIT

    '***************
KEY7:
    ETX 4800,7

    GOTO RX_EXIT

    '***************
KEY8:

    GOTO 걷기

    GOTO RX_EXIT

    '***************

KEY9:
    GOTO 걷기_2

    GOTO RX_EXIT

KEY10:
    GOTO 걷기_오른

    GOTO RX_EXIT

KEY11:
    GOTO 걷기_왼

    GOTO RX_EXIT

KEY12:
    GOTO 걷기_종종걸음_후진

    GOTO RX_EXIT

KEY13:
    GOTO 왼쪽턴5_골프

    GOTO RX_EXIT

KEY14: '왼쪽화살표
    GOTO 왼쪽턴5_골프

    GOTO RX_EXIT

KEY15: 'A
    GOTO 세레머니

    GOTO RX_EXIT
