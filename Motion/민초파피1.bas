'******** 2�� ����κ� �ʱ� ���� ���α׷� ********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM �¿�ӵ�2 AS BYTE
DIM ������� AS BYTE
DIM �������� AS BYTE
DIM ����üũ AS BYTE
DIM ����ONOFF AS BYTE
DIM ���̷�ONOFF AS BYTE
DIM ����յ� AS INTEGER
DIM �����¿� AS INTEGER
DIM TRUE AS INTEGER
DIM FALSE AS INTEGER

DIM ����� AS BYTE

DIM �Ѿ���Ȯ�� AS BYTE
DIM ����Ȯ��Ƚ�� AS BYTE
DIM ����Ƚ�� AS BYTE
DIM ����COUNT AS BYTE

DIM ���ܼ��Ÿ���  AS BYTE

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

'**** ���⼾����Ʈ ���� ****
CONST �յڱ���AD��Ʈ = 0
CONST �¿����AD��Ʈ = 1
CONST ����Ȯ�νð� = 20  'ms

CONST ���ܼ�AD��Ʈ  = 4


CONST min = 61	'�ڷγѾ�������
CONST max = 107	'�����γѾ�������
CONST COUNT_MAX = 3

CONST x = 15



CONST �Ӹ��̵��ӵ� = 10
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
DIM ������ AS BYTE

'**************************************************

PTP SETON 				'�����׷캰 ���������� ����
PTP ALLON				'��ü���� ������ ���� ����

DIR G6A,1,0,0,1,0,0		'����0~5��
DIR G6D,0,1,1,0,1,1		'����18~23��
DIR G6B,1,1,1,1,1,1		'����6~11��
DIR G6C,0,0,0,1,1,0		'����12~17��

'************************************************

OUT 52,0	'�Ӹ� LED �ѱ�
'***** �ʱ⼱�� '************************************************

������� = 0
����üũ = 0
����Ȯ��Ƚ�� = 0
����Ƚ�� = 1
����ONOFF = 0
TRUE = 1
FALSE = 0

'****�ʱ���ġ �ǵ��*****************************


TEMPO 230
MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16

GOSUB �����ʱ��ڼ�
GOSUB �⺻�ڼ�


'GOSUB ���̷�INIT
'GOSUB ���̷�MID
'GOSUB ���̷�ON

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

������= 15


PRINT "VOLUME 200 !"
'PRINT "SOUND 12 !" '�ȳ��ϼ���

GOSUB All_motor_mode3

SPEED 5

SERVO 16, 39

SERVO 11, 100

GOTO MAIN	'�ø��� ���� ��ƾ����


'************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,1,1

    RETURN
    '************************************************
    '******************************************
�յڱ�������:
    FOR i = 0 TO COUNT_MAX
        A = AD(�յڱ���AD��Ʈ)	'���� �յ�
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF A < MIN THEN
        GOSUB �����
    ELSEIF A > MAX THEN
        GOSUB �����
    ENDIF

    RETURN
    '**************************************************
�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A < MIN THEN GOSUB �������Ͼ��
    IF A < MIN THEN
        ETX  4800,15
        GOSUB �ڷ��Ͼ��

    ENDIF
    RETURN

�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A > MAX THEN GOSUB �ڷ��Ͼ��
    IF A > MAX THEN
        ETX  4800,15
        GOSUB �������Ͼ��

    ENDIF
    RETURN
    '**************************************************
�¿��������:
    FOR i = 0 TO COUNT_MAX
        B = AD(�¿����AD��Ʈ)	'���� �¿�
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB �⺻�ڼ�	
    ENDIF
    RETURN
    '******************************************

    '************************************************
�ڷ��Ͼ��:
    ERX 4800, First,�ڷ��Ͼ��

    SERVO 16, First

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB ���̷�OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB �⺻�ڼ�

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
    GOSUB �⺻�ڼ�

    �Ѿ���Ȯ�� = 1

    DELAY 200
    GOSUB ���̷�ON

    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************


    '**********************************************
�������Ͼ��:
    ERX 4800, First,�������Ͼ��

    SERVO 16, First

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB ���̷�OFF

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
    GOSUB �⺻�ڼ�
    �Ѿ���Ȯ�� = 1

    '******************************
    DELAY 200
    GOSUB ���̷�ON
    RETURN

    '******************************************

    '******************************************
����_�������Ǽ�1:

    ERX 4800, ������, ����_�������Ǽ�1

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

    SPEED ������
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

    MOVE G6A,100,  76, 145,  93, 100, 100	'����
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOSUB �⺻�ڼ�

    ETX 4800, 50

    GOTO RX_EXIT

����_�������Ǽ�2:

    ERX 4800, ������, ����_�������Ǽ�2

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

    SPEED ������
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

    MOVE G6A,100,  76, 145,  93, 100, 100	'����
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOSUB �⺻�ڼ�

    ETX 4800, 50

    GOTO RX_EXIT

����_�������Ǽ�3:

    ERX 4800, ������, ����_�������Ǽ�3

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

    SPEED ������
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

    MOVE G6A,100,  76, 145,  93, 100, 100	'����
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOSUB �⺻�ڼ�

    ETX 4800, 50

    GOTO RX_EXIT

����_�������Ǽ�4:

    ERX 4800, ������, ����_�������Ǽ�4

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

    SPEED ������
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

    MOVE G6A,100,  76, 145,  93, 100, 100	'����
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOSUB �⺻�ڼ�

    ETX 4800, 50

    GOTO RX_EXIT

����_�������Ǽ�:

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

    MOVE G6A,100,  76, 145,  93, 100, 100	'����
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    GOSUB �⺻�ڼ�

    ETX 4800, 50

    GOTO RX_EXIT

    '******************************************

�����Ӵ�:
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


�ȱ�:
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

�ȱ�_2:
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



���ѷ����ȱ�:
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

    GOSUB �⺻�ڼ�

    ETX 4800, 54

    GOTO RX_EXIT

�ȱ�_����:
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

    GOSUB �⺻�ڼ�

    GOTO RX_EXIT

�ȱ�_����:

    SPEED 15

    '����
    'MOVE G6A,  99,  76, 145,  93, 100,
    'MOVE G6D,  88,  76, 145,  93, 112,
    'MOVE G6B, 100,  30,  80,  ,  ,
    'MOVE G6C, 100,  30,  80,  ,  ,
    'WAIT

    '���� ���̺꺻
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

    '����
    'MOVE G6A,  93,  61, 172,  80, 100,
    'MOVE G6D,  89,  76, 145,  93, 111,
    'MOVE G6B, 100,  30,  80,  ,  ,
    'MOVE G6C, 100,  30,  80,  ,  ,
    'WAIT

    '���� ���̺꺻
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

    '����
    'MOVE G6A,  80,  74, 155,  83, 100,
    'MOVE G6D,  99,  76, 145,  93, 111,
    'MOVE G6B, 100,  30,  80,  ,  ,
    'MOVE G6C, 100,  30,  80,  ,  ,
    'WAIT

    '���� ���̺꺻
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
    WAIT			''�ٲ�ߵ�.

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

�����ʿ�����70����_����:
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



�ȱ�_��:
    MOTORMODE G6A,2,2,2,2,1
    MOTORMODE G6D,2,2,2,2,1

    SPEED 15
    MOVE G6A,  89,  76, 145,  93, 111, 		' �޴ٸ�
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

    GOSUB �⺻�ڼ�

    ETX 4800, 57

    GOTO RX_EXIT

�ȱ�_��������:
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

�ȱ�_��������_4��¦:
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

������������_����_222:
    GOSUB All_motor_mode3
    ����COUNT = 0
    SPEED 7
    HIGHSPEED SETON

    MOVE G6D,93,  76, 147,  93, 101
    MOVE G6A,104,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    GOTO ������������_����_4

������������_����_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,103,  76, 146,  93,  102
    MOVE G6B, 90
    MOVE G6C,115
    WAIT


������������_����_2:

    MOVE G6A,107,   73, 140, 103,  100
    MOVE G6D, 90,  83, 146,  85, 102
    WAIT

������������_����_2_stop:
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

������������_����_4:
    MOVE G6D,95,  88, 125, 103, 104
    MOVE G6A,107,  76, 146,  93,  102
    MOVE G6C, 85
    MOVE G6B,110
    WAIT


������������_����_5:
    MOVE G6D,102,    74, 140, 103,  100
    MOVE G6A, 97,  83, 146,  85, 102
    WAIT

    GOTO ������������_����_1
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

�ȱ�_��������_����:
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

�ȱ�_��������_����2:
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

��ȸ��30: '90�� ȸ���� 9~10ȸ

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

    GOSUB �⺻�ڼ�

    RETURN

��ȸ��30: '90�� ȸ���� 16ȸ
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

    GOSUB �⺻�ڼ�

    RETURN

��ȸ��_����: '90�� ȸ���� 9~10ȸ

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

��ȸ��_����: '90�� ȸ���� 16ȸ
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

�����:

    SPEED 5

    SERVO 11, 100

    SERVO 16, 75

    RETURN

����̱�_����:

    SPEED 5

    MOVE G6C, ,  ,  ,  ,  39
    WAIT

    ETX 4800, 51

    GOTO RX_EXIT

����̱�_39:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    MOVE G6C, ,  ,  ,  ,  39
    WAIT

    ETX 4800,59

    GOTO RX_EXIT

����̱�_75:
    SPEED 5

    MOVE G6C, ,  ,  ,  ,  75
    WAIT

    ETX 4800, 59

    GOTO RX_EXIT

�񵹸���_X100Y75:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    MOVE G6C, ,  ,  ,  ,  75
    WAIT

    ETX 4800, 59

    GOTO RX_EXIT

�񵹸���_X10Y75:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  10
    WAIT

    MOVE G6C, ,  ,  ,  ,  75
    WAIT

    ETX 4800, 59

    GOTO RX_EXIT

�񵹸���_X100:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    ETX 4800,65

    GOTO RX_EXIT

�񵹸���_X100Y100:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  100
    WAIT

    MOVE G6C, ,  ,  ,  ,  100
    WAIT

    'ETX 4800,65

    GOTO RX_EXIT

�񵹸���_X55Y55:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  55
    WAIT

    MOVE G6C, ,  ,  ,  ,  55
    WAIT

    'ETX 4800,65

    GOTO RX_EXIT

�񵹸���_X145Y55:
    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  145
    WAIT

    MOVE G6C, ,  ,  ,  ,  55
    WAIT

    'ETX 4800,65

    GOTO RX_EXIT

�񵹸���_X190Y75:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  190
    WAIT

    MOVE G6C, ,  ,  ,  ,  75
    WAIT

    'ETX 4800,65

    GOTO RX_EXIT

�񵹸���_X10:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  10
    WAIT

    ETX 4800, 61

    GOTO RX_EXIT

�񵹸���_X70:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  70
    WAIT

    'ETX 4800, 60

    GOTO RX_EXIT

�񵹸���_X40:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  40
    WAIT

    'ETX 4800, 62

    GOTO RX_EXIT

�񵹸���_X190:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  190
    WAIT

    ETX 4800, 63

    GOTO RX_EXIT

�񵹸���_X130:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  130
    WAIT

    'ETX 4800, 63

    GOTO RX_EXIT

�񵹸���_X160:

    SPEED 5

    MOVE G6B, ,  ,  ,  ,  ,  160
    WAIT

    'ETX 4800, 63

    GOTO RX_EXIT

    '    MOVE G6C, ,  ,  ,  ,  75
    '    WAIT

�񵹸���_XY10��:
    XAngle = XAngle - 6
    YAngle = YAngle + 1

    SPEED 5

    SERVO 11, XAngle
    SERVO 16, YAngle
    WAIT

    'ETX 4800, 63

    GOTO RX_EXIT

�񵹸���_XY10���̳ʽ���:
    XAngle = XAngle + 6
    YAngle = YAngle - 1

    SPEED 5

    SERVO 11, XAngle
    SERVO 16, YAngle
    WAIT

    'ETX 4800, 63

    GOTO RX_EXIT

��������_�ϳ�:
    ERX 4800, Second, ��������_�ϳ�
    SPEED 1
    GOTO ��������_��

��������_��:
    ERX 4800, ABS, ��������_��
    FORNUM = Second / 15

    IF ABS = 1 THEN
        FOR i = 0 TO FORNUM
            GOSUB ��ȸ��30
        NEXT i
    ELSE
        FOR i = 0 TO FORNUM
            GOSUB ��ȸ��30
        NEXT i

    ENDIF

    ETX 4800, 52

    GOTO RX_EXIT

������_�ϳ�:

    ERX 4800, First, ������_�ϳ�

    GOTO ������_��

������_��:

    ERX 4800, ABS, ������_��

    IF ABS = 0 THEN
        SERVO_SIXTEEN = SERVO_SIXTEEN - First
    ELSEIF ABS = 1 THEN
        SERVO_SIXTEEN = SERVO_SIXTEEN + First
    ENDIF

    SPEED 1

    SERVO 16, SERVO_SIXTEEN

    ETX 4800, 53

    GOTO RX_EXIT

������ġ��:
    SPEED 15
    MOVE G6C, , ,  ,  80,  ,
    WAIT

    'ETX 4800, 53

    GOTO RX_EXIT

����_����������_��巹��1:

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

�����ʿ�����20_����: '****
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

�����ʿ�����10����_����:
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

���ʿ�����20_����: '****
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

���ʿ�����10����_����:
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

������5_����:
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
��������5_����:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 5
    MOVE G6A,93,  72, 145,  99, 107, 100
    MOVE G6D,93,  82, 145,  87, 107, 100
    WAIT

    '40ȸ
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

������10_����:
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
��������10_����:
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

������20:
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
��������20:
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

�񵹷���ã��_�¿�:

    ERX 4800, ELEVEN, �񵹷���ã��_�¿�

    SPEED 5
    SERVO 11, ELEVEN

    ETX 4800, 51

    GOTO RX_EXIT

�񵹷���ã��_�¿�_2:

    ERX 4800, ELEVEN, �񵹷���ã��_�¿�_2

    SPEED 5
    SERVO 11, ELEVEN

    ETX 4800, 56

    GOTO RX_EXIT


�񵹷���ã��_�¿�_3:

    ERX 4800, ELEVEN, �񵹷���ã��_�¿�_3

    SPEED 5
    SERVO 11, ELEVEN
    WAIT

    ETX 4800, 56

    GOTO RX_EXIT

    '=========================================================
    '=========================================================

�񵹷���ã��_����:

    ERX 4800, SIXTEEN, �񵹷���ã��_����

    SPEED 5
    SERVO 16, SIXTEEN

    ETX 4800, 51

    GOTO RX_EXIT

�񵹷���ã��_����_2:

    ERX 4800, SIXTEEN, �񵹷���ã��_����_2

    SPEED 5
    SERVO 16, SIXTEEN

    ETX 4800, 56

    GOTO RX_EXIT

�񵹷���ã��_�¿����_�ϳ�:

    ERX 4800, ELEVEN, �񵹷���ã��_�¿����_�ϳ�

    GOTO �񵹷���ã��_�¿����_��

�񵹷���ã��_�¿����_��:

    ERX 4800, ELEVEN, �񵹷���ã��_�¿����_��

    GOTO �񵹷���ã��_�¿����_��

�񵹷���ã��_�¿����_��:
    ERX 4800, SIXTEEN, �񵹷���ã��_�¿����_��

    SPEED 5
    SERVO 11, ELEVEN
    SERVO 16, SIXTEEN

    ETX 4800, 51

    GOTO RX_EXIT

�񵹷���ã��_�¿����_2_�ϳ�:

    ERX 4800, ELEVEN, �񵹷���ã��_�¿����_2_�ϳ�

    GOTO �񵹷���ã��_�¿����_2_��

�񵹷���ã��_�¿����_2_��:

    ERX 4800, ELEVEN, �񵹷���ã��_�¿����_2_��

    GOTO �񵹷���ã��_�¿����_2_��

�񵹷���ã��_�¿����_2_��:
    ERX 4800, SIXTEEN, �񵹷���ã��_�¿����_2_��

    SPEED 5
    SERVO 11, ELEVEN
    SERVO 16, SIXTEEN

    ETX 4800, 56

    GOTO RX_EXIT

�񵹷���ã��_�¿����_3_�ϳ�:

    ERX 4800, ELEVEN, �񵹷���ã��_�¿����_3_�ϳ�

    GOTO �񵹷���ã��_�¿����_3_��

�񵹷���ã��_�¿����_3_��:

    ERX 4800, ELEVEN, �񵹷���ã��_�¿����_3_��

    GOTO �񵹷���ã��_�¿����_3_��

�񵹷���ã��_�¿����_3_��:
    ERX 4800, SIXTEEN, �񵹷���ã��_�¿����_3_��

    SPEED 5
    SERVO 11, ELEVEN
    SERVO 16, SIXTEEN
    WAIT

    ETX 4800, 56

    GOTO RX_EXIT

    '=====================================

���о��������:

    ERX 4800, ELEVEN_ROUND, ���о��������									' ���¿���Ͱ��� �о� �����Ѵ�.

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

        FORNUM = ELEVEN_ROUND / 5										' ���� ���� Ƚ���� ���Ѵ�

        IF FORNUM = 0 THEN
            IF ELEVEN_ROUND > 3 THEN
                FORNUM = 1
            ENDIF
        ENDIF

        IF BOOLEAN = 1 THEN												' ��ȣ�� ����
            FOR i = 1 TO FORNUM											' ������ ���� ���� ������.
                GOSUB ��������10_����
            NEXT i
        ELSEIF BOOLEAN = 0 THEN
            FOR i = 1 TO FORNUM
                GOSUB ������10_����
            NEXT i
        ENDIF

    ENDIF

    ETX 4800, 51		'eco										' ���ڰ��� �۽��Ѵ�

    GOTO RX_EXIT													'���� �����ϰ� �������� ���ư���.

���о��������_2:

    ERX 4800, ELEVEN_ROUND, ���о��������									' ���¿���Ͱ��� �о� �����Ѵ�.

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

        FORNUM = ELEVEN_ROUND / 5										' ���� ���� Ƚ���� ���Ѵ�

        IF FORNUM = 0 THEN
            IF ELEVEN_ROUND > 3 THEN
                FORNUM = 1
            ENDIF
        ENDIF

        IF BOOLEAN = 1 THEN												' ��ȣ�� ����
            FOR i = 1 TO FORNUM											' ������ ���� ���� ������.
                GOSUB ��������10_����
            NEXT i
        ELSEIF BOOLEAN = 0 THEN
            FOR i = 1 TO FORNUM
                GOSUB ������10_����
            NEXT i
        ENDIF

    ENDIF

    ETX 4800, 51		'eco										' ���ڰ��� �۽��Ѵ�

    GOTO RX_EXIT

���о��������3:

    ERX 4800, ELEVEN_ROUND, ���о��������3									' ���¿���Ͱ��� �о� �����Ѵ�.

    GOTO ���о��������3_2

���о��������3_2:

    ERX 4800, SIXTEEN, ���о��������3_2		

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

        FORNUM = ELEVEN_ROUND / 5										' ���� ���� Ƚ���� ���Ѵ�

        IF FORNUM = 0 THEN
            IF ELEVEN_ROUND > 3 THEN
                FORNUM = 1
            ENDIF
        ENDIF

        IF BOOLEAN = 1 THEN												' ��ȣ�� ����
            FOR i = 1 TO FORNUM											' ������ ���� ���� ������.
                GOSUB ��������10_����
            NEXT i
        ELSEIF BOOLEAN = 0 THEN
            FOR i = 1 TO FORNUM
                GOSUB ������10_����
            NEXT i
        ENDIF

    ENDIF

    ETX 4800, 59		'eco										' ���ڰ��� �۽��Ѵ�

    GOTO RX_EXIT

���о��������4:
    ERX 4800, SIXTEEN, ���о��������4									' ���¿���Ͱ��� �о� �����Ѵ�.	

    SERVO 16, SIXTEEN
    WAIT

    GOSUB ������10_����

    ETX 4800, 56		'eco										' ���ڰ��� �۽��Ѵ�

    GOTO RX_EXIT

���о��������_X75:
    ERX 4800, ELEVEN_ROUND, ���о��������									' ���¿���Ͱ��� �о� �����Ѵ�.

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

        FORNUM = ELEVEN_ROUND / 5										' ���� ���� Ƚ���� ���Ѵ�

        IF FORNUM = 0 THEN
            IF ELEVEN_ROUND > 3 THEN
                FORNUM = 1
            ENDIF
        ENDIF

        IF BOOLEAN = 1 THEN												' ��ȣ�� ����
            FOR i = 1 TO FORNUM											' ������ ���� ���� ������.
                GOSUB ��������10_����
            NEXT i
        ELSEIF BOOLEAN = 0 THEN
            FOR i = 1 TO FORNUM
                GOSUB ������10_����
            NEXT i
        ENDIF

    ENDIF

    GOTO RX_EXIT

�񵹸���:

    SERVO 16, 100

    GOTO RX_EXIT

�񵹸���2:

    SERVO 16, 39

    GOTO RX_EXIT

    '******************************************

�����ʱ��ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0

    RETURN
    '************************************************

�⺻�ڼ�:
    SPEED 15

    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, , ,
    MOVE G6C,100,  30,  80, 190
    WAIT
    mode = 09

    '����
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
    '**** ���̷ΰ��� ���� ****
���̷�INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** ���̷ΰ��� ���� ****
���̷�MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
���̷�MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
���̷�MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '***********************************************
���̷�ON:

    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    ���̷�ONOFF = 1

    RETURN
    '***********************************************
���̷�OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    ���̷�ONOFF = 0
    RETURN

    '************************************************

MOTOR_ON: '����Ʈ�������ͻ�뼳��

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    ����ONOFF = 0

    GOSUB ������			

    RETURN

    '************************************************
    '��ġ���ǵ��
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

������:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
    '************************************************
������:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
    '******************************************
�����ڼ�:
    SPEED 5
    GOSUB ���̷�OFF
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
    '����Ʈ�������ͻ�뼳��
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    ����ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB ������	
    RETURN
    '************************************************

��ȸ�뺯���ʱ�ȭ:
    isAroundLR = 0
    isWalk = 0
    isShot = 0
    isNeckDown = 0
    isNeckChase = 0
    isBodyRotate = 0
    RETURN

MAIN: '�󺧼���

    'ETX 4800, 38 ' ���� ���� Ȯ�� �۽Ű�

MAIN_2:

    GOSUB �յڱ�������
    GOSUB �¿��������	

    A_old = A					' ���� ��� X

    ERX 4800, A, MAIN_2

    '**** �Էµ� A���� 0 �̸� MAIN �󺧷� ����
    '**** 1�̸� KEY1 ��, 2�̸� key2��... ���¹�
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
        GOSUB �⺻�ڼ�

    ELSEIF A = 100 THEN
        GOTO �����Ӵ�

    ELSEIF A = 101 THEN
        GOTO �񵹸���_X100

    ELSEIF A = 102 THEN			'�� ��Ʈ. ���� �Ϸ�.
        GOTO ����_�������Ǽ�1

    ELSEIF A = 103 THEN			'���� ��� �¿�� �� ȸ�� ��Ʈ. �̱���.
        GOTO ����̱�_75

    ELSEIF A = 104 THEN			'�ɾ��.���� �Ϸ�
        GOTO ���ѷ����ȱ�

    ELSEIF A = 105 THEN			'���� �����ض�.
        GOTO ���ʿ�����20_����															

    ELSEIF A = 106 THEN			'�� ������.���� �Ϸ�
        GOTO �����ʿ�����20_����																				

    ELSEIF A = 107 THEN			' �� ������.
        GOTO �ȱ�_��������

    ELSEIF A = 108 THEN			' ���� Ư�� ������ ������
        GOTO �ȱ�_��������_����

    ELSEIF A = 109 THEN
        IF ����Ƚ��= 0 THEN
            ����Ƚ�� = 1
            GOTO �ȱ�
        ELSE
            ����Ƚ�� = 0
            GOTO �ȱ�_2
        ENDIF
        'GOTO �ȱ�

    ELSEIF A = 110 THEN
        GOTO ����̱�_39																		

    ELSEIF A = 111 THEN
        GOTO �񵹸���_X100Y75																		

    ELSEIF A = 112 THEN
        GOTO �񵹷���ã��_�¿����_2_��

    ELSEIF A = 113 THEN
        GOTO �񵹷���ã��_�¿�_2

    ELSEIF A = 114 THEN
        GOTO �񵹷���ã��_����_2

    ELSEIF A = 115 THEN
        GOTO �񵹷���ã��_�¿����_3_��

    ELSEIF A = 116 THEN
        GOTO �񵹷���ã��_�¿�_3

    ELSEIF A = 117 THEN
        GOTO ���ʿ�����10����_����

    ELSEIF A = 118 THEN
        GOTO �����ʿ�����10����_����

    ELSEIF A = 119 THEN
        GOTO �񵹸���_X10Y75

    ELSEIF A = 120 THEN
        GOTO ���о��������

    ELSEIF A = 121 THEN
        GOTO �񵹷���ã��_�¿����_��

    ELSEIF A = 122 THEN
        GOTO �񵹷���ã��_�¿�

    ELSEIF A = 123 THEN
        GOTO �񵹷���ã��_����

    ELSEIF A = 124 THEN
        GOTO ���о��������_2

    ELSEIF A = 125 THEN
        GOTO ��ȸ��_����

    ELSEIF A = 126 THEN
        GOTO ��ȸ��_����

    ELSEIF A = 127 THEN
        GOTO �񵹸���_X70

    ELSEIF A = 128 THEN
        GOTO �񵹸���_X10

    ELSEIF A = 129 THEN
        GOTO �񵹸���_X40

    ELSEIF A = 130 THEN
        GOTO �񵹸���_X190

    ELSEIF A = 131 THEN
        GOTO ������ġ��

    ELSEIF A = 132 THEN
        GOTO �񵹸���_X130

    ELSEIF A = 133 THEN
        GOTO �񵹸���_X160

    ELSEIF A = 134 THEN
        GOTO �񵹸���_X100Y100

    ELSEIF A = 135 THEN
        SPEED 15
        MOVE G6C,,  ,  , 190
        WAIT
        GOTO RX_EXIT

    ELSEIF A = 136 THEN
        GOTO �񵹸���_X55Y55

    ELSEIF A = 137 THEN
        GOTO ���о��������_X75

    ELSEIF A = 138 THEN
        GOTO ���о��������3

    ELSEIF A = 139 THEN
        GOTO ����_�������Ǽ�2

    ELSEIF A = 140 THEN
        GOTO ����_�������Ǽ�3

    ELSEIF A = 141 THEN
        GOTO ����_�������Ǽ�4

    ELSEIF A = 142 THEN
        GOTO �񵹸���_X145Y55

    ELSEIF A = 142 THEN
        GOTO �񵹸���_X190Y75

    ELSEIF A = 143 THEN
        GOTO ���о��������4

    ENDIF

    'GOSUB �⺻�ڼ�

    GOTO MAIN	
    '*******************************************
    '		MAIN �󺧷� ����
    '*******************************************

KEY1:
    GOTO RX_EXIT

    '***************	
KEY2:
    GOTO ������20
    GOTO RX_EXIT

    '***************

KEY3:
    GOTO ��������20

    GOTO RX_EXIT
    '***************
KEY4:

    GOTO ��������5_����

    GOTO RX_EXIT
    '***************
KEY5:

    GOSUB �����ڼ�
    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF

    GOTO RX_EXIT
    '***************
KEY6:

    GOSUB �ȱ�_2

    GOTO RX_EXIT

    '***************
KEY7:
    ETX 4800,7

    GOTO RX_EXIT

    '***************
KEY8:

    GOTO �ȱ�

    GOTO RX_EXIT

    '***************

KEY9:
    GOTO �ȱ�_2

    GOTO RX_EXIT

KEY10:
    GOTO �ȱ�_����

    GOTO RX_EXIT

KEY11:
    GOTO �ȱ�_��

    GOTO RX_EXIT

KEY12:
    GOTO �ȱ�_��������_����

    GOTO RX_EXIT

KEY13:
    GOTO ������5_����

    GOTO RX_EXIT

KEY14: '����ȭ��ǥ
    GOTO ������5_����

    GOTO RX_EXIT

KEY15: 'A
    GOTO �����Ӵ�

    GOTO RX_EXIT
