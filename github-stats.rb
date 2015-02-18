require 'httparty'
require 'pry'

def prompt_for_token
  print "Enter your github token: "
  gets.chomp
end

# $ export GITHUB_TOKEN=...
TOKEN = ENV['GITHUB_TOKEN'] || prompt_for_token

CLASS_NAME = "TIY-DC-ROR-2015-Jan"

class GitHub
  include HTTParty
  base_uri "https://api.github.com"

# GET /repos/:owner/:repo/stats/contributors
def contributors (org, repo)
  contributors = GitHub.get("/repos/#{org}/#{repo}/contributors")
  contributors.each do |c|
    names = c["login"]
    puts names
  end
end

# GET /repos/:owner/:repo/stats/contributors
def contributors_stats (org, repo)
  users = GitHub.get("/repos/#{org}/#{repo}/stats/contributors")
  additions = 0
  deletions = 0
  commits = 0
  users.each do |u|           # goes through each user's hash
    stats = u["weeks"]        # gives me array of hashes containing add, delete, commit stats
    stats.each do |h|         # goes through each hash element
      additions += h["a"]      # finds value at each key
      deletions += h["d"]
      commits += h["c"]
    end
  end
  print "Total Number of Additions: #{additions}\t Total Number of Deletions: #{deletions}\tTotal Number of Commits: #{commits}"
end
end

api = GitHub.new

api.contributors_stats(CLASS_NAME, 'merge-conflict')



