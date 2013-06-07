 BUNDLES = %w(public/js/application.js public/css/application.css)

 task :compile do
   require 'sprockets'
   environment = Sprockets::Environment.new(File.dirname(__FILE__))
   environment.append_path 'src/coffee'
   environment.append_path 'src/sass'

   BUNDLES.each do |bundle|
     FileUtils.mkdir_p File.dirname bundle
     assets = environment.find_asset File.basename bundle
     assets.write_to bundle
   end
   
   # TODO: need a better way.
   `slimrb -p src/slim/index.slim > public/index.html`
 end

 task :default => :compile
