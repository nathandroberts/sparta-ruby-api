class ApiPostsController < Sinatra::Base

  get '/api/posts' do

    @posts = Post.all

    content_type :json

    postsArray = []

    @posts.each do |post|
      postHash = {
        "id" => post.id,
        "title" => post.title,
        "body" => post.body
      }
      postsArray.push(postHash)
    end

    postsArray.to_json

  end

  get '/api/posts/:id' do

    id = params[:id].to_i

    post = Post.apiFind(id)

    content_type :json

    post.to_json

  end

  post '/api/posts' do

    data = JSON.parse( request.body.read.to_s )

    new_post = {
      title: data['title'],
      body: data['body']
    }

    post = Post.api_create(new_post)

    content_type :json

    new_post.to_json

  end

  put '/api/posts/:id'  do

    data = JSON.parse( request.body.read.to_s )

    updated_post = {
      id: params['id'],
      title: data['title'],
      body: data['body']
    }

    post = Post.api_update(updated_post)

    content_type :json

    updated_post.to_json

  end

  delete '/api/posts/:id'  do

    id = params[:id].to_i

    Post.destroy(id);

    "Post id:#{id} was deleted"

  end

end
