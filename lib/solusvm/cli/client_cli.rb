module Solusvm
  class ClientCli < BaseCli

    desc "create", "Creates a new h"
    method_option :username, type: :string, desc: "Username",  aliases: ["-u", "--username"]
    method_option :password, type: :string, desc: "Password",  aliases: ["-p", "--password"]
    method_option :email, type: :string, desc: "Email",  aliases: ["-e", "--email"]
    method_option :firstname, type: :string, desc: "Firstname",  aliases: ["-f", "--firstname"]
    method_option :lastname, type: :string, desc: "Lastname",  aliases: ["-l", "--lastname"]
    method_option :company, type: :string, desc: "Company",  aliases: ["-c", "--company"]
    def create
      output api.create(options)
    end

    desc "change-password USERNAME NEWPASSWORD", "Changes the password of an existing client"
    def change_password(username, password)
      output api.change_password(username, password)
    end

    desc "authenticate USERNAME NEWPASSWORD", "Verify a clients login. Returns true when the specified login is correct"
    def authenticate(username, password)
      output api.authenticate(username, password)
    end

    desc "check-exists USERNAME", "Checks if a client exists"
    def check_exists(username)
      output api.exists?(username)
    end

    desc "delete USERNAME", "Deletes an existing client"
    def delete(username)
      output api.delete(username)
    end

    desc "list", "Lists existing clients"
    def list
      output api.list
    end

    private

    def api
      @client ||= begin
        configure
        Solusvm::Client.new
      end
    end
  end
end