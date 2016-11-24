#Carrega os pacotes necessários
library(twitteR)
library(wordcloud)
library(tm)
library(plyr)
library(RColorBrewer)
library(devtools)

#abre o arquivo
filePath <- "jair1.txt"

text <- readLines(filePath)

#Transforma os tweets em corpus de análise
corpus <- Corpus(VectorSource(text))

#Limpa o texto
(f <- content_transformer(function(x) iconv(x, to='utf-8', sub='byte')))
corpus <- tm_map(corpus, f)
corpus <- tm_map(corpus, content_transformer(tolower)) 
corpus <- tm_map(corpus, removePunctuation) 
corpus <- tm_map(corpus, function(x)removeWords(x,stopwords("pt"))) 

corpus <- tm_map(corpus, removeWords, c("bolsonaro", "verbolsonaro","jair", "jairbolsonaro", "flaviobolsonaro", "carlosbolsonaro", "bolsonarosp", "depbolsonaro", "via", "sobre", "ser"))


removeURL <- function(x) gsub("http[ˆ[:space:]]*","", x)
corpus <- tm_map(corpus, content_transformer(removeURL), lazy=TRUE)

#Monta uma nuvem de palavras
wordcloud(corpus, max.words =200, min.freq=2, scale=c(5,.0), random.order = F)

#Salienta as palavras em cores por frequência
pal2 <- brewer.pal(8,"Dark2")
wordcloud(corpus, min.freq=2,max.words=200, random.order=F, colors=pal2, scale=c(5,.0))

#Monta uma matriz termo-documento
tdm <- TermDocumentMatrix(corpus)

#Retira palavras esparsas e transforma a matriz num banco de dados
tdm <- removeSparseTerms(tdm, sparse = 0.98)
df <- as.data.frame(inspect(tdm))
dim(df)

#Calcula a distância eclidiana entre as palavras
df.scale <- scale(df)
d <- dist(df.scale, method = "euclidean")

#Produz um gráfico de clusterizacao hierarquica
fit.ward2 <- hclust(d, method = "ward.D2")
plot(fit.ward2)

#palavras frequentes
(freq.terms <- findFreqTerms(tdm, lowfreq=3))

term.freq <- rowSums(as.matrix(tdm))
term.freq <- subset(term.freq, term.freq >=3)
df <- data.frame(term = names(term.freq), freq = term.freq)

library(ggplot2)
ggplot(df, aes(x=term, y=freq)) + geom_bar(stat = "identity") + xlab("Terms") + ylab("Count") +coord_flip()

library(graph)
library(Rgraphviz)

#grafico de palavras associadas
plot(tdm, term = freq.terms, corThreshold = 0.05, weighting = T)


    