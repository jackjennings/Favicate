require 'rubygems'
require 'sinatra'
require 'png'

get "/" do
  "Helllllo world"
end

get %r{/(\d{1,3})/(\d{1,3})/(\d{1,3})/(solid|noise)/(favicon|touch).png} do
  r = params[:captures][0].to_i
  g = params[:captures][1].to_i
  b = params[:captures][2].to_i
  kind = params[:captures][3]
  size = params[:captures][4]
  
  path = "favicons/#{r}/#{g}/#{b}/#{kind}/#{size}.png"
  unless File.exist? path
    dimentions = case size
    when 'favicon'
      16
    when 'touch'
      129
    end
    
    canvas = PNG::Canvas.new dimentions, dimentions
    
    dimentions.times do |x|
      dimentions.times do |y|
        canvas[x, y] = PNG::Color.new(r,g,b)
      end
    end
    png = PNG.new canvas
    
    FileUtils.mkdir_p(File.dirname(path))
    png.save path
  end
  send_file path
end