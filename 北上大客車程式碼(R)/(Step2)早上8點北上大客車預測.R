library(readr)
library(dplyr)
library(ggplot2)
library(stringr)
library(broom)
#讀取資料
regN841 <- read.table("/Users/yanting/Desktop/allfinal/05F0055N_05F0001N(8-41).csv",header = TRUE, sep = ",")
View(regN841)

#變量間的關係圖
ggplot(regN841,aes(x=TrafficVolumn,y=TravelTime))+
  geom_point(colour="blue",size=3)

ggplot(regN841,aes(x=CarVolumn,y=TravelTime))+
  geom_point(colour="blue",size=3)

ggplot(regN841,aes(x=week,y=TravelTime))+
  geom_point(colour="blue",size=3)

ggplot(regN841,aes(x=festivalb,y=TravelTime))+
  geom_point(colour="blue",size=3)

plot.data <- augment(regS831.lm)
ggplot(plot.data ,aes(x = .fitted,y = .resid))+
  geom_point(colour ="blue",size =3.5)+
  geom_hline(yintercept = 0,linetype ="dashed", color = "red")

#以迴歸來看小客車流量、是否星期一、大客車流量、是否為節日後一天的對旅行時間影響的顯著程度
regN841.lm<- lm(TravelTime~CarVolumn+mon+TrafficVolumn,regN841)
summary(regN841.lm)
regN841.lm<- lm(TravelTime~CarVolumn+mon+TrafficVolumn＋festivalb,regN841)
summary(regN841.lm)
regN841.lm<- lm(TravelTime~TrafficVolumn＋festivalb,regN841)
summary(regN841.lm)

#使用三期移動平均解決調整空值及離群值
library(accelerometry)
movingaves = movingaves(x=regN841$TrafficVolumn,window=3)
regN841['movingaves_3'] = c(rep(NA,5-1),movingaves)
ggplot(data = regN841,aes(x=TravelTime))+
  geom_line(aes(y=TrafficVolumn),colour="white")+
  geom_line(aes(y=movingaves_3),colour="red")+
  ylab("TravelVolumn")

library(greybox)
library(smooth)
movingaves = sma(regN841$TrafficVolumn,
                 order=3,h=2,silent = F)
View(movingaves$states)

#使用移動平均之後的數值(regN841_two)做迴歸
regN841_two.lm<- lm(TravelTime~TrafficVolumn＋festivalb,regN841_two)
summary(regN841_two)

#看共線性
vif(regN841_two.lm)
