function fconv -d "Convert video to x264"
  echo 'ffmpeg -i INPUT -c:v libx264 -preset veryfast OUTPUT'
  ffmpeg -i $argv[1..-2] -c:v libx264 -preset veryfast $argv[2..-1]
end
