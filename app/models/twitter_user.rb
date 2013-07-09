class TwitterUser < ActiveRecord::Base
  has_many :tweets, :dependent => :destroy, order: 'posted_at DESC'

  def average_rest
    if self.tweets.count < 10
      (self.tweets.first.posted_at - self.tweets.last.posted_at) / self.tweets.count
    else
      last_ten = self.tweets.last(10)
      (last_ten[0].posted_at - last_ten[9].posted_at) / 10 
    end
  end

  def tweets_stale?
    (Time.now - self.tweets.last.posted_at) > average_rest  
  end

  def fetch_tweets!
    Twitter.user_timeline("#{self.handle}").each do |status|
      if self.name.nil?
        self.name = status[:user][:name]
      end
      self.tweets.create(:text => status.text, :posted_at => status.created_at, :real_tweet_id => status.id)
    end
  end

end
