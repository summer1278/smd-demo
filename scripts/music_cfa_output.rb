require 'taglib'

Dir.glob('music/*.mp3') do |mp3_file|
  TagLib::FileRef.open(mp3_file) do |fileref|
  unless fileref.null?
    tag = fileref.tag 
    tag.title   
    tag.artist  
    tag.album   
    tag.genre   

    properties = fileref.audio_properties
    properties.length  
    p tag.title
    p tag.genre
    p properties.length
  end
end 
end
