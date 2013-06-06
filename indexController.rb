require "sinatra"
require "pstore"
require "time"
require "json"
require "open-uri"

configure do
	set :show_exceptions, false
end


get "/" do
	@Bag = PStore.new(File.expand_path("data.pstore", File.dirname(__FILE__)))
	@Bag.transaction do
		if @Bag["date"] == nil || (Time.parse(@Bag["date"]) + 300) < Time.now
			@Bag["date"] = Time.now.strftime("%Y-%m-%d %H:%M:%S")
			twitterData = JSON.parse(open("http://api.twitter.com/1/users/lookup.json?screen_name=nilsding").read)
			@Bag["follower"] = twitterData[0]["followers_count"]
		end
		@Data = @Bag["date"]
		@Follower = @Bag["follower"]
	end
	erb :index
end
