require 'httparty'
require 'pry'

# $ export GITHUB_TOKEN=...
TOKEN = ENV['GITHUB_TOKEN'] || prompt_for_token

CLASS_NAME = "TIY-DC-ROR-2015-Jan"

def prompt_for_token
  print "Enter your github token: "
  gets.chomp
end


# GET /repos/:owner/:repo/stats/contributors
def contributors
  contributors = HTTParty.get("https://api.github.com/repos/TIY-DC-ROR-2015-Jan/merge-conflict/contributors")
  contributors.each do |c|
    names = c["login"]
    puts names
  end
end

# GET /repos/:owner/:repo/stats/contributors
def contributors_stats
  users = HTTParty.get("https://api.github.com/repos/TIY-DC-ROR-2015-Jan/merge-conflict/stats/contributors")
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
contributors_stats