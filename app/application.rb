class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      if @@cart.length == 0 then
        resp.write("Your cart is empty")
      else
        @@cart.each do |item|
          resp.write("#{item}\n")
        end
      end
    elsif req.path.match(/add/)
      item = req.params["item"]
      if item then
        resp.write add_item(item)
      else
        resp.write "no item passed in"
      end
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  def add_item(item)
    if !@@items.include?(item) then
      "We don't have that item" 
    else
      @@cart << item
      "added #{item}"
    end
  end
end
