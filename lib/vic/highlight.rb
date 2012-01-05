module Vim
  class Highlight
    VALID_ARGS = {
      :normal_terminal => %w{term start stop},
      :color_terminal  => %w{cterm ctermfg ctermbg},
      :gui             => %w{gui guifg guibg guisp font}
    }

    attr_accessor :group_name, *VALID_ARGS.values.flatten

    def initialize(group_name, args={})
      @group_name = group_name

      args.each {|arg, val| send("#{arg}=", val) if respond_to? arg }
    end

    def write
      "hi #{group_name} #{arguments}" unless arguments.empty?
    end

    private

      def arguments
        valid_arguments.map do |arg|
          val = send(arg)
          "#{arg}=#{val}" unless val.nil? or val.empty?
        end.compact.join(' ')
      end

      def valid_arguments
        VALID_ARGS.values.flatten
      end
  end
end
