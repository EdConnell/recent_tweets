get '/' do
  if current_user
  	erb :index
  else
    erb :signin
  end
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  p 'access token: '
  p @access_token.inspect 
  if @access_token
    token = @access_token.token
    secret = @access_token.secret
    user = TwitterUser.create(token: token, secret: secret, handle: @access_token.params[:screen_name])
    user.fetch_tweets!
    session[:user_id] = user.id
    session.delete(:request_token)
  end
  # at this point in the code is where you'll need to create your user account and store the access token

  redirect '/'
  
end

get '/sessions/:user_id' do
	session.clear
	redirect '/'
end

get '/:username' do
  @user = TwitterUser.find_or_create_by_handle(params[:username])
  if @user.tweets.empty? || @user.tweets_stale?
    @load_wait = true
    @user.fetch_tweets!
  end

  @user.tweets.count < 10 ? @tweets = @user.tweets.all : @tweets = @user.tweets.first(10)
  #@tweets = @user.tweets
  if request.xhr?
    erb :tweets, :layout => false
  else
    erb :index
  end
end

post '/tweets' do
  p params
  redirect "/#{params[:tweeter]}"
end

post '/tweets/new' do
  current_user
  client = Twitter::Client.new(:oauth_token => @user.token, :oauth_token_secret => @user.secret)
  p @user.token
  p @user.secret
  p client
  client.update("#{params[:tweet]}")
  @tweet_sent = true
  erb :index
end
