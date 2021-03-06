require 'java'
require 'addressable/uri'
#require 'appengine-api-1.0-sdk-1.2.0.jar'

module DataMapper
  module Adapters
    class DataStoreAdapter < AbstractAdapter
      module DS
        unless const_defined?("Service")
          import com.google.appengine.api.datastore.DatastoreServiceFactory
          import com.google.appengine.api.datastore.Entity
          import com.google.appengine.api.datastore.FetchOptions
          import com.google.appengine.api.datastore.KeyFactory
          import com.google.appengine.api.datastore.Key
          import com.google.appengine.api.datastore.EntityNotFoundException
          import com.google.appengine.api.datastore.Query
          import com.google.appengine.api.datastore.Text
          Service = DatastoreServiceFactory.datastore_service
        end
      end

      def create(resources)
        created = 0
        resources.each do |resource|
          entity = DS::Entity.new(resource.class.name)
          resource.attributes.each do |key, value|
            ds_set(entity, key, value)
          end
          begin
            ds_key = DS::Service.put(entity)
          rescue Exception
          else
            ds_id = ds_key.get_id
            resource.model.key.each do |property|
              resource.attribute_set property.field, ds_id
              ds_set(entity, property.field, ds_id)
            end
            DS::Service.put(entity)
            created += 1
          end
        end
        created
      end

      def update(attributes, query)
        updated = 0
        resources = read_many(query)
        resources.each do |resource|
          entity = DS::Service.get(ds_key_from_resource(resource))
          resource.attributes.each do |key, value|
            ds_set(entity, key, value)
          end
          begin
            ds_key = DS::Service.put(entity)
          rescue Exception
          else
            resource.model.key.each do |property|
              resource.attribute_set property.field, ds_key.get_id
            end
            updated += 1
          end
        end
        updated
      end

      def delete(query)
        deleted = 0
        resources = read_many(query)
        resources.each do |resource|
          begin
            ds_key = ds_key_from_resource(resource)
            DS::Service.delete([ds_key].to_java(DS::Key))
          rescue Exception
          else
            deleted += 1
          end
        end
        deleted
      end

      def read_many(query)
        q = build_query(query)
        fo = build_fetch_option(query)
        iter = if fo
          DS::Service.prepare(q).as_iterable(fo)
        else
          DS::Service.prepare(q).as_iterable
        end
        Collection.new(query) do |collection|
          iter.each do |entity|
            collection.load(query.fields.map do |property|
              property.key? ? entity.key.get_id : ds_get(entity, property.field)
            end)
          end
        end
      end

      def read_one(query)
        q = build_query(query)
        fo = build_fetch_option(query)
        entity = if fo
          DS::Service.prepare(q).as_iterable(fo).map{|i| break i}
        else 
          DS::Service.prepare(q).asSingleEntity
        end
        return nil if entity.blank?
        query.model.load(query.fields.map do |property|
          property.key? ? entity.key.get_id : ds_get(entity, property.field)
        end, query)
      end

      def aggregate(query)
        op = query.fields.find{|p| p.kind_of?(DataMapper::Query::Operator)}
        if op.nil?
          raise NotImplementedError, "No operator supplied."
        end
        if respond_to?(op.operator)
          self.send op.operator, query
        else
          raise NotImplementedError, "#{op.operator} is not supported yet."
        end
      end

      def count(query)
        q = build_query(query)
        count = DS::Service.prepare(q).countEntities
        [query.limit ? [count, query.limit].min : count]
      end

    protected
      def normalize_uri(uri_or_options)
        if uri_or_options.kind_of?(Hash)
          uri_or_options = Addressable::URI.new(
            :scheme   => uri_or_options[:adapter].to_s,
            :user     => uri_or_options[:username],
            :password => uri_or_options[:password],
            :host     => uri_or_options[:host],
            :path     => uri_or_options[:database]).to_s
        end
        Addressable::URI.parse(uri_or_options)
      end

    private
      def ds_key_from_resource(resource)
        DS::KeyFactory.create_key(resource.class.name, resource.key.first)
      end

      def build_query(query)
        q = DS::Query.new(query.model.name)
        query.conditions.each do |tuple|
          next if tuple.size == 2
          op, property, value = *tuple
          ds_op = case op
          when :eql;  DS::Query::FilterOperator::EQUAL
          when :gt;   DS::Query::FilterOperator::GREATER_THAN
          when :gte;  DS::Query::FilterOperator::GREATER_THAN_OR_EQUAL
          when :lt;   DS::Query::FilterOperator::LESS_THAN
          when :lte;  DS::Query::FilterOperator::LESS_THAN_OR_EQUAL
          else next
          end
          q = q.add_filter(property.name.to_s, ds_op, value)
        end
        query.order.each do |o|
          key = o.property.name.to_s
          if o.direction == :asc
            q = q.add_sort(key, DS::Query::SortDirection::ASCENDING)
          else
            q = q.add_sort(key, DS::Query::SortDirection::DESCENDING)
          end
        end
        q
      end

      def build_fetch_option(query)
        fo = nil
        if query.limit && query.limit != 1
          fo = DS::FetchOptions::Builder.with_limit(query.limit)
        end
        if query.offset
          if fo
            fo = fo.offset(query.offset)
          else
            fo = DS::FetchOptions::Builder.with_offset(query.offset)
          end
        end
        fo
      end

      def ds_get(entity, name)
        name = name.to_s
        if entity.has_property(name)
          result = entity.get_property(name)
          result.is_a?(DS::Text) ? result.value : result
        else
          nil
        end
      end

      def ds_set(entity, name, value)
        if value.is_a?(String) && value.length >= 500
          entity.set_property(name.to_s, DS::Text.new(value))
        else
          entity.set_property(name.to_s, value)
        end
      end
    end

    DatastoreAdapter = DataStoreAdapter
  end
end
