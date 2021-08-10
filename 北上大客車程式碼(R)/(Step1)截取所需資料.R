library(readr)
library(dplyr)
#選取所需資料
#上午8點
file_list<-list.files("/Users/yanting/8",full.names = T)
m04a<-data_frame()
for(i in file_list){
  temp_data<-read_csv(i,col_names = F)
  m04a<-rbind(m04a,temp_data)
}
rm(temp_data)
colnames(m04a)<-c("timeinterval",
                  "from",
                  "to",
                  "vehicletype",
                  "time",
                  "trafficvolumn")

m04a$timeinterval <- m04a$timeinterval %>% as.POSIXct()
View(a)
b<- m04a %>% filter(from == "05F0055N")%>% filter(to == "05F0001N")
b41<-b %>% filter(vehicletype=="41")
write.table(b41,file = '/Users/yanting/Desktop/05F0055N-05F0001N(8-41).csv',row.names=F,col.names=T,sep=',')

#下午1點
file_list<-list.files("/Users/yanting/13",full.names = T)
m04a<-data_frame()
for(i in file_list){
  temp_data<-read_csv(i,col_names = F)
  m04a<-rbind(m04a,temp_data)
}
rm(temp_data)
colnames(m04a)<-c("timeinterval",
                  "from",
                  "to",
                  "vehicletype",
                  "time",
                  "trafficvolumn")

m04a$timeinterval <- m04a$timeinterval %>% as.POSIXct()
View(a)
b<- m04a %>% filter(from == "05F0055N")%>% filter(to == "05F0001N")
b41<-b %>% filter(vehicletype=="41")
write.table(b41,file = '/Users/yanting/Desktop/05F0055N-05F0001N(13-41).csv',row.names=F,col.names=T,sep=',')
