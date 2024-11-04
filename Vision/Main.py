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

zero = np.zeros((320, 240,3))

u = 100
u2 = 0
robot_height = 33
theta = math.radians(u)
frame = np.zeros((320,240,3))

RR = []
def body_array_loop():
    global rr
    global XNA
    global YNA
    global between_distance
    global No_end_in_sight

    v = 0
    FFL = False
    FFFL = False
    if XNA2 >= XNA3:              #ball이 홀컵보다 오른쪽에 위치할 때 (로봇기준)
        theta = math.radians(XNA2 - XNA3)
    elif XNA3 > XNA2:
        theta = math.radians(XNA3 - XNA2)
    between_distance = math.sqrt(ball_distance**2 + cup_distance**2 -2*ball_distance*cup_distance*math.cos(theta))
    included_angle = round(math.degrees(math.acos(-(cup_distance**2 - ball_distance**2 - between_distance**2)/(2*ball_distance*between_distance))))

    if included_angle <= 90:                            #예각
            rotation_theta = 90 - included_angle        #돌려야하는 각
            if XNA2 >= XNA3:                            #우타 
                roro = 100 - rotation_theta
            elif XNA3 > XNA2:                           #좌타 
                roro = 100 + rotation_theta

    elif included_angle > 90:                           #둔각 
            rotation_theta = included_angle - 90         #돌려야하는 각
            if XNA2 >= XNA3:                            #우타 
                roro = 100 + rotation_theta
            elif XNA3 > XNA2:                           #좌타 
                roro = 100 - rotation_theta

    if XNA2 >= XNA3:                                    #우타
        q.put(105)
        Tylenol(10)
        q.put(105)
        Tylenol(10)
        q.put(105)
        Tylenol(10)

    elif XNA3 > XNA2:                                   #좌타 
        q.put(106)
        Tylenol(10)
        q.put(106)
        Tylenol(10)

    q.put(124)
    q.put(roro)
    Tylenol(70)

    while True:                                                                                     ###########           공 중심에 맞추기 루프           ############
        ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
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
                                    FFL = True
                            ######################################################################        
                            if (Y_error2 < 10 and Y_error2 > -10):
                                    FFL = False
                                    FFFL = True
                            ######################################################################        
                            if (X_error2 < 10 and X_error2 > -10) and (Y_error2 < 10 and Y_error2 > -10):
                                    FFFL = False
                                    rr = 64
                                    print("run", rr)
                                    break        
                            ######################################################################      
                            if error_sign3 == 0 and FFL == False:                                        
                                print("switch 1")
                                q.put(117)          #Left                                       #57
                                Tylenol(20)
                            elif error_sign3 == 1 and FFL == False:
                                print("switch 2")
                                q.put(118)          #Right                                      #57
                                Tylenol(20)
                            elif error_sign4 == 0 and FFL == True:
                                print("switch 3")
                                q.put(107)              #foward
                                Tylenol(20)
                            elif error_sign4 == 1 and FFL == True:
                                print("switch 4")
                                q.put(108)              #backward
                                Tylenol(20)
                            elif error_sign3 == 0 and FFFL == True:
                                q.put(117)
                                Tylenol(20)
                            elif error_sign3 == 1 and FFFL == True:
                                q.put(118)
                                Tylenol(20)
                            ##############################################################################    
                            

        cv2.imshow("D3", mix3)
        cv2.imshow("output", frame)
        
    XNA = 100
    YNA = 39
    n = 15
    if between_distance<=26:
        n = 3
    elif between_distance > 26 and between_distance < 56.5:
        n = 4
    elif between_distance >= 56.5 and between_distance < 78:
        n = 5
    elif between_distance >= 78 and between_distance < 111:
        n = 6
    elif between_distance >= 111 and between_distance < 135:
        n = 7
    elif between_distance >= 135 and between_distance < 155:
        n = 8
    elif between_distance >= 155 and between_distance < 161:
        n = 9
    elif between_distance >= 161 and between_distance < 164:
        n = 10
    elif between_distance >= 164 and between_distance < 175:
        n = 11
    elif between_distance >= 175 and between_distance < 182:
        n = 12
    elif between_distance >= 182 and between_distance < 187.5:
        n = 13
    elif between_distance >= 187.5 and between_distance < 190:
        n = 14
    elif between_distance >= 190 and between_distance < 238:
        n = 15
    elif between_distance >= 238 and between_distance < 263:
        n = 6
    if XNA2 >= XNA3:                                                #우타
        if between_distance <238:
            q.put(102)
        else:
            q.put(140)
        q.put(n)
        Tylenol(90)
        while True:                                                                                     ###########           red detect loop           ############
            ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
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

            #####################################################################################    
            # ball distance
            if mask_contours:
                        largest_contour = max(mask_contours, key=cv2.contourArea)
                        M = cv2.moments(largest_contour)
                        
                        frame_pixels = frame.copy()
                        total_pixels = frame_pixels.shape[0] * frame_pixels.shape[1]
                        ball_ratio = ball_pixel_count / total_pixels * 100
                        ball_ratio = round(ball_ratio, 3)

                        if M["m00"] != 0:
                                cX = int(M["m10"] / M["m00"])
                                cY = int(M["m01"] / M["m00"])
                                cv2.circle(frame, (cX, cY), 3, (200, 200, 200), -1)

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
                                if X_error<9 and X_error>-9:
                                    XerrorF = False
                                else :
                                    XerrorF = True
                                
                                
                                if Y_error<9 and Y_error>-9:
                                    YerrorF = False
                                else :
                                    YerrorF = True
                                ######################################################################        
                                if XNA < 10:
                                    XNA = 10
                                    q.put(138)
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol(70) 
                                    XNA = 100
                                if error_sign == 0 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                    print("switch 1")
                                    XNA = XNA - 1
                                    YNA = YNA - 1
                                    q.put(121)          #Left : neck turn / DOWN : neck down                                 #53
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol(3)
                                elif error_sign == 1 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                    print("switch 2")
                                    XNA = XNA + 1
                                    YNA = YNA - 1
                                    q.put(121)          #Right : neck turn / DOWN : neck                                     #53
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol(3)
                                elif error_sign == 0 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                    print("switch 3")
                                    XNA = XNA - 1
                                    YNA = YNA + 1
                                    q.put(121)          #Left : neck turn / UP : neck UP                                     #53
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol(3)
                                elif error_sign == 1 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                    print("switch 4")
                                    XNA = XNA + 1
                                    YNA = YNA + 1
                                    q.put(121)          #Right : neck turn / UP : neck UP                                    #53
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol(3)
                                elif error_sign == 0 and (Y_error > -10 and Y_error < 10):
                                    print("switch 5")
                                    XNA = XNA - 1
                                    q.put(122)          #Left : neck turn                                                    #53
                                    q.put(XNA)
                                    Tylenol(3)
                                elif error_sign == 1 and (Y_error > -10 and Y_error < 10):
                                    print("switch 6")
                                    XNA = XNA + 1
                                    q.put(122)          #Right : neck turn                                                   #53
                                    q.put(XNA)
                                    Tylenol(3)
                                elif error_sign2 == 0 and (X_error > -10 and X_error < 10):   
                                    print("switch 7")  
                                    YNA = YNA - 1
                                    q.put(123)          #DOWN : neck down                                                    #53
                                    q.put(YNA)
                                    Tylenol(3)
                                elif error_sign2 == 1 and (X_error > -10 and X_error < 10):
                                    print("switch 8")
                                    YNA = YNA + 1
                                    q.put(123)          #UP : neck up                                                        #53
                                    q.put(YNA)
                                    Tylenol(3)
                                ##############################################################################    
                                if (X_error < 10 and X_error > -10) and (Y_error < 10 and Y_error > - 10):
                                        q.put(138)
                                        q.put(XNA)
                                        q.put(YNA)
                                        Tylenol(70)
                                        XNA = 100
                                        rr = 59
                                        break
            else :
                    if XNA == 100 and YNA == 39:
                        XNA = 70
                        YNA = 39
                        q.put(127)
                        Tylenol(15)
                    elif XNA == 70 and YNA == 39:
                        XNA = 55
                        YNA = 55
                        q.put(136)
                        Tylenol(15)
                    elif XNA ==55 and YNA == 55:
                        XNA = 10
                        YNA = 75
                        q.put(119)
                        Tylenol(15)
                        No_end_in_sight = True
                    elif No_end_in_sight == True:
                        No_end_in_sight = False
                        q.put(138)
                        q.put(XNA)
                        q.put(YNA) 
                        Tylenol(15)   
                        XNA = 100 
                    elif XNA == 100 and YNA == 75:
                        XNA = 70
                        q.put(127)
                        Tylenol(15)
                    elif XNA == 70 and YNA == 75:
                        XNA = 100
                        YNA = 39
                        q.put(121)
                        Tylenol(15)
                                        
            cv2.imshow("D3", mix3)
            cv2.imshow("output", frame)
    elif XNA3 > XNA2:                                               #좌타 
        if between_distance <238:
            q.put(139)
        else:
            q.put(141)
        q.put(n)
        Tylenol(90)
        q.put(131)
        Tylenol(10)
        while True:                                                                                     ###########           red detect loop           ############
            ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
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

            #####################################################################################    
            # ball distance
            if mask_contours:
                        largest_contour = max(mask_contours, key=cv2.contourArea)
                        M = cv2.moments(largest_contour)
                        
                        frame_pixels = frame.copy()
                        total_pixels = frame_pixels.shape[0] * frame_pixels.shape[1]
                        ball_ratio = ball_pixel_count / total_pixels * 100
                        ball_ratio = round(ball_ratio, 3)
                        if M["m00"] != 0:
                                cX = int(M["m10"] / M["m00"])
                                cY = int(M["m01"] / M["m00"])
                                cv2.circle(frame, (cX, cY), 3, (200, 200, 200), -1)
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
                                if X_error<9 and X_error>-9:
                                    XerrorF = False
                                else :
                                    XerrorF = True
                                
                                
                                if Y_error<9 and Y_error>-9:
                                    YerrorF = False
                                else :
                                    YerrorF = True
                                ######################################################################      
                                if XNA > 190:
                                    XNA = 190
                                    q.put(138)
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol(70)   
                                    XNA = 100 
                                if error_sign == 0 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                    print("switch 1")
                                    XNA = XNA - 1
                                    YNA = YNA - 1
                                    q.put(121)          #Left : neck turn / DOWN : neck down                                 #53
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol(3)
                                elif error_sign == 1 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                    print("switch 2")
                                    XNA = XNA + 1
                                    YNA = YNA - 1
                                    q.put(121)          #Right : neck turn / DOWN : neck                                     #53
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol(3)
                                elif error_sign == 0 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                    print("switch 3")
                                    XNA = XNA - 1
                                    YNA = YNA + 1
                                    q.put(121)          #Left : neck turn / UP : neck UP                                     #53
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol(3)
                                elif error_sign == 1 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                    print("switch 4")
                                    XNA = XNA + 1
                                    YNA = YNA + 1
                                    q.put(121)          #Right : neck turn / UP : neck UP                                    #53
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol(3)
                                elif error_sign == 0 and (Y_error > -10 and Y_error < 10):
                                    print("switch 5")
                                    XNA = XNA - 1
                                    q.put(122)          #Left : neck turn                                                    #53
                                    q.put(XNA)
                                    Tylenol(3)
                                elif error_sign == 1 and (Y_error > -10 and Y_error < 10):
                                    print("switch 6")
                                    XNA = XNA + 1
                                    q.put(122)          #Right : neck turn                                                   #53
                                    q.put(XNA)
                                    Tylenol(3)
                                elif error_sign2 == 0 and (X_error > -10 and X_error < 10):   
                                    print("switch 7")  
                                    YNA = YNA - 1
                                    q.put(123)          #DOWN : neck down                                                    #53
                                    q.put(YNA)
                                    Tylenol(3)
                                elif error_sign2 == 1 and (X_error > -10 and X_error < 10):
                                    print("switch 8")
                                    YNA = YNA + 1
                                    q.put(123)          #UP : neck up                                                        #53
                                    q.put(YNA)
                                    Tylenol(3)
                                ##############################################################################    
                                if (X_error < 10 and X_error > -10) and (Y_error < 10 and Y_error > - 10):
                                        q.put(135)
                                        Tylenol(10)
                                        q.put(138)
                                        q.put(XNA)
                                        q.put(YNA)
                                        Tylenol(70)
                                        XNA = 100
                                        rr = 59
                                        break
            else :
                    if XNA == 100 and YNA == 39:
                        XNA = 130
                        YNA = 39
                        q.put(132)
                        Tylenol(15)
                    elif XNA == 130 and YNA == 39:
                        XNA = 145
                        YNA = 55
                        q.put(142)
                        Tylenol(15)
                    elif XNA ==145 and YNA == 55 :
                        XNA = 190
                        YNA = 75
                        q.put(143)
                        Tylenol(15)
                        No_end_in_sight = True
                    elif No_end_in_sight == True:
                        No_end_in_sight = False
                        q.put(138)
                        q.put(XNA)
                        q.put(YNA)
                        Tylenol(70)   
                        XNA = 100 
                    elif XNA == 100 and YNA == 75:
                        XNA = 130
                        q.put(132)
                        Tylenol(15)
                    elif XNA == 130 and YNA == 75:
                        XNA = 100
                        YNA = 39
                        q.put(121)
                        Tylenol(15)
                                        
            cv2.imshow("D3", mix3)
            cv2.imshow("output", frame)
    
def Tylenol(q):                                                                                         ########### 시간 지연 루프 (지연시간) / ball ###########
        v = 0
        while True:                                                                                     ###########          red tresh loop           ############
                                    ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
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

                                    #####################################################################################
                                    # ball distance
                                    if mask_contours:
                                                largest_contour = max(mask_contours, key=cv2.contourArea)
                                                M = cv2.moments(largest_contour)
                                                
                                                frame_pixels = frame.copy()
                                                total_pixels = frame_pixels.shape[0] * frame_pixels.shape[1]
                                                ball_ratio = ball_pixel_count / total_pixels * 100
                                                ball_ratio = round(ball_ratio, 3)

                                                if M["m00"] != 0:
                                                        cX = int(M["m10"] / M["m00"])
                                                        cY = int(M["m01"] / M["m00"])
                                                        cv2.circle(frame, (cX, cY), 3, (200, 200, 200), -1)
                                    if v==q:
                                                v=0
                                                break
                                    v = v + 1
                                    cv2.imshow("D3", mix3)
                                    cv2.imshow("output", frame)
                                    
def Tylenol2(q):                                                                                         ########### 시간 지연 루프 (지연시간) / ball ###########
        v2 = 0
        while True:                                                                                     ###########          yellow tresh loop           ############
                                    ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
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
                                            v2=0
                                            break
                                    v2 = v2 + 1
                                    cv2.imshow("D3", mix3)
                                    cv2.imshow("output", frame)
                                    
def red_detect():
        global rr
        global XNA
        global YNA
        global XNA2
        global YNA2
        global theta
        global ball_distance
        q.put(131)
        Tylenol(15)
        while True:                                                                                     ###########           flag red detect loop           ############
                    ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
                    imAux = frame.copy()
                    objeto = imAux[y1:y2, x1:x2]

                    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) #BGR -> HSV

                    #hsv = (색상, 채도, 명도)

                    lower_red = (270 / 2, 80, 80)
                    upper_red = (360 / 2, 255, 255)
                    
                    lower_yellow = (45/2, 30, 160)
                    upper_yellow = (65/2, 255, 255)
                    
                    lower_green = (75/2, 80, 80)
                    upper_green = (80, 255, 255)

                    mask_red = cv2.inRange(hsv, lower_red, upper_red)
                    mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)
                    mask_green = cv2.inRange(hsv, lower_green, upper_green)

                    mask_contours, hierarchy = cv2.findContours(mask_red, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                    mask_contours2, hierarchy = cv2.findContours(mask_yellow, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                    mask_contours3, hierarchy = cv2.findContours(mask_green, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

                    res2 = cv2.bitwise_and(frame, frame, mask=mask_green)
                    res3 = cv2.bitwise_and(frame, frame, mask=mask_red)
                    res4 = cv2.bitwise_and(frame, frame, mask=mask_yellow)
                    
                    ball_pixel_count = cv2.countNonZero(mask_red)

                    cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
                    cv2.rectangle(frame, (0,100), (320,140), (255, 0, 0), 2)
                    cv2.rectangle(frame, (0,40), (320,200), (0, 0, 255), 2)
                    key = cv2.waitKey(30)
                    
                    dilation2 = cv2.dilate(res2, np.ones((3,3)), 5)
                    dilation3 = cv2.dilate(res3, np.ones((3, 3)), 5)
                    dilation4 = cv2.dilate(res4, np.ones((3, 3)), 5)
                    mix3 = cv2.erode(dilation3, np.ones((3, 3)), 5)

                    ################################################################################################
                    
                    ################################################################################################
                    cv2.imshow("D2", dilation2)
                    cv2.imshow("D3", mix3)
                    cv2.imshow("D4", dilation4)
                    cv2.imshow("output", frame)

                    #####################################################################################
                    # ball distance
                    if mask_contours:
                                largest_contour = max(mask_contours, key=cv2.contourArea)
                                M = cv2.moments(largest_contour)
                                
                                frame_pixels = frame.copy()
                                total_pixels = frame_pixels.shape[0] * frame_pixels.shape[1]
                                ball_ratio = ball_pixel_count / total_pixels * 100
                                ball_ratio = round(ball_ratio, 3)

                                if M["m00"] != 0:
                                        cX = int(M["m10"] / M["m00"])
                                        cY = int(M["m01"] / M["m00"])
                                        cv2.circle(frame, (cX, cY), 3, (200, 200, 200), -1)
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
                                        if X_error<9 and X_error>-9:
                                            XerrorF = False
                                        else :
                                            XerrorF = True
                                        
                                        
                                        if Y_error<9 and Y_error>-9:
                                            YerrorF = False
                                        else :
                                            YerrorF = True
                                        ######################################################################         
                                        if error_sign == 0 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                            print("switch 1")
                                            XNA = XNA - 1
                                            YNA = YNA - 1
                                            q.put(121)          #Left : neck turn / DOWN : neck down                                 #53
                                            q.put(XNA)
                                            q.put(YNA)
                                            Tylenol(3)
                                        elif error_sign == 1 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                            print("switch 2")
                                            XNA = XNA + 1
                                            YNA = YNA - 1
                                            q.put(121)          #Right : neck turn / DOWN : neck                                     #53
                                            q.put(XNA)
                                            q.put(YNA)
                                            Tylenol(3)
                                        elif error_sign == 0 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                            print("switch 3")
                                            XNA = XNA - 1
                                            YNA = YNA + 1
                                            q.put(121)          #Left : neck turn / UP : neck UP                                     #53
                                            q.put(XNA)
                                            q.put(YNA)
                                            Tylenol(3)
                                        elif error_sign == 1 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                            print("switch 4")
                                            XNA = XNA + 1
                                            YNA = YNA + 1
                                            q.put(121)          #Right : neck turn / UP : neck UP                                    #53
                                            q.put(XNA)
                                            q.put(YNA)
                                            Tylenol(3)
                                        elif error_sign == 0 and (Y_error > -10 and Y_error < 10):
                                            print("switch 5")
                                            XNA = XNA - 1
                                            q.put(122)          #Left : neck turn                                                    #53
                                            q.put(XNA)
                                            Tylenol(3)
                                        elif error_sign == 1 and (Y_error > -10 and Y_error < 10):
                                            print("switch 6")
                                            XNA = XNA + 1
                                            q.put(122)          #Right : neck turn                                                   #53
                                            q.put(XNA)
                                            Tylenol(3)
                                        elif error_sign2 == 0 and (X_error > -10 and X_error < 10):   
                                            print("switch 7")  
                                            YNA = YNA - 1
                                            q.put(123)          #DOWN : neck down                                                    #53
                                            q.put(YNA)
                                            Tylenol(3)
                                        elif error_sign2 == 1 and (X_error > -10 and X_error < 10):
                                            print("switch 8")
                                            YNA = YNA + 1
                                            q.put(123)          #UP : neck up                                                        #53
                                            q.put(YNA)
                                            Tylenol(3)
                                        ##############################################################################    
                                        if (X_error < 10 and X_error > -10) and (Y_error < 10 and Y_error > - 10):
                                                q.put(135)
                                                Tylenol(10)
                                                q.put(110)
                                                Tylenol(15)
                                                rr = 51
                                                XNA2 = XNA
                                                YNA2 = YNA
                                                XNA = 100
                                                YNA = 39
                                                theta = math.radians(YNA2 - 15)
                                                ball_distance = 33*math.tan(theta)
                                                print(flag_ball)
                                                break

                    cv2.imshow("D2", dilation2)
                    cv2.imshow("D3", mix3)
                    cv2.imshow("D4", dilation4)
                    cv2.imshow("output", frame)

def yellow_detect():
        global rr
        global XNA
        global YNA
        global XNA3
        global YNA3
        global theta
        global cup_distance
        q.put(131)
        Tylenol(15)
        while True:                                                                                      ###########           yellow detect loop          ############
                ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
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
                                        
                                ###################################################
                                if X_error2<9 and X_error2>-9:
                                    XerrorF2 = False
                                else :
                                    XerrorF2 = True
                            
                            
                                if Y_error2<9 and Y_error2>-9:
                                    YerrorF2 = False
                                else :
                                    YerrorF2 = True
                                ######################################################################        
                                if error_sign3 == 0 and error_sign4 == 0 and (XerrorF2 == True and YerrorF2 == True):
                                    XNA = XNA - 1
                                    YNA = YNA - 1
                                    q.put(112)          #Left : neck turn / DOWN : neck down                                 #56
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol2(3)
                                elif error_sign3 == 1 and error_sign4 == 0 and (XerrorF2 == True and YerrorF2 == True):
                                    XNA = XNA + 1
                                    YNA = YNA - 1
                                    q.put(112)          #Right : neck turn / DOWN : neck                                     #56
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol2(3)
                                elif error_sign3 == 0 and error_sign4 == 1 and (XerrorF2 == True and YerrorF2 == True):
                                    XNA = XNA - 1
                                    YNA = YNA + 1
                                    q.put(112)          #Left : neck turn / UP : neck UP                                     #56
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol2(3)
                                elif error_sign3 == 1 and error_sign4 == 1 and (XerrorF2 == True and YerrorF2 == True):
                                    XNA = XNA + 1
                                    YNA = YNA + 1
                                    q.put(112)          #Right : neck turn / UP : neck UP                                    #56
                                    q.put(XNA)
                                    q.put(YNA)
                                    Tylenol2(3)
                                elif error_sign3 == 0 and (Y_error2 > -10 and Y_error2 < 10):
                                    XNA = XNA - 1
                                    q.put(113)          #Left : neck turn                                                    #56
                                    q.put(XNA)
                                    Tylenol2(3)
                                elif error_sign3 == 1 and (Y_error2 > -10 and Y_error2 < 10):
                                    XNA = XNA + 1
                                    q.put(113)          #Right : neck turn                                                   #56
                                    q.put(XNA)
                                    Tylenol2(3)
                                elif error_sign4 == 0 and (X_error2 > -10 and X_error2 < 10):     
                                    YNA = YNA - 1
                                    q.put(114)          #DOWN : neck down                                                    #56
                                    q.put(YNA)
                                    Tylenol2(3)
                                elif error_sign4 == 1 and (X_error2 > -10 and X_error2 < 10):
                                    YNA = YNA + 1
                                    q.put(114)          #UP : neck up                                                        #56
                                    q.put(YNA)
                                    Tylenol2(3)

                                if (ccY > 110 and ccY < 130) and (ccX > 150 and ccX < 170):
                                        q.put(135)
                                        Tylenol2(10)
                                        XNA3 = XNA
                                        YNA3 = YNA
                                        theta = math.radians(YNA3 - 15)
                                        cup_distance = 33 * math.tan(theta)
                                        cup_distance = round(cup_distance, 2)
                                        rr = 56
                                        break
                cv2.imshow("D4", dilation4)     #yellow
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
def TX_data(ser, one_byte):  # one_byte= 0~255
    ser.write(serial.to_bytes([one_byte]))

def RX_Receiving(ser, q):
    global receiving_exit, threading_Time, RX, isStart

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

capture = cv2.VideoCapture(0)
capture.set(cv2.CAP_PROP_FRAME_WIDTH, 320)
capture.set(cv2.CAP_PROP_FRAME_HEIGHT, 240)
capture.set(cv2.CAP_PROP_FPS, 30)

fourcc = cv2.VideoWriter_fourcc(*'XVID')  # 영상을 기록할 코덱 설정
is_record = False  # 녹화상태는 처음엔 거짓으로 설정

count = 0
count2 = 0

x1, y1 = 290, 180
x2, y2 = 390, 280

alpha = 1
beta = 0

XNA = 100
YNA = 75

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
break_flag = False
one_more_flag = True
No_end_in_sight = False
rotation_theta = 100
rr=0
while True:                                     #################### Main Loop #####################
        if(isStart == 1):
                print("Main_LOOP_START")
                while True:
                        ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참

                        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) #BGR -> HSV

                        lower_green = (75/2, 80, 80)
                        upper_green = (80, 255, 255)

                        lower_red = (270 / 2, 80, 80)
                        upper_red = (360 / 2, 255, 255)

                        lower_yellow = (45/2, 30, 160)
                        upper_yellow = (65/2, 255, 255)

                        mask_green = cv2.inRange(hsv, lower_green, upper_green)
                        mask_red = cv2.inRange(hsv, lower_red, upper_red)
                        mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)

                        mask_contours, hierarchy = cv2.findContours(mask_red, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                        mask_contours2, hierarchy = cv2.findContours(mask_yellow, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

                        res2 = cv2.bitwise_and(frame, frame, mask=mask_green)
                        res3 = cv2.bitwise_and(frame, frame, mask=mask_red)
                        res4 = cv2.bitwise_and(frame, frame, mask=mask_yellow)

                        ball_pixel_count = cv2.countNonZero(mask_red)
                        cup_pixel_count = cv2.countNonZero(mask_yellow)

                        cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
                        cv2.rectangle(frame, (0,100), (320,140), (255, 0, 0), 2)
                        cv2.rectangle(frame, (0,40), (320,200), (0, 0, 255), 2)

                        key = cv2.waitKey(30)  # 30ms 동안 키입력 대기

                        if key == ord('p'):
                            cv2.imwrite('/Users/ice31/PycharmProjects/OPENCV_SIBAL/cv_env/Scripts/p/Positive_{}.png'.format(random.randint(0,9999)), objeto)
                        elif key == ord('n'):
                            cv2.imwrite('/Users/ice31/PycharmProjects/OPENCV_SIBAL/cv_env/Scripts/n/Negative_{}.png'.format(random.randint(0,9999)), objeto)
                        elif isStart == 2:
                            break
                        elif key == ord('a'):
                            alpha += 0.05       
                            print('a = ', alpha)
                            frame = frame * contrast + brightness
                            frame = np.clip(frame, 0, 255)
                            frame = frame.astype(np.uint8)

                        elif key == ord('s'):
                            alpha -= 0.05
                            print('a = ', alpha)
                            frame = frame * contrast + brightness
                            frame = np.clip(frame, 0, 255)
                            frame = frame.astype(np.uint8)

                        elif key == ord('d'):
                            beta += 1
                            print('B = ', beta)
                            frame = frame * contrast + brightness
                            frame = np.clip(frame, 0, 255)
                            frame = frame.astype(np.uint8)
                        elif key == ord('f'):
                            beta -= 1
                            print('B = ', beta)
                            frame = frame * contrast + brightness
                            frame = np.clip(frame, 0, 255)
                            frame = frame.astype(np.uint8)
                        
                        if break_flag == True:
                            print("finish")
                            rr = 777
                            break
                        dilation2 = cv2.dilate(res2, np.ones((3,3)), 5)   #팽창
                        dilation3 = cv2.dilate(res3, np.ones((3, 3)), 5)
                        dilation4 = cv2.dilate(res4, np.ones((3, 3)), 5)
                        mix3 = cv2.erode(dilation3, np.ones((3, 3)), 5)

                        ################################################################################################

                        ################################################################################################
                        cv2.imshow("D2", dilation2)     #green
                        cv2.imshow("D3", mix3)          #red
                        cv2.imshow("D4", dilation4)     #yellow
                        cv2.imshow("output", frame)
                        #####################################################################################

                        if mask_contours2:
                                largest_contour2 = max(mask_contours2, key=cv2.contourArea)
                                N = cv2.moments(largest_contour2)
                                
                                frame_pixels = frame.copy()
                                total_pixels = frame_pixels.shape[0] * frame_pixels.shape[1]
                                cup_ratio = cup_pixel_count / total_pixels * 100
                                cup_ratio = round(cup_ratio, 3)
                                CR = str(cup_ratio)
                                
                                if N["m00"] != 0:
                                       ccX = int(N["m10"] / N["m00"])
                                       ccY = int(N["m01"] / N["m00"])
                                       cv2.circle(frame, (ccX, ccY), 3, (200, 200, 200), -1)

                        # ball distance
                        if mask_contours :
                                        largest_contour = max(mask_contours, key=cv2.contourArea)       
                                        M = cv2.moments(largest_contour)

                                        frame_pixels = frame.copy()
                                        total_pixels = frame_pixels.shape[0] * frame_pixels.shape[1]
                                        ball_ratio = ball_pixel_count / total_pixels * 100
                                        ball_ratio = round(ball_ratio, 3)

                                        print('ball_ratio = ', ball_ratio)
                                        print('total_pixels = ', total_pixels)
                                        print('ball_pixel_count = ', ball_pixel_count)
                                        BR = str(ball_ratio)
                                        
                                        if M["m00"] != 0:
                                                cX = int(M["m10"] / M["m00"])
                                                cY = int(M["m01"] / M["m00"])
                                                cv2.circle(frame, (cX, cY), 3, (200, 200, 200), -1)
                                        
                                        if (flag_ball == True) and (rr == 51) and (flag_walk == True):              ####################################### flag loop ###################################
                                            if cY >= 0 and cY <= 240 :
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
                                                    print("flag true")
                                                    if rr == 51:
                                                        q.put(131)
                                                        Tylenol(10)
                                                        while True:                                                                                     ###########           flag red detect loop           ############
                                                                    ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
                                                                    imAux = frame.copy()
                                                                    objeto = imAux[y1:y2, x1:x2]

                                                                    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                                                                    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) #BGR -> HSV

                                                                    #hsv = (색상, 채도, 명도)

                                                                    lower_red = (270 / 2, 80, 80)
                                                                    upper_red = (360 / 2, 255, 255)
                                                                    
                                                                    lower_yellow = (45/2, 30, 160)
                                                                    upper_yellow = (65/2, 255, 255)
                                                                    
                                                                    lower_green = (75/2, 80, 80)
                                                                    upper_green = (80, 255, 255)

                                                                    mask_red = cv2.inRange(hsv, lower_red, upper_red)
                                                                    mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)
                                                                    mask_green = cv2.inRange(hsv, lower_green, upper_green)

                                                                    mask_contours, hierarchy = cv2.findContours(mask_red, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                                                                    mask_contours2, hierarchy = cv2.findContours(mask_yellow, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                                                                    mask_contours3, hierarchy = cv2.findContours(mask_green, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

                                                                    res2 = cv2.bitwise_and(frame, frame, mask=mask_green)
                                                                    res3 = cv2.bitwise_and(frame, frame, mask=mask_red)
                                                                    res4 = cv2.bitwise_and(frame, frame, mask=mask_yellow)
                                                                    
                                                                    ball_pixel_count = cv2.countNonZero(mask_red)

                                                                    cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
                                                                    cv2.rectangle(frame, (0,100), (320,140), (255, 0, 0), 2)
                                                                    cv2.rectangle(frame, (0,40), (320,200), (0, 0, 255), 2)
                                                                    key = cv2.waitKey(30)
                                                                    
                                                                    dilation2 = cv2.dilate(res2, np.ones((3,3)), 5)
                                                                    dilation3 = cv2.dilate(res3, np.ones((3, 3)), 5)
                                                                    dilation4 = cv2.dilate(res4, np.ones((3, 3)), 5)
                                                                    mix3 = cv2.erode(dilation3, np.ones((3, 3)), 5)

                                                                    ################################################################################################
                                                                    
                                                                    ################################################################################################
                                                                    cv2.imshow("D2", dilation2)
                                                                    cv2.imshow("D3", mix3)
                                                                    cv2.imshow("D4", dilation4)
                                                                    cv2.imshow("output", frame)

                                                                    #####################################################################################
                                                                    if mask_contours and mask_contours2 and one_more_flag == True: # and mask_contours3:                     #세레머니 하기 위한 조건

                                                                                red_detect()
                                                                                yellow_detect()
                                                                                if XNA2 >= XNA3:              #ball이 홀컵보다 오른쪽에 위치할 때 (로봇기준)
                                                                                    theta = math.radians(XNA2 - XNA3)
                                                                                elif XNA3 > XNA2:
                                                                                    theta = math.radians(XNA3 - XNA2)
                                                                                between_distance = math.sqrt(ball_distance**2 + cup_distance**2 -2*ball_distance*cup_distance*math.cos(theta))
                                                                                print("bxcvbx = ", between_distance)
                                                                                if between_distance <= 5:
                                                                                    print("in")
                                                                                    q.put(100)
                                                                                    Tylenol(20)
                                                                                    rr = 777
                                                                                    break_flag = True
                                                                                    break
                                                                                else:
                                                                                    XNA = 100
                                                                                    YNA = 39
                                                                                    q.put(110)
                                                                                    Tylenol(20)
                                                                                    one_more_flag = False
                                                                    # ball distance
                                                                    elif mask_contours:
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
                                                                                        if X_error<9 and X_error>-9:
                                                                                            XerrorF = False
                                                                                        else :
                                                                                            XerrorF = True
                                                                                        
                                                                                        
                                                                                        if Y_error<9 and Y_error>-9:
                                                                                            YerrorF = False
                                                                                        else :
                                                                                            YerrorF = True
                                                                                        ######################################################################         
                                                                                        if error_sign == 0 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                                                                            XNA = XNA - 1
                                                                                            YNA = YNA - 1
                                                                                            q.put(121)          #Left : neck turn / DOWN : neck down                                 #53
                                                                                            q.put(XNA)
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 1 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                                                                            XNA = XNA + 1
                                                                                            YNA = YNA - 1
                                                                                            q.put(121)          #Right : neck turn / DOWN : neck                                     #53
                                                                                            q.put(XNA)
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 0 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                                                                            XNA = XNA - 1
                                                                                            YNA = YNA + 1
                                                                                            q.put(121)          #Left : neck turn / UP : neck UP                                     #53
                                                                                            q.put(XNA)
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 1 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                                                                            XNA = XNA + 1
                                                                                            YNA = YNA + 1
                                                                                            q.put(121)          #Right : neck turn / UP : neck UP                                    #53
                                                                                            q.put(XNA)
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 0 and (Y_error > -10 and Y_error < 10):
                                                                                            XNA = XNA - 1
                                                                                            q.put(122)          #Left : neck turn                                                    #53
                                                                                            q.put(XNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 1 and (Y_error > -10 and Y_error < 10):
                                                                                            XNA = XNA + 1
                                                                                            q.put(122)          #Right : neck turn                                                   #53
                                                                                            q.put(XNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign2 == 0 and (X_error > -10 and X_error < 10):
                                                                                            YNA = YNA - 1
                                                                                            q.put(123)          #DOWN : neck down                                                    #53
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign2 == 1 and (X_error > -10 and X_error < 10):
                                                                                            print("switch 8")
                                                                                            YNA = YNA + 1
                                                                                            q.put(123)          #UP : neck up                                                        #53
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        ##############################################################################    
                                                                                        if (X_error < 10 and X_error > -10) and (Y_error < 10 and Y_error > - 10):
                                                                                                q.put(135)
                                                                                                Tylenol(10)
                                                                                                q.put(124)                                                                           #51
                                                                                                q.put(XNA)
                                                                                                XNA2 = XNA
                                                                                                YNA2 = YNA
                                                                                                print("@@@ball_distance = ", ball_distance)
                                                                                                print("$$$$$$$$$$$$$$$$$tresh loop$$$$$$$$$$$$$$$$$$$$$$$")
                                                                                                Tylenol(30)
                                                                                                flag_ball = False
                                                                                                flag_walk = False
                                                                                                XNA = 100
                                                                                                YNA = 39
                                                                                                theta = math.radians(YNA - 15)
                                                                                                ball_distance = 33*math.tan(theta)
                                                                                                print(flag_ball)
                                                                                                print("Escape_Escape")
                                                                                                if one_more_flag == False:
                                                                                                    rr = 66
                                                                                                one_more_flag = True
                                                                                                break

                                                                    cv2.imshow("D2", dilation2)
                                                                    cv2.imshow("D3", mix3)
                                                                    cv2.imshow("D4", dilation4)
                                                                    cv2.imshow("output", frame)

                                                        print("###ball_distance = ", ball_distance)
                                        
                                        if cY >= 100 and cY <= 140 :
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
                                            
                                            if rr == 54 or rr == 59:

                                                q.put(131)
                                                Tylenol(10)
                                                while True:                                                                                     ###########           main red detect loop           ############
                                                            ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
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
                                                                                if X_error<9 and X_error>-9:
                                                                                    XerrorF = False
                                                                                else :
                                                                                    XerrorF = True
                                                                                
                                                                                
                                                                                if Y_error<9 and Y_error>-9:
                                                                                    YerrorF = False
                                                                                else :
                                                                                    YerrorF = True
                                                                                ######################################################################         
                                                                                if error_sign == 0 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                                                                    XNA = XNA - 1
                                                                                    YNA = YNA - 1
                                                                                    q.put(121)          #Left : neck turn / DOWN : neck down                                 #53
                                                                                    q.put(XNA)
                                                                                    q.put(YNA)
                                                                                    Tylenol(3)
                                                                                elif error_sign == 1 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                                                                    XNA = XNA + 1
                                                                                    YNA = YNA - 1
                                                                                    q.put(121)          #Right : neck turn / DOWN : neck                                     #53
                                                                                    q.put(XNA)
                                                                                    q.put(YNA)
                                                                                    Tylenol(3)
                                                                                elif error_sign == 0 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                                                                    XNA = XNA - 1
                                                                                    YNA = YNA + 1
                                                                                    q.put(121)          #Left : neck turn / UP : neck UP                                     #53
                                                                                    q.put(XNA)
                                                                                    q.put(YNA)
                                                                                    Tylenol(3)
                                                                                elif error_sign == 1 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                                                                    XNA = XNA + 1
                                                                                    YNA = YNA + 1
                                                                                    q.put(121)          #Right : neck turn / UP : neck UP                                    #53
                                                                                    q.put(XNA)
                                                                                    q.put(YNA)
                                                                                    Tylenol(3)
                                                                                elif error_sign == 0 and (Y_error > -10 and Y_error < 10):
                                                                                    XNA = XNA - 1
                                                                                    q.put(122)          #Left : neck turn                                                    #53
                                                                                    q.put(XNA)
                                                                                    Tylenol(3)
                                                                                elif error_sign == 1 and (Y_error > -10 and Y_error < 10):
                                                                                    XNA = XNA + 1
                                                                                    q.put(122)          #Right : neck turn                                                   #53
                                                                                    q.put(XNA)
                                                                                    Tylenol(3)
                                                                                elif error_sign2 == 0 and (X_error > -10 and X_error < 10):   
                                                                                    print("switch 7")  
                                                                                    YNA = YNA - 1
                                                                                    q.put(123)          #DOWN : neck down                                                    #53
                                                                                    q.put(YNA)
                                                                                    Tylenol(3)
                                                                                elif error_sign2 == 1 and (X_error > -10 and X_error < 10):
                                                                                    print("switch 8")
                                                                                    YNA = YNA + 1
                                                                                    q.put(123)          #UP : neck up                                                        #53
                                                                                    q.put(YNA)
                                                                                    Tylenol(3)
                                                                                ##############################################################################    
                                                                                if (X_error < 10 and X_error > -10) and (Y_error < 10 and Y_error > - 10):
                                                                                        q.put(135)
                                                                                        Tylenol(10)
                                                                                        q.put(120)                                                                           #51
                                                                                        q.put(XNA)
                                                                                        print("@@@ball_distance = ", ball_distance)
                                                                                        print("$$$$$$$$$$$$$$$$$tresh loop22$$$$$$$$$$$$$$$$$$$$$$$")
                                                                                        Tylenol(30)
                                                                                        XNA = 100
                                                                                        YNA = 39
                                                                                        print("Escape_Escape")
                                                                                        flag_ball = True
                                                                                        break

                                                            cv2.imshow("D3", mix3)
                                                            cv2.imshow("output", frame)   
                                                
                                                print("Distance_num = ", ball_distance_num)
                                                print("Distance = ", ball_distance)            
                                                print('\033[95m'+'###rr### = ' + '\033[0m', rr)
                                            elif rr == 66:
                                                body_array_loop()
                                            elif rr == 51 and (ball_distance <= 16.0 and ball_distance >= 13.0):   
                                                
                                                #노란색 색 검출하고 노란색 원 찾아서 원 중심 찾아야함. 노란색 찾아 노란색 찾아 노란색 찾아 노란색 찾아 노란색 찾아
                                                print("cup_pixel = ", cup_pixel_count)
                                                q.put(131)
                                                Tylenol(10)
                                                while True:                                                                                     ###########           red detect loop           ############
                                                                    ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
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
                                                                                        if X_error<9 and X_error>-9:
                                                                                            XerrorF = False
                                                                                        else :
                                                                                            XerrorF = True
                                                                                        
                                                                                        
                                                                                        if Y_error<9 and Y_error>-9:
                                                                                            YerrorF = False
                                                                                        else :
                                                                                            YerrorF = True
                                                                                        ######################################################################         
                                                                                        if error_sign == 0 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                                                                            XNA = XNA - 1
                                                                                            YNA = YNA - 1
                                                                                            q.put(121)          #Left : neck turn / DOWN : neck down                                 #53
                                                                                            q.put(XNA)
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 1 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                                                                            XNA = XNA + 1
                                                                                            YNA = YNA - 1
                                                                                            q.put(121)          #Right : neck turn / DOWN : neck                                     #53
                                                                                            q.put(XNA)
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 0 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                                                                            XNA = XNA - 1
                                                                                            YNA = YNA + 1
                                                                                            q.put(121)          #Left : neck turn / UP : neck UP                                     #53
                                                                                            q.put(XNA)
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 1 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                                                                            XNA = XNA + 1
                                                                                            YNA = YNA + 1
                                                                                            q.put(121)          #Right : neck turn / UP : neck UP                                    #53
                                                                                            q.put(XNA)
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 0 and (Y_error > -10 and Y_error < 10):
                                                                                            XNA = XNA - 1
                                                                                            q.put(122)          #Left : neck turn                                                    #53
                                                                                            q.put(XNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 1 and (Y_error > -10 and Y_error < 10):
                                                                                            XNA = XNA + 1
                                                                                            q.put(122)          #Right : neck turn                                                   #53
                                                                                            q.put(XNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign2 == 0 and (X_error > -10 and X_error < 10):
                                                                                            YNA = YNA - 1
                                                                                            q.put(123)          #DOWN : neck down                                                    #53
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign2 == 1 and (X_error > -10 and X_error < 10):
                                                                                            YNA = YNA + 1
                                                                                            q.put(123)          #UP : neck up                                                        #53
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        ##############################################################################    
                                                                                        if (X_error < 10 and X_error > -10) and (Y_error < 10 and Y_error > - 10):
                                                                                                XNA2 = XNA
                                                                                                YNA2 = YNA
                                                                                                theta = math.radians(YNA - 15)
                                                                                                ball_distance = 33*math.tan(theta)
                                                                                                print(flag_ball)
                                                                                                print("Escape_Escape")
                                                                                                break

                                                                    cv2.imshow("D3", mix3)
                                                                    cv2.imshow("output", frame)
                                                while True:                                                                                      ###########           yellow detect loop          ############
                                                            ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
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
                                                                                    
                                                                            ###################################################
                                                                            if X_error2<9 and X_error2>-9:
                                                                                XerrorF2 = False
                                                                            else :
                                                                                XerrorF2 = True
                                                                        
                                                                        
                                                                            if Y_error2<9 and Y_error2>-9:
                                                                                YerrorF2 = False
                                                                            else :
                                                                                YerrorF2 = True
                                                                            ######################################################################        
                                                                            if error_sign3 == 0 and error_sign4 == 0 and (XerrorF2 == True and YerrorF2 == True):
                                                                                XNA = XNA - 1
                                                                                YNA = YNA - 1
                                                                                q.put(112)          #Left : neck turn / DOWN : neck down                                 #56
                                                                                q.put(XNA)
                                                                                q.put(YNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign3 == 1 and error_sign4 == 0 and (XerrorF2 == True and YerrorF2 == True):
                                                                                XNA = XNA + 1
                                                                                YNA = YNA - 1
                                                                                q.put(112)          #Right : neck turn / DOWN : neck                                     #56
                                                                                q.put(XNA)
                                                                                q.put(YNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign3 == 0 and error_sign4 == 1 and (XerrorF2 == True and YerrorF2 == True):
                                                                                XNA = XNA - 1
                                                                                YNA = YNA + 1
                                                                                q.put(112)          #Left : neck turn / UP : neck UP                                     #56
                                                                                q.put(XNA)
                                                                                q.put(YNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign3 == 1 and error_sign4 == 1 and (XerrorF2 == True and YerrorF2 == True):
                                                                                XNA = XNA + 1
                                                                                YNA = YNA + 1
                                                                                q.put(112)          #Right : neck turn / UP : neck UP                                    #56
                                                                                q.put(XNA)
                                                                                q.put(YNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign3 == 0 and (Y_error2 > -10 and Y_error2 < 10):
                                                                                XNA = XNA - 1
                                                                                q.put(113)          #Left : neck turn                                                    #56
                                                                                q.put(XNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign3 == 1 and (Y_error2 > -10 and Y_error2 < 10):
                                                                                XNA = XNA + 1
                                                                                q.put(113)          #Right : neck turn                                                   #56
                                                                                q.put(XNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign4 == 0 and (X_error2 > -10 and X_error2 < 10):     
                                                                                YNA = YNA - 1
                                                                                q.put(114)          #DOWN : neck down                                                    #56
                                                                                q.put(YNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign4 == 1 and (X_error2 > -10 and X_error2 < 10):
                                                                                YNA = YNA + 1
                                                                                q.put(114)          #UP : neck up                                                        #56
                                                                                q.put(YNA)
                                                                                Tylenol2(3)
                                  
                                                                            if (ccY > 110 and ccY < 130) and (ccX > 150 and ccX < 170):
                                                                                    q.put(135)
                                                                                    Tylenol(10)
                                                                                    XNA3 = XNA
                                                                                    YNA3 = YNA
                                                                                    theta = math.radians(YNA - 15)
                                                                                    cup_distance = 33 * math.tan(theta)
                                                                                    cup_distance = round(cup_distance, 2)
                                                                                    print("Escape")
                                                                                    rr = 56
                                                                                    break
                                                            else :
                                                                            if (XNA == 100) or FL == True :
                                                                                XNA = 70
                                                                                FL = False
                                                                                q.put(127)        
                                                                                Tylenol2(20)
                                                                            elif XNA == 70:
                                                                                XNA = 40
                                                                                q.put(129)
                                                                                Tylenol2(20)
                                                                            elif XNA == 40 and flag1 == False:                    #########################
                                                                                XNA = 10
                                                                                q.put(128) 
                                                                                Tylenol2(20)
                                                                            elif (XNA == 10) or (XNA == 40 and YNA == 39):
                                                                                XNA = 130
                                                                                q.put(132)
                                                                                Tylenol2(20)
                                                                            elif XNA == 130:
                                                                                XNA = 160
                                                                                q.put(133)
                                                                                Tylenol2(20)
                                                                            elif XNA == 160 and flag1 == False:                   ##########################
                                                                                XNA = 190
                                                                                q.put(130)
                                                                                Tylenol2(10)
                                                                            elif (XNA == 160 and YNA == 39):
                                                                                XNA = 100
                                                                                YNA = 75
                                                                                q.put(111)
                                                                                Tylenol2(20)
                                                                                if flag1 == True:
                                                                                        flag1 = False
                                                                                elif flag1 == False:
                                                                                        flag1 = True
                                                                            elif (XNA == 190 and YNA == 75):
                                                                                XNA = 100
                                                                                YNA = 100
                                                                                q.put(134)
                                                                                Tylenol2(20)
                                                                                
                                                                            elif (XNA == 190 and YNA == 100):
                                                                                XNA = 100
                                                                                YNA = 39
                                                                                q.put(110)
                                                                                Tylenol2(20)
                                                                                if flag1 == True:
                                                                                        flag1 = False
                                                                                elif flag1 == False:
                                                                                        flag1 = True
                                                                                        
                                                            cv2.imshow("D4", dilation4)     #yellow
                                                            cv2.imshow("output", frame)
                                                
                                            elif rr == 56:
                                                    print("go go go")       
                                                    body_array_loop()

                                            ##########################################################
                                            
                                            print('\033[93m'+'1111111111111111111111111111111111111111111 = ''\033[0m', rr)
                                        elif rr == 56:
                                                    print("go go go")
                                                    body_array_loop()
                                        else:                                                                   ############################### walk loop - 공 보일 때 ##############################

                                            while True :                                                                                        ###########           walk loop           ############
                                                    ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
                                                    print('\033[93m'+'@@@@@@@@@@@@ballllllllllllllllllllllllll@@@@@@@ '+'\033[93m', rr)

                                                    imAux = frame.copy()

                                                    objeto = imAux[y1:y2, x1:x2]

                                                    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                                                    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) #BGR -> HSV

                                                    #hsv = (색상, 채도, 명도)

                                                    lower_green = (75/2, 80, 80)
                                                    upper_green = (80, 255, 255)

                                                    lower_red = (270 / 2, 80, 80)
                                                    upper_red = (360 / 2, 255, 255)

                                                    lower_yellow = (45/2, 30, 160)
                                                    upper_yellow = (65/2, 255, 255)

                                                    mask_green = cv2.inRange(hsv, lower_green, upper_green)
                                                    mask_red = cv2.inRange(hsv, lower_red, upper_red)
                                                    mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)

                                                    mask_contours, hierarchy = cv2.findContours(mask_red, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                                                    mask_contours2, hierarchy = cv2.findContours(mask_yellow, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                                                    
                                                    res2 = cv2.bitwise_and(frame, frame, mask=mask_green)
                                                    res3 = cv2.bitwise_and(frame, frame, mask=mask_red)
                                                    res4 = cv2.bitwise_and(frame, frame, mask=mask_yellow)

                                                    ball_pixel_count = cv2.countNonZero(mask_red)
                                                    cup_pixel_count = cv2.countNonZero(mask_yellow)
                                                    
                                                    cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
                                                    cv2.rectangle(frame, (0,100), (320,140), (255, 0, 0), 2)
                                                    cv2.rectangle(frame, (0,40), (320,200), (0, 0, 255), 2)
                                                    key = cv2.waitKey(30)
                                                    
                                                    dilation2 = cv2.dilate(res2, np.ones((3,3)), 5)   #팽창
                                                    dilation3 = cv2.dilate(res3, np.ones((3, 3)), 5)
                                                    dilation4 = cv2.dilate(res4, np.ones((3, 3)), 5)
                                                    mix3 = cv2.erode(dilation3, np.ones((3, 3)), 5)

                                                    ################################################################################################

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
                                                            BR = str(ball_ratio)

                                                            if M["m00"] != 0:
                                                                    cX = int(M["m10"] / M["m00"])
                                                                    cY = int(M["m01"] / M["m00"])
                                                                    cv2.circle(frame, (cX, cY), 3, (200, 200, 200), -1)
                                                                    
                                                                    if rr == 51:
                                                                        cX=0
                                                                        cY=0
                                                                    
                                                                    print("XNA = ", XNA)
                                                                    print("YNA = ", YNA)
                                                                    if flag_ball == False and (cY >= 100 and cY <= 140):
                                                                            
                                                                                if YNA == 39 or YNA == 55:
                                                                                        print("@@1ball_distance = ", ball_distance)
                                                                                        rr = 51
                                                                                        print('\033[31m'+'############################################################################################''\033[0m')
                                                                                        break

                                                                                elif YNA == 75:
                                                                                        print("@@2ball_distance = ", ball_distance)
                                                                                        rr = 54
                                                                                        print('\033[31m'+'############################################################################################''\033[0m')
                                                                                        break
                                                                    elif (flag_ball == True) and (cY >= 40 and cY <= 110) :
                                                                            if YNA == 39 or YNA == 55:
                                                                                    q.put(107)
                                                                                    Tylenol(10)
                                                                            elif YNA == 75:
                                                                                    q.put(107)
                                                                                    Tylenol(10)
                                                                    elif (flag_ball == True) and (cY >= 130 and cY <= 200) :
                                                                            if YNA == 39 or YNA == 55:
                                                                                    q.put(108)
                                                                                    Tylenol(10)
                                                                            elif YNA == 75:
                                                                                    q.put(108)
                                                                                    Tylenol(10)
                                                                    elif (flag_ball == True) and (cY >= 110 and cY <= 130) :
                                                                            if YNA == 39 or YNA == 55:

                                                                                    flag_walk = True
                                                                                    print("cX = ", cX)
                                                                                    print("cY = ", cY)
                                                                                    print("@@3ball_distance = ", ball_distance)
                                                                                    rr = 51
                                                                                    print('\033[31m'+'############################################################################################''\033[0m')
                                                                                    break

                                                                            elif YNA == 75:
                                                                                    flag_walk = True
                                                                                    print("@@4ball_distance = ", ball_distance)
                                                                                    rr = 54
                                                                                    print('\033[31m'+'############################################################################################''\033[0m')
                                                                                    break 
                                                                    else:
                                                                        q.put(109)
                                                                        Tylenol(10)
                                                                    
                                                                       
                                                    else :
                                                             if rr == 51 or rr == 54 or rr == 7:
                                                                        q.put(109)
                                                                        Tylenol(10)
                                                             
                                 
                                                    cv2.imshow("D2", dilation2)     #green
                                                    cv2.imshow("D3", mix3)          #red
                                                    cv2.imshow("D4", dilation4)     #yellow

                                                    cv2.imshow("output", frame)  # 현재 시간을 표시하는 글자를 써준 영상 출력      
                                   
                        elif rr == 50 or rr == 51 or rr == 54 or rr == 59 or rr == 7:                                       ############################### walk loop - 공 안보일 때 ###################################
                                    while True :                                                                                        ###########           walk loop           ############
                                            ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
                                            print('\033[93m'+'@@@@@@bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbball@@@@@@@@@@@@@ '+'\033[93m', rr)
                                            imAux = frame.copy()

                                            objeto = imAux[y1:y2, x1:x2]

                                            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                                            hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) #BGR -> HSV

                                            #hsv = (색상, 채도, 명도)

                                            lower_green = (75/2, 80, 80)
                                            upper_green = (80, 255, 255)

                                            lower_red = (270 / 2, 80, 80)
                                            upper_red = (360 / 2, 255, 255)

                                            lower_yellow = (45/2, 30, 160)
                                            upper_yellow = (65/2, 255, 255)

                                            mask_green = cv2.inRange(hsv, lower_green, upper_green)
                                            mask_red = cv2.inRange(hsv, lower_red, upper_red)
                                            mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)

                                            mask_contours, hierarchy = cv2.findContours(mask_red, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                                            mask_contours2, hierarchy = cv2.findContours(mask_yellow, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                                            
                                            res2 = cv2.bitwise_and(frame, frame, mask=mask_green)
                                            res3 = cv2.bitwise_and(frame, frame, mask=mask_red)
                                            res4 = cv2.bitwise_and(frame, frame, mask=mask_yellow)

                                            ball_pixel_count = cv2.countNonZero(mask_red)
                                            cup_pixel_count = cv2.countNonZero(mask_yellow)
                                            
                                            cv2.circle(frame, (160, 120), 10, (0, 0, 0), 2)
                                            cv2.rectangle(frame, (0,110), (320,130), (255, 0, 0), 2)
                                            cv2.rectangle(frame, (0,40), (320,200), (0, 0, 255), 2)
                                            key = cv2.waitKey(30)
                                            
                                            dilation2 = cv2.dilate(res2, np.ones((3,3)), 5)   #팽창
                                            dilation3 = cv2.dilate(res3, np.ones((3, 3)), 5)
                                            dilation4 = cv2.dilate(res4, np.ones((3, 3)), 5)
                                            mix3 = cv2.erode(dilation3, np.ones((3, 3)), 5)

                                            ################################################################################################

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
                                                    BR = str(ball_ratio)
                                                    
                                                    if M["m00"] != 0:
                                                            cX = int(M["m10"] / M["m00"])
                                                            cY = int(M["m01"] / M["m00"])
                                                            cv2.circle(frame, (cX, cY), 3, (200, 200, 200), -1)
                                                            
                                                            print("XNA = ", XNA)
                                                            print("YNA = ", YNA)
                                                            if flag_ball == False and (cY >= 100 and cY <= 140):
                                                                    
                                                                        if YNA == 39 or YNA == 55:
                                                                                print("@@1ball_distance = ", ball_distance)
                                                                                rr = 51
                                                                                print('\033[31m'+'############################################################################################''\033[0m')
                                                                                break

                                                                        elif YNA == 75:
                                                                                print("@@2ball_distance = ", ball_distance)
                                                                                rr = 54
                                                                                print('\033[31m'+'############################################################################################''\033[0m')
                                                                                break
                                                            elif (flag_ball == True) and (cY >= 0 and cY <= 110) :
                                                                        if YNA == 39 or YNA == 55:
                                                                                q.put(107)
                                                                                Tylenol(10)
                                                                        elif YNA == 75:
                                                                                q.put(107)
                                                                                Tylenol(10)
                                                            elif (flag_ball == True) and (cY >= 130 and cY <= 240) :
                                                                        if YNA == 39 or YNA == 55:
                                                                                q.put(108)
                                                                                Tylenol(10)
                                                                        elif YNA == 75:
                                                                                q.put(108)
                                                                                Tylenol(10)
                                                            elif (flag_ball == True) and (cY >= 110 and cY <= 130) :
                                                                        if YNA == 39 or YNA == 55:
                                                                                flag_walk = True
                                                                                print("@@3ball_distance = ", ball_distance)
                                                                                rr = 51
                                                                                print('\033[31m'+'############################################################################################''\033[0m')
                                                                                break

                                                                        elif YNA == 75:
                                                                                flag_walk = True
                                                                                print("@@4ball_distance = ", ball_distance)
                                                                                rr = 54
                                                                                print('\033[31m'+'############################################################################################''\033[0m')
                                                                                break

                                                            else :
                                                                print("!!!!!!!!!!!!!")
                                                                q.put(109)
                                                                Tylenol(10)
                                                            
                                                                
                                            else :
                                                     if rr == 51 or rr == 54 or rr == 7 or rr == 59:
                                                                q.put(109)
                                                                Tylenol(10)
                                                     
                         
                                            cv2.imshow("D2", dilation2)     #green
                                            cv2.imshow("D3", mix3)          #red
                                            cv2.imshow("D4", dilation4)     #yellow

                                            cv2.imshow("output", frame)  # 현재 시간을 표시하는 글자를 써준 영상 출력
                        elif rr == 66:
                                body_array_loop()
                        elif rr == 51 and (ball_distance <= 16.0 and ball_distance >= 13.0):                     ############################### yellow detect loop #############################
                                q.put(131)
                                Tylenol(10)
                                while True:                                                                                     ###########           red detect loop           ############
                                                                    ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
                                                                    print('\033[93m'+'**********flag ball******************* '+'\033[93m', rr)
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
                                                                                        if X_error<9 and X_error>-9:
                                                                                            XerrorF = False
                                                                                        else :
                                                                                            XerrorF = True
                                                                                        
                                                                                        
                                                                                        if Y_error<9 and Y_error>-9:
                                                                                            YerrorF = False
                                                                                        else :
                                                                                            YerrorF = True
                                                                                        ######################################################################         
                                                                                        if error_sign == 0 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                                                                            XNA = XNA - 1
                                                                                            YNA = YNA - 1
                                                                                            q.put(121)          #Left : neck turn / DOWN : neck down                                 #53
                                                                                            q.put(XNA)
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 1 and error_sign2 == 0 and (XerrorF == True and YerrorF == True):
                                                                                            XNA = XNA + 1
                                                                                            YNA = YNA - 1
                                                                                            q.put(121)          #Right : neck turn / DOWN : neck                                     #53
                                                                                            q.put(XNA)
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 0 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                                                                            XNA = XNA - 1
                                                                                            YNA = YNA + 1
                                                                                            q.put(121)          #Left : neck turn / UP : neck UP                                     #53
                                                                                            q.put(XNA)
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 1 and error_sign2 == 1 and (XerrorF == True and YerrorF == True):
                                                                                            XNA = XNA + 1
                                                                                            YNA = YNA + 1
                                                                                            q.put(121)          #Right : neck turn / UP : neck UP                                    #53
                                                                                            q.put(XNA)
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 0 and (Y_error > -10 and Y_error < 10):
                                                                                            XNA = XNA - 1
                                                                                            q.put(122)          #Left : neck turn                                                    #53
                                                                                            q.put(XNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign == 1 and (Y_error > -10 and Y_error < 10):
                                                                                            XNA = XNA + 1
                                                                                            q.put(122)          #Right : neck turn                                                   #53
                                                                                            q.put(XNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign2 == 0 and (X_error > -10 and X_error < 10):
                                                                                            YNA = YNA - 1
                                                                                            q.put(123)          #DOWN : neck down                                                    #53
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        elif error_sign2 == 1 and (X_error > -10 and X_error < 10):
                                                                                            YNA = YNA + 1
                                                                                            q.put(123)          #UP : neck up                                                        #53
                                                                                            q.put(YNA)
                                                                                            Tylenol(3)
                                                                                        ##############################################################################    
                                                                                        if (X_error < 10 and X_error > -10) and (Y_error < 10 and Y_error > - 10):
                                                                                                XNA2 = XNA
                                                                                                YNA2 = YNA
                                                                                                XNA = 100
                                                                                                YNA = 39
                                                                                                theta = math.radians(YNA - 15)
                                                                                                ball_distance = 33*math.tan(theta)
                                                                                                print(flag_ball)
                                                                                                print("Escape_Escape")
                                                                                                break

                                                                    cv2.imshow("D3", mix3)
                                                                    cv2.imshow("output", frame)
                                while True:                                                                                      ###########           yellow detect loop          ############
                                                            ret, frame = capture.read()     # 카메라로부터 현재 영상을 받아 frame에 저장, 잘 받았다면 ret가 참
                                                            print('\033[92m'+'???????????????? ''\033[0m', rr)
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
                                                                                    
                                                                            ###################################################
                                                                            if X_error2<9 and X_error2>-9:
                                                                                XerrorF2 = False
                                                                            else :
                                                                                XerrorF2 = True
                                                                        
                                                                        
                                                                            if Y_error2<9 and Y_error2>-9:
                                                                                YerrorF2 = False
                                                                            else :
                                                                                YerrorF2 = True
                                                                            ######################################################################        
                                                                            if error_sign3 == 0 and error_sign4 == 0 and (XerrorF2 == True and YerrorF2 == True):
                                                                                XNA = XNA - 1
                                                                                YNA = YNA - 1
                                                                                q.put(112)          #Left : neck turn / DOWN : neck down                                 #56
                                                                                q.put(XNA)
                                                                                q.put(YNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign3 == 1 and error_sign4 == 0 and (XerrorF2 == True and YerrorF2 == True):
                                                                                XNA = XNA + 1
                                                                                YNA = YNA - 1
                                                                                q.put(112)          #Right : neck turn / DOWN : neck                                     #56
                                                                                q.put(XNA)
                                                                                q.put(YNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign3 == 0 and error_sign4 == 1 and (XerrorF2 == True and YerrorF2 == True):
                                                                                XNA = XNA - 1
                                                                                YNA = YNA + 1
                                                                                q.put(112)          #Left : neck turn / UP : neck UP                                     #56
                                                                                q.put(XNA)
                                                                                q.put(YNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign3 == 1 and error_sign4 == 1 and (XerrorF2 == True and YerrorF2 == True):
                                                                                XNA = XNA + 1
                                                                                YNA = YNA + 1
                                                                                q.put(112)          #Right : neck turn / UP : neck UP                                    #56
                                                                                q.put(XNA)
                                                                                q.put(YNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign3 == 0 and (Y_error2 > -10 and Y_error2 < 10):
                                                                                XNA = XNA - 1
                                                                                q.put(113)          #Left : neck turn                                                    #56
                                                                                q.put(XNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign3 == 1 and (Y_error2 > -10 and Y_error2 < 10):
                                                                                XNA = XNA + 1
                                                                                q.put(113)          #Right : neck turn                                                   #56
                                                                                q.put(XNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign4 == 0 and (X_error2 > -10 and X_error2 < 10):     
                                                                                YNA = YNA - 1
                                                                                q.put(114)          #DOWN : neck down                                                    #56
                                                                                q.put(YNA)
                                                                                Tylenol2(3)
                                                                            elif error_sign4 == 1 and (X_error2 > -10 and X_error2 < 10):
                                                                                YNA = YNA + 1
                                                                                q.put(114)          #UP : neck up                                                        #56
                                                                                q.put(YNA)
                                                                                Tylenol2(3)
                                  
                                                                            if (ccY > 110 and ccY < 130) and (ccX > 150 and ccX < 170):
                                                                                    q.put(135)
                                                                                    Tylenol(10)
                                                                                    cup_distance = 33 * math.tan(YNA)
                                                                                    cup_distance = round(cup_distance, 2)
                                                                                    print("Escape")
                                                                                    break
                                                            else :
                                                                            if (XNA == 100) or FL == True :
                                                                                XNA = 70
                                                                                FL = False
                                                                                q.put(127)        
                                                                                Tylenol2(20)
                                                                            elif XNA == 70:
                                                                                XNA = 40
                                                                                q.put(129)
                                                                                Tylenol2(20)
                                                                            elif XNA == 40 and flag1 == False:                    #########################
                                                                                XNA = 10
                                                                                q.put(128) 
                                                                                Tylenol2(20)
                                                                            elif (XNA == 10) or (XNA == 40 and YNA == 39):
                                                                                XNA = 130
                                                                                q.put(132)
                                                                                Tylenol2(20)
                                                                            elif XNA == 130:
                                                                                XNA = 160
                                                                                q.put(133)
                                                                                Tylenol2(20)
                                                                            elif XNA == 160 and flag1 == False:                   ##########################
                                                                                XNA = 190
                                                                                q.put(130)
                                                                                Tylenol2(20)
                                                                            elif (XNA == 160 and YNA == 39):
                                                                                XNA = 100
                                                                                YNA = 75
                                                                                q.put(111)
                                                                                Tylenol2(20)
                                                                                if flag1 == True:
                                                                                        flag1 = False
                                                                                elif flag1 == False:
                                                                                        flag1 = True
                                                                            elif (XNA == 190 and YNA == 75):
                                                                                XNA = 100
                                                                                YNA = 100
                                                                                q.put(134)
                                                                                Tylenol2(20)
                                                                                
                                                                            elif (XNA == 190 and YNA == 100):
                                                                                XNA = 100
                                                                                YNA = 39
                                                                                q.put(110)
                                                                                Tylenol2(20)
                                                                                if flag1 == True:
                                                                                        flag1 = False
                                                                                elif flag1 == False:
                                                                                        flag1 = True
                                                                                        
                                                            cv2.imshow("D4", dilation4)     #yellow
                                                            cv2.imshow("output", frame)
                                
                        elif rr == 56:
                                    print("go go go")
                                    body_array_loop()
                        cv2.imshow("D2", dilation2)     #green
                        cv2.imshow("D3", mix3)          #red
                        cv2.imshow("D4", dilation4)     #yellow

                        cv2.imshow("output", frame)                      
                        print("#$%ball_distance = " , ball_distance)
                        print('snadcjkasdbclkjasdbclkasjdbclkasjdbcsjadklbcksjladbckjlsadbckjsadbckjsadbkj', rr)

        elif(isStart == 2):
                break
        else:
                continue

capture.release()                   # 캡처 객체를 없애줌
cv2.destroyAllWindows()             # 모든 영상 창을 닫아줌
