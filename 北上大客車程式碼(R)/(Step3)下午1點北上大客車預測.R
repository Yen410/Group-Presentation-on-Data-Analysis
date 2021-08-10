library(readr)
library(dplyr)
library(ggplot2)
library(stringr)
library(broom)
regN1341 <- read.table("/Users/yanting/Desktop/allfinal/05F0055N_05F0001N(13-41).csv",header = TRUE, sep = ",")
View(regN1341)

#畫各變量間的關係圖
ggplot(regN1341,aes(x=carvolumn,y=time))+
  geom_point(colour="blue",size=3)

ggplot(regN1341,aes(x=trafficvolumn,y=time))+
  geom_point(colour="blue",size=3)

ggplot(regN1341,aes(x=week,y=time))+
  geom_point(colour="blue",size=3)

ggplot(regN1341,aes(x=week,y=trafficvolumn))+
  geom_point(colour="blue",size=3)

plot.data <- augment(regN1341.lm)
ggplot(plot.data ,aes(x = .fitted,y = .resid))+
  geom_point(colour ="blue",size =3.5)+
  geom_hline(yintercept = 0,linetype ="dashed", color = "red")

ggplot(regN1341,aes(x=Rainfall,y=time))+
  geom_point(colour="blue",size=3)

#以迴歸來看小客車流量、旅行時間、是否為節日後一天的顯著程度
regN1341.lm<- lm(time~w7+carvolumn+trafficvolumn,regN1341)
summary(regN1341.lm)

#使用三期移動平均解決調整空值及離群值
library(accelerometry)
movingaves = movingaves(x=regN1341$TrafficVolumn,window=3)
regN1341['movingaves_3'] = c(rep(NA,5-1),movingaves)
ggplot(data = regN1341,aes(x=TravelTime))+
  geom_line(aes(y=TrafficVolumn),colour="white")+
  geom_line(aes(y=movingaves_3),colour="red")+
  ylab("TravelVolumn")

library(greybox)
library(smooth)
movingaves = sma(regN1341$TrafficVolumn,
                 order=3,h=2,silent = F)
View(movingaves$states)

#使用移動平均之後的數值(regN1341_two)做迴歸
regN1341_two.lm<- lm(TravelTime~TrafficVolumn＋festivalb,regN1341_two)
summary(regN1341_two)

#看共線性
vif(regN1341_two.lm)
