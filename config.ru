require 'rack/contrib'
use Rack::StaticCache,
  :urls => ["/css", "/js", "/lib", "/img"],
  :root => "public"

use Rack::Static,
  :urls => ["/css", "/js", "/lib", "/img"],
  :root => "public"

def read_html(html_name)
  [
    200,
    {
      "Content-Type" => "text/html",
      "Cache-Control" => "public, max-age=86400"
    },
    File.open("public/#{html_name}", File::RDONLY)
  ]
end


run lambda {|env|
  path = env["PATH_INFO"]
  case path
  when "/version.html" then
    read_html "version.html"
  else
    read_html "index.html"
  end
}
