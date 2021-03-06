path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'rubygems'
require 'fakeweb'
require 'pilha'
require 'rspec'
require 'pp'

include StackExchange
StackExchange::StackOverflow::Client.config
FIXTURES_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))
ROOT_URL = [StackOverflow::Client::URL.chomp('/'), StackOverflow::Client::API_VERSION].join '/'
FakeWeb.allow_net_connect = false

def register(options)
  url = api_method_url(options[:url])
  FakeWeb.register_uri(:get, url, :body => read_fixture(options[:body] + '.json.gz'))
end

def read_fixture(fixture)
  File.read(File.join(FIXTURES_PATH, fixture))
end

def api_method_url(method)
  ROOT_URL + '/' + method
end

['stats', 'badges', 'questions'].each do |method|
  register :url => method + '/', :body => method
end

register(:url => 'badges/9/', :body => 'badges_by_id')
register(:url => 'badges/9/?pagesize=50', :body => 'badges_by_id_page2')
register(:url => 'badges/tags/', :body => 'badges_tag_based')
register(:url => 'answers/666/', :body => 'answer_by_id')
register(:url => 'answers/666/?body=true', :body => 'answer_by_id_with_body')
register(:url => 'answers/555/', :body => 'answer_with_comments')
register(:url => 'comments/1/', :body => 'comments')
register(:url => 'questions/549/answers/', :body => 'answers_by_question_id')
register(:url => 'questions/549/comments/', :body => 'comments_by_question_id')
register(:url => 'users/333/questions/', :body => 'questions_by_user_id')
register(:url => 'questions/1234/', :body => 'question_by_id')
register(:url => 'questions/1234/?body=true', :body => 'question_by_id_with_body')
register(:url => 'users/1/answers/', :body => 'users_answers')
register(:url => 'users/555/', :body => 'users_by_id')
register(:url => 'users/549/comments/', :body => 'comments_by_user_id')
register(:url => 'users/549/mentioned/', :body => 'comments_by_mentioned_user_id')
register(:url => 'users/77814/comments/549/', :body => 'comments_by_user_to_mentioned_user')
register(:url => 'users/549/favorites/', :body => 'favorite_questions_by_user_id')
register(:url => 'questions/?tagged=ruby', :body => 'questions_tagged_ruby')
register(:url => 'questions/?tagged=gwt+google-app-engine', :body => 'questions_tagged_gwt_and_googleappengine')
register(:url => 'questions/unanswered/', :body => 'questions_unanswered')
register(:url => 'tags/', :body => 'all_tags')
register(:url => 'users/549/tags/', :body => 'tags_by_user_id')
