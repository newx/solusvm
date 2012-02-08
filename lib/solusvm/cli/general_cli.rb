module Solusvm 
  class GeneralCli < BaseCli

    desc "templates TYPE", "Lists existing templates for a given type [openvz|xen|xen hvm|kvm]"
    def templates(type)
      say general.templates(type)
    end

    private

    def general
      @general ||= begin
        configure
        Solusvm::General.new
      end
    end
  end
end