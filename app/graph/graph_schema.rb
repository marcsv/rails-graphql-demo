PostType = GraphQL::ObjectType.define do
  name "Post"
  description "A post"
  
  field :id, !types.Int
  field :title, !types.String
  field :content, !types.String
  field :blog do
    type BlogType
    resolve -> (obj, args, ctx) {
      obj.blog
    }
  end
end

BlogType = GraphQL::ObjectType.define do
  name "Blog"
  description "A blog"
  
  field :id, !types.Int
  field :name, !types.String
  field :author do
    type UserType
    resolve -> (obj, args, ctx) {
      obj.author
    }
  end
  field :posts do
    type -> { types[PostType] }
    argument :first, types.Int
    resolve -> (obj, args, ctx) {
      return obj.posts if args[:first].blank?

      obj.posts.first(args[:first])
    }
  end
end

UserType = GraphQL::ObjectType.define do
  name "User"
  description "A user of the app"

  field :id, !types.Int
  field :name, !types.String
  field :email, !types.String
  field :blogs do
    type -> { types[BlogType] }
    resolve -> (obj, args, ctx) {
      obj.blogs
    }
  end
end

QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root for the schema"

  field :user do
    type UserType
    argument :id, !types.Int
    resolve -> (obj, args, ctx) {
      User.find(args[:id])
    }
  end
end

CreateBlogMutation = GraphQL::Relay::Mutation.define do
  name "CreateBlog"
  description "Creates a new blog"

  input_field :user_id, !types.Int
  input_field :name, !types.String

  return_type BlogType

  resolve -> (obj, input, ctx) {
    Blog.create(input.to_h)
  }
end

MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :createBlog, field: CreateBlogMutation.field
end

GraphSchema = GraphQL::Schema.define do
  query QueryType
  mutation MutationType
end
