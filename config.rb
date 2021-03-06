lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Reload the browser automatically whenever files change
begin
  require 'middleman-livereload'
  activate :livereload
rescue LoadError
end

helpers do
  def active_nav_class(*paths)
    current = current_path.sub(/\.html\Z/, '')
    paths.any? { |path|
      path = full_path(path).sub(/\A\//, '').sub(/\.html\Z/, '')
      path.split('/').first == current.split('/').first
    } ? "active" : ""
  end

  def nav_link_with_active(text, target, attributes = {})
    target_path = full_path(target).sub(/\A\//, '').sub(/\.html\Z/, '')
    item_path = current_path.sub(/\.html\Z/, '')

    active = if attributes.delete(:top)
               /\A#{target_path}/ =~ item_path
             else
               target_path == item_path
             end

    "<li #{'class="active"' if active}>" + link_to(text, target, attributes) + "</li>"
  end
end

require 'builder'
require 'markdown_html'

set :markdown_engine, :redcarpet
set :markdown, REDCARPET_EXTENTIONS

activate :blog do |blog|
  blog.permalink = "blog/:title.html"
  blog.sources = "blog/:title.html"
  blog.layout = 'article'
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# React JSX compiler
require 'react-jsx-sprockets'

# Add marbles-js to sprockets paths
require 'marbles-js'
MarblesJS::Sprockets.setup(sprockets)

require 'fly'
Fly::Sprockets.setup(sprockets)

require 'cupcake-icons'
CupcakeIcons::Sprockets.setup(sprockets)

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
  activate :gzip
end
