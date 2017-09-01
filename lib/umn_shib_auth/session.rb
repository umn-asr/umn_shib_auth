module UmnShibAuth
  class Session
    attr_reader :eppn, :internet_id, :institution_tld, :emplid, :display_name
    def initialize(*args)
      options = args.extract_options!
      options.symbolize_keys!
      raise "Yo, we only know how to function with :eppn specified" if options[:eppn].blank?

      @eppn = options[:eppn]
      @internet_id, @institution_tld = @eppn.split('@')
      @emplid = options[:emplid]
      @display_name = options[:display_name]
    end
  end
end
