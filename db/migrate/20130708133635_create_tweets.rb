class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :text
      t.datetime :posted_at
      t.belongs_to :twitter_user
      t.string :real_tweet_id
    end
  end
end
