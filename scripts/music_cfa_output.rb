require 'taglib'

TagLib::FileRef.open("music/Justin Bieber - As Long As You Love Me (feat. Big Sean).mp3") do |fileref|
  unless fileref.null?
    tag = fileref.tag 
    tag.title   
    tag.artist  
    tag.album   
    tag.genre   

    properties = fileref.audio_properties
    properties.length  
    p tag.genre
    p properties.length
  end
end 
