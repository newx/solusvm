module Solusvm 
  class ClientCli < BaseCli

    desc "create", "Creates a new client"
    method_option :username, :type => :string, :desc => "Username",  :aliases => ["-u", "--username"]
    method_option :password, :type => :string, :desc => "Password",  :aliases => ["-p", "--password"]
    method_option :email, :type => :string, :desc => "Email",  :aliases => ["-e", "--email"]
    method_option :firstname, :type => :string, :desc => "Firstname",  :aliases => ["-f", "--firstname"]
    method_option :lastname, :type => :string, :desc => "Lastname",  :aliases => ["-l", "--lastname"]
    method_option :company, :type => :string, :desc => "Company",  :aliases => ["-c", "--company"]
    def create
      say client.create(options)
    end

    desc "change-password USERNAME NEWPASSWORD", "Changes the password of an existing client"
    def change_password(username, password)
      say client.change_password(username, password)
    end

    desc "authenticate USERNAME NEWPASSWORD", "Verify a clients login. Returns true when the specified login is correct"
    def authenticate(username, password)
      say client.authenticate(username, password)
    end

    desc "check-exists USERNAME", "Checks if a client exists"
    def check_exists(username)
      say client.exists?(username)
    end

    desc "delete USERNAME", "Deletes an existing client"
    def delete(username)
      say client.delete(username)
    end

    desc "list", "Lists existing clients"
    def list
      say client.list
    end

    private

    def client
      @client ||= begin
        configure
        Solusvm::Client.new
      end
    end
  end
end