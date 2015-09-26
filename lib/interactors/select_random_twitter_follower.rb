# Class should be initialized with a request parameter where:
# - request[:twitter_client] an instance of Twitter::REST::Client
# - request[:required_fields] If present, will select the user only from the subset of users
# who have non-blank values for all the required fields.
#
# #call() will return a response where response[:user] will contain the an instance of Twitter::User
class Interactors::SelectRandomTwitterFollower < Interactor
  MAX_CALLS = 10

  def call()
    client = @request[:twitter_client]
    # Not too worried about error handling yet
    next_cursor = nil
    users = []
    num_calls = 0
    while (next_cursor != 0 && num_calls < MAX_CALLS)
      params = {}
      params[:count] = 200
      params[:cursor] = next_cursor if next_cursor
      cursor = client.followers(params)
      hash = cursor.to_hash
      users += hash[:users]
      next_cursor = hash[:next_cursor]
      num_calls += 1
    end

    if (required_fields = request[:required_fields])
      required_fields.each do |field|
        users = users.select { |user|
          user[field].present?
        }
      end
    end

    {user: users.sample}
  end
end
