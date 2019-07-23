class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Overide as_json to exclude the id from any returned records
  def as_json(options={})
    h = {}
    (attribute_names.reject{|e| e.include?('id')}).map{|f| h.merge!(f.to_sym => send(f))}
    h
  end
end
