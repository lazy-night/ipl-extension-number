# More info at https://github.com/guard/guard#readme

Context = Struct.new :title
slim_options = {
  :input_root => File.expand_path('src/slim', __FILE__),
  :output_root => File.expand_path('public', __FILE__),
  :context => Context.new('Guard-Slim'),
  :slim => {:pretty => false}
}
guard 'slim', slim_options do
  watch(%r{^src/slim/.+\.slim$})
end

# Now it seems that guard-slim options does not work correctly,
# so this is a quick-fix for it.
guard 'shell' do
  watch(%r{^src/slim/(.+\.html)$}) {|m|
    `if [ -f "src/slim/#{m[1]}" ]; then mv src/slim/#{m[1]} public/; fi;`
  }
end
guard 'sprockets', :destination => 'public/css', :asset_paths => ['src/sass', 'lib/css'] do
  watch(%r{^src/sass/.+\.(sass|css)$}) { 'src/sass/application.css' }
  #watch(%r{^lib/css/.+\.css$}) { 'lib/css/vendor.css' }
end

Tilt::CoffeeScriptTemplate.default_bare = true

guard 'sprockets', :destination => 'public/js', :asset_paths => ['src/coffee', 'lib/js'] do
  watch(%r{^src/coffee/.+\.(js|coffee)$}) { "src/coffee/application.js" }
  #watch(%r{^lib/js/.+\.(js|coffee)$}) { "lib/js/vendor.js" }
end

guard 'livereload' do
  watch(%r{^public/.+\.html$})
  watch(%r{^public/css/.+\.css$})
  watch(%r{^public/js/.+\.js$})
end

