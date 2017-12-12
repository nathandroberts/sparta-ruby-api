class Post

  attr_accessor :id, :title, :body

  def save
    conn = Post.open_connection

    if(self.id)
      sql = "UPDATE post SET title='#{self.title}', body='#{self.body}' WHERE id = #{self.id}"
    else
      sql = "INSERT INTO post (title, body) VALUES ('#{self.title}', '#{self.body}')"
    end

    conn.exec(sql)
  end

  def self.api_create(post)

    conn = self.open_connection

    sql = "INSERT INTO post (title , body) VALUES ( '#{post[:title]}', '#{post[:body]}')"

    conn.exec(sql)

  end

  def self.api_update(post)

    conn = self.open_connection

    sql = "UPDATE post SET title='#{post[:title]}', body='#{post[:body]}' WHERE id = #{post[:id]}"

    conn.exec(sql)

  end

  def self.open_connection
    conn = PG.connect(dbname: "blog")
  end

  def self.all

    conn = self.open_connection

    sql = "SELECT id,title,body FROM post ORDER BY id DESC"

    results = conn.exec(sql)

    posts = results.map do |post|
      self.hydrate(post)
    end
  end

  def self.find(id)

    conn = self.open_connection

    sql = "SELECT * FROM post WHERE id =#{id} LIMIT 1"

    posts = conn.exec(sql)

    self.hydrate(posts[0])

  end

  def self.apiFind(id)

    conn = self.open_connection

    sql = "SELECT * FROM post WHERE id =#{id} LIMIT 1"

    posts = conn.exec(sql)

    posts[0]

  end

  def self.destroy(id)

    conn = self.open_connection

    sql = "DELETE FROM post WHERE id = #{id}"

    conn.exec(sql)

  end

  def self.hydrate(post_data)

    post = Post.new

    post.id = post_data['id']

    post.title = post_data['title']
    
    post.body = post_data['body']

    post
  end

end
