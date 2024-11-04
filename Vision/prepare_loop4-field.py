import numpy as np
from threading import Thread
import serial
import time
import cv2
import datetime
from PIL import ImageFont, ImageDraw, Image
import queue
import random
import math
import time

# import imutils
#import pandas as pd
v = 0
g = 0
RX_MAX = 256
serial_use = 1
center_aiming_use = 1
threading_Time = 10/1000
receiving_exit = 1
isStart = 0
q = queue.Queue()
error_sign = -1
error_sign2 = -1

curr_time = time.time()

zero = np.zeros((320, 240,3))

u = 100
u2 = 0
robot_height = 33
theta = math.radians(u) #여기에 로보베이직한테서 변수 받아서 넣어줘야함.
frame = np.zeros((320,240,3))

RR = []
# serial_port.write(serial.to_bytes([1]))
def field_detect():
    global green_x, green_y, topmost_vertex, curr_time
    while True:  ###########           left - right move loop           ############
        ret, frame = capture.read()  # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
        ######################조도값 조정###################################################################
        frame = frame.astype(float)
        print('\033[93m' + '**********move loop******************* ' + '\033[93m', rr)
        # 조도값
        brightness = beta
        contrast = alpha

        frame = frame * contrast + brightness
        frame = np.clip(frame, 0, 255)  # Ensure values are within [0, 255]
        frame = frame.astype(np.uint8)
        ###################################################################################################
        imAux = frame.copy()
        objeto = imAux[y1:y2, x1:x2]

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)  # BGR -> HSV

        # hsv = (색상, 채도, 명도)

        lower_green = (75 / 2, 80, 80)
        upper_green = (80, 255, 255)

        mask_green = cv2.inRange(hsv, lower_green, upper_green)

        mask_contours3, hierarchy = cv2.findContours(mask_green, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        res2 = cv2.bitwise_and(frame, frame, mask=mask_green)

        cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
        cv2.rectangle(frame, (290, 0), (310, 240), (0, 255, 0), 2)
        key = cv2.waitKey(30)

        dilation2 = cv2.dilate(res2, np.ones((3,3)), 5)

        ################################################################################################

        ################################################################################################
        cv2.imshow("D2", dilation2)
        cv2.imshow("output", frame)

        term = time.time() - curr_time
        fps = 1 / term
        curr_time = time.time()
        print(f"FPS : {fps}")
        #####################################################################################
        for contour in mask_contours3:

            epsilon = 0.02 * cv2.arcLength(contour, True)
            approx = cv2.approxPolyDP(contour, epsilon, True)

            vertices = [point.ravel() for point in approx]
            top_vertex = min(vertices, key=lambda point: point[1])
            if topmost_vertex is None or top_vertex[1] < topmost_vertex[1]:
                topmost_vertex = top_vertex
            '''
            cv2.drawContours(frame, [approx], -1, (0, 255, 0), 2)
            for point in approx:
                x, y = point.ravel()
                cv2.circle(frame, (x, y), 5, (0, 0, 255), -1)
                print(f"({x}, {y})")
            '''
        if topmost_vertex:
            print(f"{topmost_vertex}")

            green_x, green_y = topmost_vertex
            cv2.circle(frame, (x, y), 5, (0, 0, 255), -1)
            break
                ##############################################################################

        cv2.imshow("D2", dilation2)
        cv2.imshow("output", frame)
def Tylenol(z):
        curr_time = time.time()
        v = 0                                                                                           ########### 시간 지연 루프 (지연시간) / ball ###########
        while True:                                                                                     ###########           tresh loop           ############
                    ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
                ######################조도값 조정###################################################################
                    frame = frame.astype(float)
                    print('\033[93m'+'**********tresh loop******************* '+'\033[93m', rr)
                    # 조도값
                    brightness = beta
                    contrast = alpha

                    frame = frame * contrast + brightness
                    frame = np.clip(frame, 0, 255)  # Ensure values are within [0, 255]
                    frame = frame.astype(np.uint8)
                ###################################################################################################
                    imAux = frame.copy()
                    objeto = imAux[y1:y2, x1:x2]

                    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) #BGR -> HSV

                    #hsv = (색상, 채도, 명도)

                    lower_red = (270 / 2, 70, 70)
                    upper_red = (360 / 2, 255, 255)

                    mask_red = cv2.inRange(hsv, lower_red, upper_red)

                    mask_contours, hierarchy = cv2.findContours(mask_red, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

                    res3 = cv2.bitwise_and(frame, frame, mask=mask_red)

                    ball_pixel_count = cv2.countNonZero(mask_red)

                    cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
                    cv2.rectangle(frame, (290,0), (310,240), (0, 255, 0), 2)
                    key = cv2.waitKey(30)

                    dilation3 = cv2.dilate(res3, np.ones((3, 3)), 5)
                    mix3 = cv2.erode(dilation3, np.ones((3, 3)), 5)

                    ################################################################################################
                    
                    ################################################################################################
                    cv2.imshow("D3", mix3)
                    cv2.imshow("output", frame)
                    
                    term = time.time() - curr_time
                    fps = 1 / term
                    curr_time = time.time()
                    print(f"FPS : {fps}")
                    
                    #####################################################################################
                    # ball distance
                    if mask_contours:
                                largest_contour = max(mask_contours, key=cv2.contourArea)
                                M = cv2.moments(largest_contour)
                                
                                frame_pixels = frame.copy()
                                total_pixels = frame_pixels.shape[0] * frame_pixels.shape[1]
                                ball_ratio = ball_pixel_count / total_pixels * 100
                                ball_ratio = round(ball_ratio, 3)
                                print('ball_ratio = ', ball_ratio)
                                print('total_pixels = ', total_pixels)
                                print('ball_pixel_count = ', ball_pixel_count)

                                if M["m00"] != 0:
                                        cX = int(M["m10"] / M["m00"])
                                        cY = int(M["m01"] / M["m00"])
                                        cv2.circle(frame, (cX, cY), 3, (200, 200, 200), -1)
                    if v==z:
                                print("bbbbbbbbbb", v)
                                v=0
                                break
                    v = v + 1
                    print("v = ", v)
                    time.sleep(0.01)
                                        

                    cv2.imshow("D3", mix3)
                    cv2.imshow("output", frame)
                    
def Tylenol2(q):                                                                                         ########### 시간 지연 루프 (지연시간) / ball ###########
        curr_time = time.time()
        v2 = 0
        while True:                                                                                     ###########          yellow tresh loop           ############
                                    ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
                                ######################조도값 조정###################################################################
                                    frame = frame.astype(float)
                                    print('\033[93m'+'**********tresh loop******************* '+'\033[93m', rr)
                                    # 조도값
                                    brightness = beta
                                    contrast = alpha

                                    frame = frame * contrast + brightness
                                    frame = np.clip(frame, 0, 255)  # Ensure values are within [0, 255]
                                    frame = frame.astype(np.uint8)
                                ###################################################################################################
                                    imAux = frame.copy()
                                    objeto = imAux[y1:y2, x1:x2]

                                    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                                    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) #BGR -> HSV

                                    #hsv = (색상, 채도, 명도)

                                    lower_yellow = (45/2, 30, 160)
                                    upper_yellow = (65/2, 255, 255)

                                    mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)
                                    
                                    mask_contours2, hierarchy = cv2.findContours(mask_yellow, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

                                    res4 = cv2.bitwise_and(frame, frame, mask=mask_yellow)

                                    cup_pixel_count = cv2.countNonZero(mask_yellow)

                                    cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
                                    cv2.rectangle(frame, (290,0), (310,240), (0, 255, 0), 2)
                                    key = cv2.waitKey(30)

                                    dilation3 = cv2.dilate(res3, np.ones((3, 3)), 5)
                                    mix3 = cv2.erode(dilation3, np.ones((3, 3)), 5)

                                    ################################################################################################
                                    
                                    ################################################################################################
                                    cv2.imshow("D3", mix3)
                                    cv2.imshow("output", frame)
                                
                                    term = time.time() - curr_time
                                    fps = 1 / term
                                    curr_time = time.time()
                                    print(f"FPS : {fps}")
                                    #####################################################################################
                                    # ball distance
                                    if mask_contours2:
                                            largest_contour2 = max(mask_contours2, key=cv2.contourArea)
                                            N = cv2.moments(largest_contour2)
                                            frame_pixels = frame.copy()
                                            total_pixels = frame_pixels.shape[0] * frame_pixels.shape[1]
                                            cup_ratio = cup_pixel_count / total_pixels * 100
                                            cup_ratio = round(cup_ratio, 3)
                                            if N["m00"] != 0:
                                                    print("yellow check")
                                                    ccX = int(N["m10"] / N["m00"])
                                                    ccY = int(N["m01"] / N["m00"])
                                                    cv2.circle(frame, (ccX, ccY), 3, (0, 0, 255), -1)
                                    
                                    if v2==q:
                                            print("bbbbbbbbbb")
                                            v2=0
                                            break
                                    v2 = v2 + 1
                                    time.sleep(0.05)
                                                        

                                    cv2.imshow("D3", mix3)
                                    cv2.imshow("output", frame)

def RX_Translator(RX):
        global isStart, u2, RR, rr
        
        print("RX_Translator")
        if RX == 7:
                print("RX_Translator_7")
                isStart = 1
                print("isStart : " + str(isStart))
        elif RX == 8:
                print("RX_Translator_8")
                isStart = 2
                print("isStart : " + str(isStart))
        RR.append(RX)
        rr = RX
        #print('RR = ', RR)
def TX_data(ser, one_byte):  # one_byte= 0~255
    ser.write(serial.to_bytes([one_byte]))

def RX_Receiving(ser, q):
    global receiving_exit, threading_Time, RX, isStart

    '''
    global X_255_point
    global Y_255_point
    global X_Size
    global Y_Size
    global Area, Angle
    '''
    while True:
        if receiving_exit == 0:
            break
            
        while not q.empty():
                data = q.get()
                print("TX_data : " + str(data))
                TX_data(ser, data)
        
        time.sleep(threading_Time)
        
        if ser.inWaiting() > 0:
            result = ser.read(1)
            RX = ord(result) 
            print("RX_DATA                                          " + str(RX))
            RX_Translator(RX)           # this line can be something      
                
                
            
# opencv python 코딩 기본 틀
# 카메라 영상을 받아올 객체 선언 및 설정(영상 소스, 해상도 설정)

capture = cv2.VideoCapture(0)
capture.set(cv2.CAP_PROP_FRAME_WIDTH, 320)
capture.set(cv2.CAP_PROP_FRAME_HEIGHT, 240)
capture.set(cv2.CAP_PROP_FPS, 30)

fourcc = cv2.VideoWriter_fourcc(*'XVID')  # 영상을 기록할 코덱 설정
is_record = False  # 녹화상태는 처음엔 거짓으로 설정

#cascade = cv2.CascadeClassifier('/home/pi/ball_cascade.xml')

count = 0
count2 = 0

x1, y1 = 290, 180
x2, y2 = 390, 280
#capture.set(cv2.CAP_PROP_EXPOSURE, -5)
#capture.set(cv2.CAP_PROP_BRIGHTNESS, 0.3)

alpha = 1
beta = 0

XNA = 100
YNA = 39

XNA2 = 100
YNA2 = 39

XNA3 = 100
YNA3 = 39

arr = []

if serial_use != 0:  # python3
    BPS = 4800  # 4800,9600,14400, 19200,28800, 57600, 115200       # 리모컨 번호
    # ---------local Serial Port : ttyS0 --------
    # ---------USB Serial Port : ttyAMA0 --------
    serial_port = serial.Serial('/dev/ttyS0', BPS, timeout=0.001)
    serial_port.open
    serial_port.flush()  # serial cls
    time.sleep(0.5)

    serial_t = Thread(target=RX_Receiving, args=(serial_port,q,))
    serial_t.daemon = True
    serial_t.start()

    # First -> Start Code Send
    TX_data(serial_port, 250)
    serial_use = 0





#머신러닝 데이터 불러오기
'''
dt = pd.read_json('/home/pi/ML_DATA.json')
x = df.loc[0:32, 'percent'].values.reshape(-1,1)
y = df.loc[0:32, 'distance'].values.reshape(-1,1)
'''
ML_P = open('ML_Percent.txt', 'r')                                      # 목 75도 기준
ML_D = open('ML_Distance.txt', 'r')                                     # 목 75도 기준
x = ML_P.readlines()
y = ML_D.readlines()
ML_P.close()
ML_D.close()

y_float = []
for i in range(len(y)):
        y_float.append(float(y[i]))
        
ML_P2 = open('ML_Percent2.txt', 'r')                                      # 목 39도 기준
ML_D2 = open('ML_Distance2.txt', 'r')                                     # 목 39도 기준
x22 = ML_P2.readlines()
y22 = ML_D2.readlines()
ML_P2.close()
ML_D2.close()

y2_float = []
for i in range(len(y22)):
        y2_float.append(float(y22[i]))

global ball_distance_num
global ball_distance
global cup_distance_num
global cup_distance

ball_distance_num = 0
ball_distance = 0
cup_distance_num = 0
cup_distance = 0
between_distance = 0

included_angle = 0
roro = 0

flag1 = True
flag2 = True
flag3 = True
flag_ball = False
flag_walk = False
start_flag = True
FL = True
FFL = False
FFFL = False
rotate_neck = False
XerrorF = True
YerrorF = True
XerrorF2 = True
YerrorF2 = True

rotation_theta = 100
rr=0

while True:                                                             #prepare loop
    if rr == 7 and start_flag:
                        
        while True:                                                                                     ###########           red detect loop           ############
                        ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
                    ######################조도값 조정###################################################################
                        frame = frame.astype(float)
                        print('\033[93m'+'**********flag ball******************* '+'\033[93m', rr)
                        # 조도값
                        brightness = beta
                        contrast = alpha

                        frame = frame * contrast + brightness
                        frame = np.clip(frame, 0, 255)  # Ensure values are within [0, 255]
                        frame = frame.astype(np.uint8)
                    ###################################################################################################
                        imAux = frame.copy()
                        objeto = imAux[y1:y2, x1:x2]

                        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) #BGR -> HSV

                        #hsv = (색상, 채도, 명도)

                        lower_red = (270 / 2, 80, 80)
                        upper_red = (360 / 2, 255, 255)

                        mask_red = cv2.inRange(hsv, lower_red, upper_red)

                        mask_contours, hierarchy = cv2.findContours(mask_red, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

                        res3 = cv2.bitwise_and(frame, frame, mask=mask_red)

                        ball_pixel_count = cv2.countNonZero(mask_red)

                        cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
                        cv2.rectangle(frame, (0,100), (320,140), (255, 0, 0), 2)
                        cv2.rectangle(frame, (0,40), (320,200), (0, 0, 255), 2)
                        key = cv2.waitKey(30)

                        dilation3 = cv2.dilate(res3, np.ones((3, 3)), 5)
                        mix3 = cv2.erode(dilation3, np.ones((3, 3)), 5)

                        ################################################################################################
                        
                        ################################################################################################
                        cv2.imshow("D3", mix3)
                        cv2.imshow("output", frame)
                    
                        term = time.time() - curr_time
                        fps = 1 / term
                        curr_time = time.time()
                        print(f"FPS : {fps}")
                        #####################################################################################
                        # ball distance
                        if mask_contours:
                                    largest_contour = max(mask_contours, key=cv2.contourArea)
                                    M = cv2.moments(largest_contour)
                                    
                                    frame_pixels = frame.copy()
                                    total_pixels = frame_pixels.shape[0] * frame_pixels.shape[1]
                                    ball_ratio = ball_pixel_count / total_pixels * 100
                                    ball_ratio = round(ball_ratio, 3)
                                    print('ball_ratio = ', ball_ratio)
                                    print('total_pixels = ', total_pixels)
                                    print('ball_pixel_count = ', ball_pixel_count)

                                    if M["m00"] != 0:
                                            cX = int(M["m10"] / M["m00"])
                                            cY = int(M["m01"] / M["m00"])
                                            cv2.circle(frame, (cX, cY), 3, (200, 200, 200), -1)
                                                                                                                         
                                            #ball_distance_num = x.index(ball_ratio+'\n')
                                            #ball_distance = y[ball_distance_num]

                                            #if cY >= 100 and cY <= 140 :
                                            X_error = cX - 160
                                            if X_error >= 0 :
                                                    error_sign = 1
                                            elif X_error < 0 :
                                                    error_sign = 0
                                                    
                                            Y_error = 120 - cY
                                            if Y_error >= 0 :
                                                    error_sign2 = 1       
                                            elif Y_error < 0 :
                                                    error_sign2 = 0
                                            ###################################################
                                            if X_error<10 and X_error>-10:
                                                XerrorF = False
                                            else :
                                                XerrorF = True
                                                
                                                
                                            if Y_error<10 and Y_error>-10:
                                                YerrorF = False
                                            else :
                                                YerrorF = True
                                            ######################################################################         
                                            if error_sign == 0 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                                print("switch 1")
                                                XNA2 = XNA2 - 1
                                                YNA2 = YNA2 - 1
                                                q.put(121)          #Left : neck turn / DOWN : neck down                                 #53
                                                #time.sleep(0.1)
                                                q.put(XNA2)
                                                #time.sleep(0.1)
                                                q.put(YNA2)
                                                Tylenol(5)
                                            elif error_sign == 1 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                                print("switch 2")
                                                XNA2 = XNA2 + 1
                                                YNA2 = YNA2 - 1
                                                q.put(121)          #Right : neck turn / DOWN : neck                                     #53
                                                #time.sleep(0.1)
                                                q.put(XNA2)
                                                #time.sleep(0.1)
                                                q.put(YNA2)
                                                Tylenol(5)
                                            elif error_sign == 0 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                                print("switch 3")
                                                XNA2 = XNA2 - 1
                                                YNA2 = YNA2 + 1
                                                q.put(121)          #Left : neck turn / UP : neck UP                                     #53
                                                #time.sleep(0.1)
                                                q.put(XNA2)
                                                #time.sleep(0.1)
                                                q.put(YNA2)
                                                Tylenol(5)
                                            elif error_sign == 1 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                                print("switch 4")
                                                XNA2 = XNA2 + 1
                                                YNA2 = YNA2 + 1
                                                q.put(121)          #Right : neck turn / UP : neck UP                                    #53
                                                #time.sleep(0.1)
                                                q.put(XNA2)
                                                #time.sleep(0.1)
                                                q.put(YNA2)
                                                Tylenol(5)
                                            elif error_sign == 0 and (Y_error > -10 and Y_error < 10):
                                                print("switch 5")
                                                XNA2 = XNA2 - 1
                                                q.put(122)          #Left : neck turn                                                    #53
                                                #time.sleep(0.1)
                                                q.put(XNA2)
                                                Tylenol(5)
                                            elif error_sign == 1 and (Y_error > -10 and Y_error < 10):
                                                print("switch 6")
                                                XNA2 = XNA2 + 1
                                                q.put(122)          #Right : neck turn                                                   #53
                                                #time.sleep(0.1)
                                                q.put(XNA2)
                                                time.sleep(0.05)
                                            elif error_sign2 == 0 and (X_error > -10 and X_error < 10):   
                                                print("switch 7")  
                                                YNA2 = YNA2 - 1
                                                q.put(123)          #DOWN : neck down                                                    #53
                                                #time.sleep(0.1)
                                                q.put(YNA2)
                                                Tylenol(5)
                                            elif error_sign2 == 1 and (X_error > -10 and X_error < 10):
                                                print("switch 8")
                                                YNA2 = YNA2 + 1
                                                q.put(123)          #UP : neck up                                                        #53 
                                                #time.sleep(0.1) 
                                                q.put(YNA2)
                                                Tylenol(5)
                                            ##############################################################################    
                                            if (X_error < 10 and X_error > -10) and (Y_error < 10 and Y_error > - 10):
                                                    #ball_distance = 33 * math.tan(YNA2)
                                                    #ball_distance = round(ball_distance, 2)
                                                    #XNA3 = XNA2
                                                    #YNA3 = YNA2
                                                    #time.sleep(0.3)
                                                    break
                        
                        else :
                                if XNA2 == 100 :
                                    XNA2 = 70
                                    q.put(127)        
                                    Tylenol(20)
                                elif XNA2 == 70:
                                    XNA2 = 40
                                    q.put(129)
                                    Tylenol(20)
                                elif XNA2 == 40 and flag2 == False:                    #########################
                                    XNA2 = 10
                                    q.put(128) 
                                    Tylenol(20)
                                elif (XNA2 == 10) or (XNA2 == 40 and YNA2 == 39):
                                    XNA2 = 130
                                    q.put(132)
                                    Tylenol(20)
                                elif XNA2 == 130:
                                    XNA2 = 160
                                    q.put(133)
                                    Tylenol(20)
                                elif XNA2 == 160 and flag2 == False:                   ##########################
                                    XNA2 = 190
                                    q.put(130)
                                    Tylenol(20)
                                elif (XNA2 == 160 and YNA2 == 39):
                                    XNA2 = 100
                                    YNA2 = 75
                                    q.put(111)
                                    Tylenol(20)
                                    if flag2 == True:
                                            flag2 = False
                                    elif flag2 == False:
                                            flag2 = True
                                elif (XNA2 == 190 and YNA2 == 75):
                                    XNA2 = 100
                                    YNA2 = 39
                                    q.put(110)
                                    Tylenol(20)
                                    if flag2 == True:
                                            flag2 = False
                                    elif flag2 == False:
                                            flag2 = True
                                                    
                        cv2.imshow("D3", mix3)
                        cv2.imshow("output", frame)
                        
                                       
        q.put(103)
        Tylenol(40)
        XNA3 = 100
        YNA3 = 75
        
        while True:                                                                                     ###########           yellow detect loop           ############
            ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
        ######################조도값 조정###################################################################
            frame = frame.astype(float)
            print('\033[92m'+'???????????????? ''\033[0m', rr)
            # 조도값
            brightness = beta
            contrast = alpha

            frame = frame * contrast + brightness
            frame = np.clip(frame, 0, 255)  # Ensure values are within [0, 255]
            frame = frame.astype(np.uint8)
        ###################################################################################################
            imAux = frame.copy()
            
            objeto = imAux[y1:y2, x1:x2]

            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) #BGR -> HSV

            #hsv = (색상, 채도, 명도)

            lower_yellow = (45/2, 30, 160)
            upper_yellow = (65/2, 255, 255)

            mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)

            mask_contours2, hierarchy = cv2.findContours(mask_yellow, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

            res4 = cv2.bitwise_and(frame, frame, mask=mask_yellow)

            cup_pixel_count = cv2.countNonZero(mask_yellow)
            
            cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
            cv2.rectangle(frame, (0,100), (320,140), (255, 0, 0), 2)
            cv2.rectangle(frame, (0,40), (320,200), (0, 0, 255), 2)
            key = cv2.waitKey(30)
                                                           
            dilation4 = cv2.dilate(res4, np.ones((3, 3)), 5)
            mix3 = cv2.erode(dilation3, np.ones((3, 3)), 5)

            ################################################################################################ 
            if mask_contours2:
                    largest_contour2 = max(mask_contours2, key=cv2.contourArea)
                    N = cv2.moments(largest_contour2)
                    if N["m00"] != 0:
                            print("yellow check")
                            ccX = int(N["m10"] / N["m00"])
                            ccY = int(N["m01"] / N["m00"])
                            cv2.circle(frame, (ccX, ccY), 3, (0, 0, 255), -1)

                            X_error2 = ccX - 160
                            if X_error2 >= 0 :
                                    error_sign3 = 1
                            elif X_error2 < 0 :
                                    error_sign3 = 0
                                    
                            Y_error2 = 120 - ccY
                            if Y_error2 >= 0 :
                                    error_sign4 = 1       
                            elif Y_error2 < 0 :
                                    error_sign4 = 0
                            ################################################        
                            if X_error2<10 and X_error2>-10:
                                XerrorF2 = False
                            else :
                                XerrorF2 = True
                                
                                
                            if Y_error2<10 and Y_error2>-10:
                                YerrorF2 = False
                            else :
                                YerrorF2 = True
                            ######################################################################        
                            if error_sign3 == 0 and error_sign4 == 0 and (XerrorF2 == True and YerrorF2 == True):
                                XNA3 = XNA3 - 1
                                YNA3 = YNA3 - 1
                                q.put(112)          #Left : neck turn / DOWN : neck down                                 #56
                                #time.sleep(0.1)
                                q.put(XNA3)
                                #time.sleep(0.05)
                                q.put(YNA3)
                                Tylenol2(5)
                            elif error_sign3 == 1 and error_sign4 == 0 and (XerrorF2 == True and YerrorF2 == True):
                                XNA3 = XNA3 + 1
                                YNA3 = YNA3 - 1
                                q.put(112)          #Right : neck turn / DOWN : neck                                     #56
                                #time.sleep(0.1)
                                q.put(XNA3)
                                #time.sleep(0.05)
                                q.put(YNA3)
                                Tylenol2(5)
                            elif error_sign3 == 0 and error_sign4 == 1 and (XerrorF2 == True and YerrorF2 == True):
                                XNA3 = XNA3 - 1
                                YNA3 = YNA3 + 1
                                q.put(112)          #Left : neck turn / UP : neck UP                                     #56
                                #time.sleep(0.1)
                                q.put(XNA3)
                                #time.sleep(0.05)
                                q.put(YNA3)
                                Tylenol2(5)
                            elif error_sign3 == 1 and error_sign4 == 1 and (XerrorF2 == True and YerrorF2 == True):
                                XNA3 = XNA3 + 1
                                YNA3 = YNA3 + 1
                                q.put(112)          #Right : neck turn / UP : neck UP                                    #56
                                #time.sleep(0.1)
                                q.put(XNA3)
                                #time.sleep(0.05)
                                q.put(YNA3)
                                Tylenol2(5)
                            elif error_sign3 == 0 and (Y_error2 > -10 and Y_error2 < 10):
                                XNA3 = XNA3 - 1
                                q.put(113)          #Left : neck turn                                                    #56
                                #time.sleep(0.05)
                                q.put(XNA3)
                                Tylenol2(5)
                            elif error_sign3 == 1 and (Y_error2 > -10 and Y_error2 < 10):
                                XNA3 = XNA3 + 1
                                q.put(113)          #Right : neck turn                                                   #56
                                #time.sleep(0.05)
                                q.put(XNA3)
                                Tylenol2(5)
                            elif error_sign4 == 0 and (X_error2 > -10 and X_error2 < 10):     
                                YNA3 = YNA3 - 1
                                q.put(114)          #DOWN : neck down                                                    #56
                                #time.sleep(0.05)
                                q.put(YNA3)
                                Tylenol2(5)
                            elif error_sign4 == 1 and (X_error2 > -10 and X_error2 < 10):
                                YNA3 = YNA3 + 1
                                q.put(114)          #UP : neck up                                                        #56 
                                #time.sleep(0.05) 
                                q.put(YNA3)
                                Tylenol2(5)

                            if (ccY > 110 and ccY < 130) and (ccX > 150 and ccX < 170):
                                    cup_distance = 33 * math.tan(YNA3)
                                    cup_distance = round(cup_distance, 2)
                                    print("Escape")
                                    break

            else :
                            if XNA3 == 100 :
                                XNA3 = 70
                                q.put(127)        
                                Tylenol2(20)
                            elif XNA3 == 70:
                                XNA3 = 40
                                q.put(129)
                                Tylenol2(20)
                            elif XNA3 == 40:
                                XNA3 = 10
                                q.put(128) 
                                Tylenol2(20)
                            elif XNA3 == 10:
                                XNA3 = 130
                                q.put(132)
                                Tylenol2(20)
                            elif XNA3 == 130:
                                XNA3 = 160
                                q.put(133)
                                Tylenol2(20)
                            elif XNA3 == 160:                   
                                XNA3 = 190
                                q.put(130)
                                Tylenol2(20)
                            elif XNA3 == 190:
                                XNA3 = 100
                                YNA3 = 75
                                q.put(111)
                                Tylenol2(20)
                                                
            cv2.imshow("D4", dilation4)     #yellow
            cv2.imshow("output", frame)
            
        XNA = 100
        YNA = 39
        q.put(121)
        time.sleep(0.05)
        q.put(100)
        time.sleep(0.05)
        q.put(39)
        #q.put(YNA2)
        time.sleep(0.05)
        
        if (XNA3 - 55) <= 0:             #측면 스타트
            print("side start")
            q.put(121)
            q.put(55)
            q.put(100)
            Tylenol(5)
            field_detect()
            if green_x > 160 and green_y > 120:
                print("Par4")
                q.put(121)
                q.put(100)
                q.put(39)
                Tylenol(5)
            else:
                print("Par3")
                q.put(121)
                q.put(100)
                q.put(39)
                Tylenol(5)
            rr = 54
            break            
        elif (XNA3 -55) > 0:            #정면 스타트
            print("front start")
            q.put(121)
            q.put(55)
            q.put(100)
            Tylenol(5)
            field_detect()
            if green_x > 160 and green_y > 120:
                print("Par4")
                q.put(121)
                q.put(100)
                q.put(39)
                Tylenol(5)
            else:
                print("Par3")
                q.put(121)
                q.put(100)
                q.put(39)
                Tylenol(5)
            while True:                                                                                     ###########           left - right move loop           ############
                        ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
                    ######################조도값 조정###################################################################
                        frame = frame.astype(float)
                        print('\033[93m'+'**********move loop******************* '+'\033[93m', rr)
                        # 조도값
                        brightness = beta
                        contrast = alpha

                        frame = frame * contrast + brightness
                        frame = np.clip(frame, 0, 255)  # Ensure values are within [0, 255]
                        frame = frame.astype(np.uint8)
                    ###################################################################################################
                        imAux = frame.copy()
                        objeto = imAux[y1:y2, x1:x2]

                        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) #BGR -> HSV

                        #hsv = (색상, 채도, 명도)

                        lower_red = (270 / 2, 70, 70)
                        upper_red = (360 / 2, 255, 255)

                        mask_red = cv2.inRange(hsv, lower_red, upper_red)

                        mask_contours, hierarchy = cv2.findContours(mask_red, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

                        res3 = cv2.bitwise_and(frame, frame, mask=mask_red)

                        ball_pixel_count = cv2.countNonZero(mask_red)

                        cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
                        cv2.rectangle(frame, (290,0), (310,240), (0, 255, 0), 2)
                        key = cv2.waitKey(30)

                        dilation3 = cv2.dilate(res3, np.ones((3, 3)), 5)
                        mix3 = cv2.erode(dilation3, np.ones((3, 3)), 5)

                        ################################################################################################
                        
                        ################################################################################################
                        cv2.imshow("D3", mix3)
                        cv2.imshow("output", frame)
                    
                        term = time.time() - curr_time
                        fps = 1 / term
                        curr_time = time.time()
                        print(f"FPS : {fps}")
                        #####################################################################################
                        # ball distance
                        if mask_contours:
                                    largest_contour = max(mask_contours, key=cv2.contourArea)
                                    M = cv2.moments(largest_contour)
                                    
                                    frame_pixels = frame.copy()
                                    total_pixels = frame_pixels.shape[0] * frame_pixels.shape[1]
                                    ball_ratio = ball_pixel_count / total_pixels * 100
                                    ball_ratio = round(ball_ratio, 3)
                                    print('ball_ratio = ', ball_ratio)
                                    print('total_pixels = ', total_pixels)
                                    print('ball_pixel_count = ', ball_pixel_count)

                                    if M["m00"] != 0:
                                            cX = int(M["m10"] / M["m00"])
                                            cY = int(M["m01"] / M["m00"])
                                            cv2.circle(frame, (cX, cY), 3, (200, 200, 200), -1)
                                                                                                                         
                                            #ball_distance_num = x.index(ball_ratio+'\n')
                                            #ball_distance = y[ball_distance_num]

                                            #if cY >= 100 and cY <= 140 :
                                            X_error2 = cX - 300
                                            if X_error2 >= 0 :                  #right
                                                    error_sign3 = 1
                                            elif X_error2 < 0 :                 #left
                                                    error_sign3 = 0
                                            ##############################################################################          
                                            if (X_error2 < 10 and X_error2 > -10):
                                                    #ball_distance = 33 * math.tan(YNA2)
                                                    #ball_distance = round(ball_distance, 2)
                                                    rr = 57
                                                    print("run", rr)
                                                    break
                                            ######################################################################         
                                            if error_sign3 == 0:
                                                print("switch 1")
                                                q.put(117)          #Left
                                                Tylenol(15)
                                            elif error_sign3 == 1:
                                                print("switch 2")
                                                q.put(118)          #Right
                                                Tylenol(15)
                                            ##############################################################################    
                                            

                        cv2.imshow("D3", mix3)
                        cv2.imshow("output", frame)
        Tylenol(5)
        if rr == 57:
            print("rotation")
            q.put(125)
            while True:                                                                                     ###########           rotation loop           ############
                        ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
                    ######################조도값 조정###################################################################
                        frame = frame.astype(float)
                        print('\033[93m'+'**********dont move loop******************* '+'\033[93m', rr)
                        # 조도값
                        brightness = beta
                        contrast = alpha

                        frame = frame * contrast + brightness
                        frame = np.clip(frame, 0, 255)  # Ensure values are within [0, 255]
                        frame = frame.astype(np.uint8)
                    ###################################################################################################
                        imAux = frame.copy()
                        objeto = imAux[y1:y2, x1:x2]

                        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) #BGR -> HSV

                        #hsv = (색상, 채도, 명도)

                        lower_red = (270 / 2, 70, 70)
                        upper_red = (360 / 2, 255, 255)

                        mask_red = cv2.inRange(hsv, lower_red, upper_red)

                        mask_contours, hierarchy = cv2.findContours(mask_red, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

                        res3 = cv2.bitwise_and(frame, frame, mask=mask_red)

                        ball_pixel_count = cv2.countNonZero(mask_red)

                        cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
                        cv2.rectangle(frame, (290,0), (310,240), (0, 255, 0), 2)
                        key = cv2.waitKey(30)

                        dilation3 = cv2.dilate(res3, np.ones((3, 3)), 5)
                        mix3 = cv2.erode(dilation3, np.ones((3, 3)), 5)

                        ################################################################################################
                        
                        ################################################################################################
                        cv2.imshow("D3", mix3)
                        cv2.imshow("output", frame)
                    
                        term = time.time() - curr_time
                        fps = 1 / term
                        curr_time = time.time()
                        print(f"FPS : {fps}")
                        #####################################################################################
                        # ball distance
                        if mask_contours:
                                    largest_contour = max(mask_contours, key=cv2.contourArea)
                                    M = cv2.moments(largest_contour)
                                    
                                    frame_pixels = frame.copy()
                                    total_pixels = frame_pixels.shape[0] * frame_pixels.shape[1]
                                    ball_ratio = ball_pixel_count / total_pixels * 100
                                    ball_ratio = round(ball_ratio, 3)
                                    print('ball_ratio = ', ball_ratio)
                                    print('total_pixels = ', total_pixels)
                                    print('ball_pixel_count = ', ball_pixel_count)

                                    if M["m00"] != 0:
                                            cX = int(M["m10"] / M["m00"])
                                            cY = int(M["m01"] / M["m00"])
                                            cv2.circle(frame, (cX, cY), 3, (200, 200, 200), -1)
                        if rr == 58:
                                    break
                                            

                        cv2.imshow("D3", mix3)
                        cv2.imshow("output", frame)
        if rr == 58:
                while True:                                                                                     ###########           left - right move loop 2          ############
                        ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
                    ######################조도값 조정###################################################################
                        frame = frame.astype(float)
                        print('\033[93m'+'**********move loop******************* '+'\033[93m', rr)
                        # 조도값
                        brightness = beta
                        contrast = alpha

                        frame = frame * contrast + brightness
                        frame = np.clip(frame, 0, 255)  # Ensure values are within [0, 255]
                        frame = frame.astype(np.uint8)
                    ###################################################################################################
                        imAux = frame.copy()
                        objeto = imAux[y1:y2, x1:x2]

                        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) #BGR -> HSV

                        #hsv = (색상, 채도, 명도)

                        lower_red = (270 / 2, 70, 70)
                        upper_red = (360 / 2, 255, 255)

                        mask_red = cv2.inRange(hsv, lower_red, upper_red)

                        mask_contours, hierarchy = cv2.findContours(mask_red, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

                        res3 = cv2.bitwise_and(frame, frame, mask=mask_red)

                        ball_pixel_count = cv2.countNonZero(mask_red)

                        cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
                        cv2.rectangle(frame, (170,0), (190,240), (0, 255, 0), 2)
                        cv2.rectangle(frame, (0,130), (320,150), (0, 255, 0), 2)
                        key = cv2.waitKey(30)

                        dilation3 = cv2.dilate(res3, np.ones((3, 3)), 5)
                        mix3 = cv2.erode(dilation3, np.ones((3, 3)), 5)

                        ################################################################################################
                        
                        ################################################################################################
                        cv2.imshow("D3", mix3)
                        cv2.imshow("output", frame)
                    
                        term = time.time() - curr_time
                        fps = 1 / term
                        curr_time = time.time()
                        print(f"FPS : {fps}")
                        #####################################################################################
                        # ball distance
                        if mask_contours:
                                    largest_contour = max(mask_contours, key=cv2.contourArea)
                                    M = cv2.moments(largest_contour)
                                    
                                    frame_pixels = frame.copy()
                                    total_pixels = frame_pixels.shape[0] * frame_pixels.shape[1]
                                    ball_ratio = ball_pixel_count / total_pixels * 100
                                    ball_ratio = round(ball_ratio, 3)
                                    print('ball_ratio = ', ball_ratio)
                                    print('total_pixels = ', total_pixels)
                                    print('ball_pixel_count = ', ball_pixel_count)

                                    if M["m00"] != 0:
                                            cX = int(M["m10"] / M["m00"])
                                            cY = int(M["m01"] / M["m00"])
                                            cv2.circle(frame, (cX, cY), 3, (200, 200, 200), -1)
                                                                                                                         
                                            #ball_distance_num = x.index(ball_ratio+'\n')
                                            #ball_distance = y[ball_distance_num]

                                            #if cY >= 100 and cY <= 140 :
                                            X_error2 = cX - 180
                                            if X_error2 >= 0 :                  #right
                                                    error_sign3 = 1
                                            elif X_error2 < 0 :                 #left
                                                    error_sign3 = 0
                                            
                                            Y_error2 = cY - 140
                                            if Y_error2 >= 0 :                  #backward
                                                    error_sign4 = 1
                                            elif Y_error2 < 0 :                 #foward
                                                    error_sign4 = 0
                                            ##############################################################################          
                                            if (X_error2 < 10 and X_error2 > -10):
                                                    #ball_distance = 33 * math.tan(YNA2)
                                                    #ball_distance = round(ball_distance, 2)
                                                    FFL = True
                                            ######################################################################        
                                            if (Y_error2 < 10 and Y_error2 > -10):
                                                    #ball_distance = 33 * math.tan(YNA2)
                                                    #ball_distance = round(ball_distance, 2)
                                                    FFL = False
                                                    FFFL = True
                                            ######################################################################        
                                            if (X_error2 < 10 and X_error2 > -10) and (Y_error2 < 10 and Y_error2 > -10):
                                                    #ball_distance = 33 * math.tan(YNA2)
                                                    #ball_distance = round(ball_distance, 2)
                                                    FFFL = False
                                                    rr = 64
                                                    print("run", rr)
                                                    break        
                                            ######################################################################      
                                            if error_sign3 == 0 and FFL == False:                                        
                                                print("switch 1")
                                                q.put(117)          #Left                                       #57
                                                Tylenol(15)
                                            elif error_sign3 == 1 and FFL == False:
                                                print("switch 2")
                                                q.put(118)          #Right                                      #57
                                                Tylenol(15)
                                            elif error_sign4 == 0 and FFL == True:
                                                print("switch 3")
                                                q.put(107)              #foward
                                                Tylenol(15)
                                            elif error_sign4 == 1 and FFL == True:
                                                print("switch 4")
                                                q.put(108)              #backward
                                                Tylenol(15)
                                            elif error_sign3 == 0 and FFFL == True:
                                                q.put(117)
                                                Tylenol(15)
                                            elif error_sign3 == 1 and FFFL == True:
                                                q.put(118)
                                                Tylenol(15)
                                            ##############################################################################    
                                            

                        cv2.imshow("D3", mix3)
                        cv2.imshow("output", frame)
                
        
        if rr == 64:
                q.put(102)
                q.put(12)
                Tylenol(120)
        if rr == 50:
                XNA = 10
                YNA = 75
                q.put(138)
                q.put(XNA)
                q.put(YNA)
                XNA = 100
                YNA = 75
                Tylenol(70)
                print("break")
                break
