module DataMapper::Should
  class Translation 

    cattr_accessor :translations
    self.translations = {
      :warn_like_rails => {
        :be_present => "%{field} can't be blank", 
        :be_unique  => "%{actual} has already been taken",
        :be_positive_integer => "%{actual} is not a positive number"
      },

      :warn_like_dm_validations => {
        :be_present => "%{field} must not be blank",
        :be_unique  => "%{actual} is already taken",
        :be_positive_integer => "%{field} must be a positive number"
      },

      # TODO: should or must, which is better?
      # - %{field} should be present
      # - %{field} must be present
      :specdoc => {
        :be_present => "%{field} should be present",
        :be_unique => "%{field} should be unique",
        :be_unique_within_scopes => "%{field} should be unique (scope: %{scopes})",
        :be_positive_integer => "%{field} should be a positive number",
        :match => "%{field} should match %{pattern}"
      },

      :warn => {
        :be_present => "%{field} was expected to be present, but it wasn't",
        :be_unique  => "%{field} was expected to be unique, but it wasn't",
        :be_positive_integer => "%{field} was expected to be positive integer, got %{actual}",
        :match => "%{field} was expected to match %{field}, got %{actual}"
      }

    }.to_mash

  class << self

    # == arguments
    # @param <String, Symbol, DataMapper::Should::SpecClass> scope
    # @param <Hash, Mash>                                    assigns

    def translate(scope, assigns={})
      if scope.is_a?(SpecClass)
        String.new(raw(scope.translation_key)) % scope.assigns.update(assigns)
      elsif raw_message =  raw(scope)
        String.new(raw_message) % assigns
      end
    end


    # == arguments
    # @param <String, Symbol, DataMapper::Should::SpecClass> scope 
    
    def raw(scope)
      return "" if scope.nil?
      scopes = normalize_scope(scope)
      lookup(scopes) or lookup(scopes.unshift("specdoc")) or ""
    end

    def lookup(array)
      array.inject(translations) do |result, k|
        if (x = result[k]).nil?
          return nil
        else
          x
        end
      end
    end


      # == returns
      # @return <Array> the array of normalized values
      # - scope
      # - model
      # - field
      def normalize_scope(scope)
        parts = scope.split(".") 

        model = nil
        field = nil
        result = []
      
        parts.each do |part|
          if part =~ /^[A-Z]/
            model = part
          elsif model and field.nil?
            field = part
          else
            result << part
          end
        end

        #TODO: model and field value is now ignored. support later.
        result
      end
      private :normalize_scope

  end # end of class << self
  end

  class String < ::String
    def %(args)
      if args.kind_of?(Hash)
        ret = dup
        args.each{|key, value| ret.gsub!(/%\{#{key}\}/, value.to_s)}
        ret
      else
        super
      end
    end
  end

  module TranslationRoleOfSpecs

    def self.included(klass)
      klass.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module ClassMethods
      def translation_key(spec_class)
        spec_class.translation_key
      end
    end

    module InstanceMethods

      def translation_keys
        map do |spec_class|
          self.class.translation_key(spec_class)
        end
      end

      def translated_keys
        map do |spec_class|
          Translation.translate(
            self.class.translation_key(spec_class), assigns(spec_class)) 
        end
      end
      alias_method :specdocs, :translated_keys


      def assigns(spec_class)
        spec_class.assigns
      end

      def translation_keys_each 
        if block_given?
          map do |spec_class|
            yield self.class.translation_key(spec_class), assigns(spec_class)
          end
        end
      end

    end
    
  end


end


