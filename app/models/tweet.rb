class Tweet < ActiveRecord::Base
  belongs_to :twitter_user
  validates :real_tweet_id, :uniqueness => true
  validates :text, :presence => true

  # def text=(text)
  #   text.gsub(/(https?:\/\/t\.co\/.+)/, '<a href=\"$1\">\"$1\"</a>')
  # end
  # /http:\/\//
  # /www\.[\w\-+]+\.[\w{2,}]+/
  # [\w\-+]+\.(com|org|net|biz|xxx)
end
