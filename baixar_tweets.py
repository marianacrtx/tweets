# encoding: utf-8
#!/usr/bin/env python

import tweepy
import sys
reload(sys)
sys.setdefaultencoding('utf8')

consumer_key="xxxxxxxxxxx"
consumer_secret="xxxxxxxxx"
access_token="xxxxxxxxxxxxx"
access_token_secret="xxxxxxxxxxxxxx"

# Registre sua aplicacao em https://apps.twitter.com
# consumer_key="PONHA-SUA-CONSUMER-KEY-AQUI"
# consumer_secret="PONHA-SUA-CONSUMER-SECRET-AQUI"
# access_token="PONHA-SEU-ACCESS-TOKEN-AQUI"
# access_token_secret="PONHA-SEU-ACCESS-TOKEN-SECRET-AQUI"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth)

#
# Varias paginas
#
timeline = api.user_timeline('jairbolsonaro')
i = 0
while(timeline):
	for tweet in timeline:
		i=i+1
		print("%d, %s, %s" % (i,tweet.author.screen_name,tweet.text))

		last_id = tweet.id

	timeline = api.user_timeline('jairbolsonaro', max_id=last_id-1)

