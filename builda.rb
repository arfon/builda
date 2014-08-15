["rubygems", "sinatra", "mongo_mapper", "digest", "pry", "multi_json", "octokit", "sidekiq", "oauth", "toml", "active_support", "active_support/all"].each { |dep| require dep }

if ENV['MONGOHQ_URL']
  uri = URI.parse(ENV['MONGOHQ_URL'])
  MongoMapper.connection = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
  MongoMapper.database = uri.path.gsub(/^\//, '')
else
  MongoMapper.setup({"development" => { "host" => "localhost", "database" => "builda_development", "port" => 27017}}, 'development')
end

CONFIG = TOML.load_file("setup.toml")

# SETUP
GITHUB_TOKEN = CONFIG['setup']['github_token']
BUILDA_LOCATION = CONFIG['setup']['builda_location']

class Repository
  include MongoMapper::Document

  key :name, String
  key :secret, String
  key :github_address, String
  timestamps!

  many :build_requests
end

class BuildRequest
  include MongoMapper::EmbeddedDocument

  key :commit, String
  key :status, String
  timestamps!
end

class BuildaWorker
  include Sidekiq::Worker

  def perform(repository_id, build_request_id)
    "DO MAGIC"
  end
end

before do
  @repository = Repository.find_by_secret(params[:secret])
  return status 404 unless @repository
end

post '/build' do
  # Call BuildaWorker here e.g. BuildaWorker.perform_async(@repository.id, @build_request.id)
  "BUILDAAAAAAAA!"
end
