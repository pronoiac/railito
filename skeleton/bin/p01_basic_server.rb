require 'webrick'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

# main
server = WEBrick::HTTPServer.new(Port: 3000)

trap('INT') { server.shutdown } # gracefully handle ctrl-c

server.mount_proc "/" do |req, res| # request, response
  content_type=("text/text")
  res.body = req.path
end

server.start