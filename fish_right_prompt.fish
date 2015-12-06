# right prompt for agnoster theme
# shows vim mode status

set right_segment_separator \uE0B2

function prompt_vi_mode -d 'vi mode status indicator'
    switch $fish_bind_mode
        case default
            set_color green
            echo -n "$right_segment_separator"
            prompt_segment green black "N"
        case insert
            set_color blue
            echo -n "$right_segment_separator"
            prompt_segment blue black "I"
        case visual
            set_color red
            echo -n "$right_segment_separator"
            prompt_segment red black "V"
    end
    if [ -n $current_bg ]
        set_color -b normal
        set_color $current_bg
    end
    set -g current_bg NONE
end

function fish_right_prompt -d 'Prints right prompt'
    prompt_vi_mode
end
