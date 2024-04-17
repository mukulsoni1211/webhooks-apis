class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :dob, :created_at, :update_at
end
