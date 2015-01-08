# As always, I hope I didn't reinvent the wheel or do something stupid... If I have please let me know!
#
# I'm currently using this with async_sinatra; haven't tested it without (sorry!)
#
# Example method usage:
#
#    before_filter [[:apost, "/users/?"] do
#        require_login
#    end


module Sinatra
  class Base

        # Sinatra::Base#before_filter
        #
        # Allows before filtering based on http method
        # I think it allows for a bit more granularity
        # with before filters. Uses Sinatra::Base#request method
        # to provide filtering based on http method
        #
        # Example:
        #
        # before_filter [[:aget, "/users/posts/?"], [:aput, "/users/:id/edit/?"]] do
        #   require_login
        # end
        #

    def self.before_filter(path_with_http_method = nil, options = {}, &block)
      path_with_http_method.each do |p|
        opts = options.merge({:request_method => p[0]})
        add_filter(:before, p[1], options, &block)
      end
    end

    private

        # Sinatra::Base#request_method
        # Credit: http://jeremy.cowgar.com/2011/04/07/a-method-condition-for-sinatra/
        #
        # execute a filter based on the HTTP request method
        #
        # Example:
        #
        # before :request_method => [:put] do
        #   require_login
        # end

      def self.request_method(*meth)
        condition do
          this_method = request.request_method.downcase.to_sym
          if meth.respond_to?(:include?) then
            meth.include?(this_method)
          else
            meth == this_method
          end
        end
      end

  end
end
