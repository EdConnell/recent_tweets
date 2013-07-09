class CreateTwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.string :name
      t.string :handle
      t.string :token
      t.string :secret
    end
  end
end
