get '/' do
	erb :index
end

post '/user' do
	@user = User.verify(params)
	unless @user.nil?
		session[:auth] = @user.id
		redirect "user/#{@user.id}"
	else
		redirect '/login'
	end
end

get '/signup' do
	erb :signup
end

post '/create_user' do
	@user = User.create(params[:user])
	session[:auth] = @user.id
	redirect "/user/#{user.id}"
end

get '/user/:id' do
	redirect '/' unless session[:auth] == params[:id].to_i
	@user = User.find(session[:auth])

	erb :user
end

get '/logout' do
	session[:auth] = nil
	redirect '/'
end

get '/:username' do
  @user = TwitterUser.find_or_create_by_handle(params[:username])
  if @user.tweets.empty? || @user.tweets_stale?
    @load_wait = true
    @user.fetch_tweets!
  end

  @user.tweets.count < 10 ? @tweets = @user.tweets.all : @tweets = @user.tweets.last(10)
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
  Twitter.update("#{params[:tweet]}")
  @tweet_sent = true
  erb :index
end
