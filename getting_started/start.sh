#!/bin/bash

# Prompt for challenge name and IP
read -p "Enter the challenge name: " CHALLENGE
CHALLENGE_DIR=~/boxes/"$CHALLENGE"
mkdir -p "$CHALLENGE_DIR"

read -p "Enter the target IP address: " IP
export IP

# Create temporary terminator layout file
LAYOUT=$(mktemp)

# Escape the IP for safe inclusion in strings
ESCAPED_IP=$(printf "%q" "$IP")

cat > "$LAYOUT" <<EOF
[keybindings]
[layouts]
  [[challenge_layout]]
    [[[window0]]]
      type = Window
      parent = ""
      fullscreen = True

    [[[child1]]]
      type = HPaned
      parent = window0

    [[[child_left]]]
      type = Terminal
      parent = child1
      command = zsh -c 'target() { export TARGET_IP="\$1"; }; target "$ESCAPED_IP"; cd "$CHALLENGE_DIR"; exec zsh'

    [[[right_vsplit1]]]
      type = VPaned
      parent = child1

    [[[top_right]]]
      type = Terminal
      parent = right_vsplit1
      command = zsh -c 'target() { export TARGET_IP="\$1"; }; target "$ESCAPED_IP"; cd "$CHALLENGE_DIR"; exec zsh'

    [[[mid_bottom_split]]]
      type = VPaned
      parent = right_vsplit1

    [[[middle_right]]]
      type = Terminal
      parent = mid_bottom_split
      command = zsh -c 'target() { export TARGET_IP="\$1"; }; target "$ESCAPED_IP"; cd "$CHALLENGE_DIR"; exec zsh'

    [[[bottom_right]]]
      type = Terminal
      parent = mid_bottom_split
      command = zsh -c 'target() { export TARGET_IP="\$1"; }; target "$ESCAPED_IP"; cd ~/binaries; exec zsh'
EOF

# Launch Terminator silently and in background
terminator --layout=challenge_layout --config="$LAYOUT" &> /dev/null &

# Wait and clean up
sleep 2
rm "$LAYOUT"

# Exit the script terminal window
exit
