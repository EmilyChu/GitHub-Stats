require 'httparty'
require 'pry'

def prompt_for_token
  print "Enter your github token: "
  token = gets.chomp
end

def prompt_for_org_name
  print "Enter the organization you're interested in: "
  org_name = gets.chomp
end

# # $ export GITHUB_TOKEN=...
# TOKEN = ENV['GITHUB_TOKEN'] || 
token = prompt_for_token

org_name = prompt_for_org_name
# CLASS_NAME = "TIY-DC-ROR-2015-Jan"

class GitHub
  include HTTParty
  base_uri "https://api.github.com"

def initialize (token)
  @auth = token
  @users = []
  @headers = {"Authorization" => "token #{@auth}", "User-Agent" => "EmilyChu"}
  @repo_homes = []
end

# GET /orgs/:org/members
def members (org)
  members = GitHub.get("/orgs/#{org}/members", 
    :headers => @headers)
  members.each do |m|
    names = m["login"]
    @users<<names
  end
  return @users
end

# List public repositories for the specified user
# GET /users/:username/repos
def members_repos
  @users.each do |user_name|
    repos = GitHub.get("/users/#{user_name}/repos", 
      :headers => @headers)
    repos.each do |r|
      repo_name = r["url"]
      @repo_homes<<repo_name
    end
  end
  return @repo_homes
end

# GET /repos/:owner/:repo/stats/contributors
def statistics
  @users.each do |user|
    additions = 0
    deletions = 0
    commits = 0
    @repo_homes.each do |x|
      begin
      list_of_repos = GitHub.get("#{x}/stats/contributors", :headers => @headers)
      list_of_repos.each do |w|
        if w["author"]["login"] == user
          w["weeks"].each do |h|
            additions += h["a"]
            deletions += h["d"]
            commits += h["c"]
          end
        end
      end
    rescue
    end
    end
    print "User: #{user}".ljust(20) + "Additions: #{additions}".ljust(20) + "Deletions: #{deletions}".ljust(20) + "Commits: #{commits}".ljust(20)
    puts
  end
end
end


statistics = GitHub.new(token)
statistics.members(org_name)
statistics.members_repos
statistics.statistics

# GET /repos/:owner/:repo/stats/contributors
# def contributors_stats (org, repo)
#   users = GitHub.get("/repos/#{org}/#{repo}/stats/contributors")
#   additions = 0
#   deletions = 0
#   commits = 0
#   users.each do |u|           # goes through each user's hash
#     stats = u["weeks"]        # gives me array of hashes containing add, delete, commit stats
#     stats.each do |h|         # goes through each hash element
#       additions += h["a"]     # finds value at each key
#       deletions += h["d"]
#       commits += h["c"]
#     end
#   end
#   print "Total Number of Additions: #{additions}\t Total Number of Deletions: #{deletions}\tTotal Number of Commits: #{commits}"
# end
# end
