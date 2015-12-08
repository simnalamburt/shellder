# right prompt for agnoster theme
# shows vim mode status

set right_segment_separator \uE0B2
set -g agnoster_right_current_bg NONE
function right_prompt_segment -d "Function to draw a right segment"
  set -l bg
  set -l fg
  if [ -n "$argv[1]" ]
    set bg $argv[1]
  else
    set bg normal
  end
  if [ -n "$argv[2]" ]
    set fg $argv[2]
  else
    set fg normal
  end
  if [ "$agnoster_right_current_bg" != 'NONE' -a "$argv[1]" != "$agnoster_right_current_bg" ]
    set_color -b $agnoster_right_current_bg
    set_color $bg
    echo -n " $right_segment_separator"
    set_color -b $bg
    set_color $fg
  else
    set_color -b $bg
    set_color $fg
  end
  set agnoster_right_current_bg $argv[1]
  if [ -n "$argv[3]" ]
    echo -n -s " " $argv[3]
  end
end

function end_right_prompt
  if [ -n $agnoster_right_current_bg ]
        set_color -b normal
        set_color $agnoster_right_current_bg
  end
  set -g agnoster_right_current_bg NONE
end

function prompt_vi_mode -d 'vi mode status indicator'
  switch $fish_bind_mode
      case default
        right_prompt_segment green black "N"
      case insert
        right_prompt_segment blue black "I"
      case visual
        right_prompt_segment red black "V"
    end
end

function fish_right_prompt -d 'Prints right prompt'
  if set -q __fish_vi_mode
    set -l first_color black
    set_color $first_color
    echo "$right_segment_separator"
    prompt_vi_mode
    end_right_prompt
  end
end
