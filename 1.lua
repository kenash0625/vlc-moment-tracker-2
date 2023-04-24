 checkpoint_l=nil
 moments={}
 moments_list=nil
 counter=0

 function descriptor()
    return {
       title = "My Moments Tracker",
       version = "1.0",
       author = "Community",
       url = '',
       shortdesc = "moments every video",
       description = "",
       capabilities = {"menu", "input-listener", "meta-listener", "playing-listener"}
    }
 end

 function get_media_meta()
  input = vlc.object.input()
  media_name = vlc.input.item():name()
 end

 function activate()
  createGUI()
 end

  function createGUI()
   main_layout = vlc.dialog("checkpoint")
   moments_list = main_layout:add_list(1,1,4,1)
   capture_moment_b = main_layout:add_button(" Capture Moment ",capture_moment,1, 5, 1, 1)
   go_to_moment_b = main_layout:add_button(" Jump to Moment ",jump_to_moment,2,5,1,1)
   remove_moment_b = main_layout:add_button(" Remove Moment ",remove_moment,3,5,1,1)
   caption_text_input = main_layout:add_text_input("Enter caption for the moment",1,6,2,2)
   edit_comment = main_layout:add_button(" Edit Comment ",edit_comment,3,6,1,1)
 end

 function display_moments()
  moments_list = main_layout:add_list(1,1,4,1)--empty list content
  local counter=1
  for index, value in ipairs(moments) do
    local tmpstr=value.comment.."@"..value.file.."@"..value.pos
    moments_list:add_value(tmpstr,counter)
    counter=counter+1
  end
 end


 function capture_moment()
   local input = vlc.object.input()
   local lfile=vlc.input.item():uri()
   local lpos=vlc.var.get(input,"position")
   for index, value in ipairs(moments) do
     if value.file==lfile and value.pos==lpos then
       return
     end
   end
   table.insert(moments, {file=lfile,pos=lpos,comment=caption_text_input:get_text()})
   display_moments()
 end

 function remove_moment()
     selection = moments_list:get_selection()
     if (not selection) then return 1 end
     local sel = nil
     for idx, selectedItem in pairs(selection) do
         sel = idx
         break
     end
     if (sel == nil) then return 1 end
     table.remove(moments,sel)
     display_moments()
 end

 function jump_to_moment()

 end

 function edit_comment()  
     selection = moments_list:get_selection()
     if (not selection) then return 1 end
     local sel = nil
     for idx, selectedItem in pairs(selection) do
         sel = idx
         break
     end
     if (sel == nil) then return 1 end
     moments[sel].comment=caption_text_input:get_text()
     display_moments()
 end
