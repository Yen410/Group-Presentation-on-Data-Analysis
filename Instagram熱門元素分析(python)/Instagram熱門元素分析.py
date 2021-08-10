#抓手繪作家ig的前50張照片

#抓url
import re # the regex module
from instaLooter import InstaLooter
import pandas as pd

#指定某位手繪畫家
looter = InstaLooter(profile="mr.paul_tw", get_videos=True)
pic_url=[]
for media in looter.medias():
    picture_url = pic_url.append(media['display_src'])
    
url1=pic_url[0:50]

#照片使用ibm辨識圖片元素的api，對圖片元素做紀錄(記錄下辨識後元素相似度大於75％的元素)
import json
from os.path import join, dirname
from os import environ
from watson_developer_cloud import VisualRecognitionV3

visual_recognition = VisualRecognitionV3('2016-05-20', api_key='d4001d9f97e6f65247b64ee8afb15caf0cbee88a')
all_pic=[]
for i in url1:
    picture=visual_recognition.classify(images_url=i) 
    pic1=[]
    for things in picture['images'][0]['classifiers'][0]['classes']:
        if things['score']>0.75:
            pic1.append(things['class'])
    all_pic.append(pic1)

#將所有圖片的所有元素以dummy方式做紀錄，一列為一張照片，欄位為元素的名稱，若照片有此元素則在欄位紀錄上1，沒有則為0
all_item = []
for val in all_pic:
    for e in val:
        if e not in all_item:
            all_item.append(e)
pic_dic = {}
for items in all_item:
    i = 0
    temp = []
    while i<len(all_pic):
        temp.append(0)
        i +=1        
    pic_dic[items] = temp
pic_dic

all_pic_count = 0
for val in all_pic:
    for e in val:
        if e in val:
            pic_dic[e][all_pic_count] = 1
    all_pic_count += 1

gf_df = pd.DataFrame(pic_dic)

#將圖片的url加入進dataframe中
gf_df['	picture_url']=url1
gf_df

#抓讚數
import numpy as np
import pandas as pd
from selenium import webdriver
import time, re
from bs4 import BeautifulSoup
from selenium.webdriver.common.keys import Keys

driver=webdriver.Firefox(executable_path = '/Users/yanting/node_modules/geckodriver/geckodriver')
driver.implicitly_wait(3)
driver.get("http://www.imgrum.org/user/mr.paul_tw/428424996")#指定某位手繪畫家
time.sleep(2)

#抓取該手繪畫家ig圖片的讚數
def extract_like(): 
    like_list=[]
    soup=BeautifulSoup(driver.page_source,'html.parser')
    print("-------------------------------------"+str(len(soup.select('.type_columns1 a'))))
    for block in soup.select('.gallery_likes_add'):
        like_list.append(block.text)
    return like_list 

clicked = 0
count=5
all_list = []
while clicked < count:
    all_list.append(extract_like())
    driver.find_element_by_css_selector(".type_columns1 a").click()
    time.sleep(10)
    clicked+=1
all_listlike=np.hstack((all_list[0],all_list[1],all_list[2],all_list[3],all_list[4]))
all_like_1=pd.DataFrame(all_listlike)
gf_df['likes']=all_like_1.head(50)#將讚數加入dummy過後的表格中

#輸出完整資料
gf_df.to_csv('mr.paul_tw.csv', index=False, encoding='big5')

#最後的關聯分析圖使用投影片中的R程式碼進行分析、繪製