#\!/bin/bash
# Toggle Spotify - opens if closed, closes if open

if pgrep -x "spotify" > /dev/null; then
    # Spotify is running, kill it
    pkill spotify
else
    # Spotify is not running, start it
    spotify &
fi
