# -*- coding: utf-8 -*-
ENV["SSL_CERT_FILE"] = "./cacert.pem"

require 'twitter'
require "active_support/time"

#アクセストークン
CONSUMER_KEY = "tsRRbRYCnaeSFm5nI1iT0X9se"
CONSUMER_SECRET = "TsqvUNCbGScbNWkD337nDpqoPRVW34cVPFy66KzKBw98j14IPx"
ACCESS_TOKEN = "2850479922-tFC72PZ6hgERPOkQyQgLxGlwPAPZHCtQg4ztdeM"
ACCESS_SECRET = "aD7mrtXDYRFU5CEvv2NGyePfraCRuW65Cg4ytMQAteAOA"

client = Twitter::REST::Client.new do |config|
    config.consumer_key            = CONSUMER_KEY
    config.consumer_secret       = CONSUMER_SECRET
    config.access_token             = ACCESS_TOKEN
    config.access_token_secret = ACCESS_SECRET
end
stream_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key            = CONSUMER_KEY
  config.consumer_secret       = CONSUMER_SECRET
  config.access_token             = ACCESS_TOKEN
  config.access_token_secret = ACCESS_SECRET
end
p "Update_nameをスタートしました(#{Time.now})"
#ストリーム接続しTL取得
stream_client.user do |object|
next unless object.is_a? Twitter::Tweet
next if object.text.start_with? "RT"
  #ランダム
  if object.text =~ /@RY2CN ランダム/ then
    #namelist.txtの行数を取得
    open('namelist.txt'){|l|
    while l.gets; end
    @lineno = l.lineno
  }
  #１行目～取得した行数までの乱数を発生
  random = rand(1..@lineno)
  #発生した数字をログに表示
  puts random
  #発生した数字の行数を取り出しnewnameに代入し、プロフィールを更新
  File.open('namelist.txt') do |name|
    newname = name.readlines[random]
    client.update_profile(:name => newname)
    option = {"in_reply_to_status_id" => object.id.to_s}
    tweet = "#{newname} に名前が変更されました by @#{object.user.screen_name}"
    client.update tweet,option
    end
  end
  case object.text 
    when 'いずみ' 
      option = {"in_reply_to_status_id" => object.id.to_s} 
      tweet = "@#{object.user.screen_name} いずみはじゃがいも(`o´)"
      client.update tweet,option
    when '@RY2CN 動いてますか'
      option = {"in_reply_to_status_id" => object.id.to_s} 
      tweet = "@#{object.user.screen_name} 動いてます"
      client.update tweet,option
    end
    #when '草' || '草、' || '草。' || 'ワロタ' || 'わろた' || '笑う'
      #option = {"in_reply_to_status_id" => object.id.to_s}
      #tweet = "なにわろてんねん@#{object.user.screen_name}"
    #end      
    #取得したTLのワードからワードを探す
    if object.text.start_with?("@RY2CN update_name ") || object.text.start_with?("@RY2CN upname ")  then
      #client.favorite(object.id)
      text = object.text
      #余計な部分を削除
      if text.length <= 39 then
        if object.text.start_with?("@RY2CN update_name ") then
          newname = text[19,39].strip
        elsif  object.text.start_with?("@RY2CN upname ") then
          newname = text[14,34].strip
        end
      if newname == "いずみ" then newname = "じゃがいも"
        end
        client.update_profile(:name => newname)
        option = {"in_reply_to_status_id" => object.id.to_s}
        if newname == "じゃがいも" then
          tweet = "@#{object.user.screen_name} いずみはじゃがいも(`o´)"
        elsif
          tweet = "#{newname} に名前が変更されました by @#{object.user.screen_name}"
        end
      client.update tweet,option
      puts newname
      File.open("namelist.txt", "a") do |f|
        f.puts(newname)
      end
    end
  end
end


