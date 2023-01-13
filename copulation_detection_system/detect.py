import cv2
import csv
import torch
import os
import pandas as pd
import serial
from PIL import Image
import datetime

def getModel():
    model = torch.hub.load('C:/Users/username/yolov5', 'custom',
    path='./model/Dm_copulation_1500/model/dm_cop_model/weights/best.pt',
    source='local')
    return model

def main(mdl):

    now = datetime.datetime.now()
    filename = './movies/' + now.strftime('%Y%m%d_%H%M%S') + '_copulation.mp4'

    df_results = pd.DataFrame()
    cam = cv2.VideoCapture(0)
    ser = serial.Serial("COM3", 9600)
    fourcc = cv2.VideoWriter_fourcc('m', 'p', '4', 'v')        # 動画保存時のfourcc設定（mp4用）
    video = cv2.VideoWriter(filename, fourcc, 30, (640, 480))
    
    ###Defenition###
    num = 0
    cop_state = 0
    non_state = 0
    cop = 1
    solo = 0
    old_state = 0
    state = 0
    
    while True:
        ret, frame = cam.read()
        dfs = pd.DataFrame()
        results = mdl(frame)
        video.write(frame)

        dfs = results.pandas().xyxy[0]
        
        ###Copulation Decision###
        if len(dfs[(dfs["class"] == 0)&(dfs["confidence"] >= 0.5 )]) != 0:
            cop_state = cop_state + 1 
            non_state = 0
            results.render()
            
            if cop_state > 30:
                state = 1
                
                # ser.write(b"1")
            
            # cv2.imshow("chamber",result.imgs[0][:,:,::-1])
        else:
            non_state = non_state + 1
            results.render()
            if non_state > 10:
                cop_state = 0
                non_state = 0              
                state = 0
                # ser.write(b"0")
        dfs["state"] = state
        dfs["old_state"] = old_state
        ###Trigger to Arduino###
        if state != old_state:
            
            if bool(state == 1):
                old_state = state
                ser.write(b"1")
                dfs["signal"] = 1

            if bool(state == 0):    
                old_state = state
                ser.write(b"0")
                dfs["signal"] = 2

        
        else:
            dfs["signal"] = 0
            old_state = state
        
        ###Write CSV###
        dfs["frame"] = int(num)
        df_results = pd.concat([df_results, dfs])
        cv2.imshow('frame', frame)

        num += 1


        k = cv2.waitKey(1) & 0xFF
        if k == 27:
            break
    return df_results

model = getModel()
now = datetime.datetime.now()
df = main(model)
df.to_csv('./result/' + now.strftime('%Y%m%d_%H%M%S') + 'result.csv')