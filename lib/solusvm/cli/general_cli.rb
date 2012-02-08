module Solusvm 
  class GeneralCli < BaseCli

    desc "templates TYPE", "Lists existing templates for a given type [openvz|xen|xen hvm|kvm]"
    def templates(type)
      say general.templates(type)
    end

    desc "plans TYPE", "Lists existing plans for a given type [openvz|xen|xen hvm|kvm]"
    def plans(type)
      say general.plans(type)
    end

    desc "isos TYPE", "Lists existing isos for a given type [openvz|xen|xen hvm|kvm]"
    def isos(type)
      say general.isos(type)
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