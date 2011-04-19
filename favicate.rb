require 'rubygems'
require 'sinatra'
require 'png'

enable :streaming

get "/" do
  "Helllllo world"
end

get %r{/(\d{1,3})/(\d{1,3})/(\d{1,3})/(solid|touch).png} do
  path = "./favicons/#{params[:captures][0]}/#{params[:captures][1]}/#{params[:captures][2]}/#{params[:captures][3]}.png"
  unless File.exist? path
    dimentions = case params[:captures][3]
    when 'solid'
      16
    when 'touch'
      129
    end
    
    canvas = PNG::Canvas.new dimentions, dimentions
    
    # Set a point to a color
    r = params[:captures][0].to_i
    g = params[:captures][1].to_i
    b = params[:captures][2].to_i
    dimentions.times do |x|
      dimentions.times do |y|
        canvas[x, y] = PNG::Color.new(r,g,b)
      end
    end
    
    png = PNG.new canvas
    
    FileUtils.mkdir_p(File.dirname(path))
    png.save path
    puts ''
    puts 'filesave'
    puts ''
    # send_data 'new.png', :type => 'image/png', :disposition => 'inline'
    # return png.to_blob
  end
  send_file path
end