
library(xml2)
library(gsubfn)
library(qdap)


get_topic_speeches <- function(xml, num, last){
        if (num<last) {
                # return all nodes between major-heading node num and num+1
                fn$xml_find_all(xml, "/*/major-heading[$num]
                    /following-sibling::speech
                                [count(.|/*/major-heading[$num+1]/preceding-sibling::speech)
                                =
                                count(/*/major-heading[$num+1]/preceding-sibling::speech)
                                ]")
        }
        else {
                # last node
                fn$xml_find_all(xml, "/*/major-heading[$num]
                                /following-sibling::speech")
        }
}

topic_details <- function (date,topic, speeches){
        df <- data.frame(row.names = c("date", "topic", "speaker", "word_count"))
        for (sp in speeches) {
                speaker <-xml_attr(sp, "speakername")
                word_count <- word_count(xml_text(sp))
                df <- rbind(df, data.frame(date=date, topic=topic, speaker=speaker, word_count=word_count))
        }
        df
}

process_days_topics <- function(xml, date){
        topics <- xml_find_all(xml, "//major-heading")
        num_topics <- length(topics)
        df <- data.frame()
        
        for (i in 1:num_topics) {
                speeches <- get_topic_speeches(xml, i, num_topics)
                details <- topic_details(date, topics[[i]], speeches)
                df <- rbind(df, details)
        }
        df
}

debate_data <- "C:\\Users\\cs\\parl_data\\scrapedxml\\debates"
data_files <- list.files(debate_data)

df <- data.frame()

for (file in data_files) {
        date <- as.Date(substr(file,8,17))
        xml <- read_xml(file.path(debate_data, file))
        df <- rbind(df, process_days_topics(xml, date))
}