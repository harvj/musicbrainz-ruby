module MusicBrainz
  class Request

    UNIQUE_IDENTIFIERS = %q{discid puid isrc iswc}
    QUERY_SEPARATOR = '%20AND%20'

    def initialize(resource, params)
      @resource   = resource
      @params     = params
      @id         = nil

      if UNIQUE_IDENTIFIERS.include?(resource)
        @id = params.delete(resource.to_sym)
      elsif params.has_key?(:mbid)
        @id = params.delete(:mbid)
      end
    end

    def path
      path = "/#{@resource}/#{@id}"
    end

    def options
      if @params[:query]
        options = '?query=' + @params.delete(:query)
        limit = @params.delete(:limit)
        offset = @params.delete(:offset)
        if @params.any?
          options += QUERY_SEPARATOR + @params.map{|k,v| "#{k}:#{v}"}.join(QUERY_SEPARATOR)
        end
        options += "&limit=#{limit}" if limit.present?
        options += "&offset=#{offset}" if offset.present?
      elsif @params[:inc]
        options = '?inc=' + @params.delete(:inc)
      end
      options || ''
    end

  end
end
