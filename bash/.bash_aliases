# ~/.bash_aliases - Custom command aliases

# Common aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git aliases (add more as needed)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Termux specific
alias cls='clear'
alias update='pkg update && pkg upgrade'

# Add your custom aliases below this line

# ============================================
# Termux-API: SMS Management
# ============================================

# Function to view SMS messages with pretty formatting
sms() {
    local type="${1:-inbox}"
    local limit="${2:-20}"

    case "$type" in
        -h|--help|help)
            echo "Usage: sms [inbox|sent|all|<number>] [limit]"
            echo ""
            echo "Examples:"
            echo "  sms               - Show last 20 inbox messages"
            echo "  sms sent          - Show last 20 sent messages"
            echo "  sms all           - Show all messages (inbox + sent)"
            echo "  sms +1234567890   - Show messages from specific number"
            echo "  sms inbox 50      - Show last 50 inbox messages"
            echo ""
            echo "Note: Requires Termux:API app installed on your device"
            return 0
            ;;
        inbox)
            echo "[INBOX] Last $limit messages:"
            echo "----------------------------------------------------------------"
            termux-sms-list -t inbox -l "$limit" 2>/dev/null | jq -r '.[] |
                "Number:  \(.number // "Unknown") | ID: \(._id)
Contact: \(.name // "No contact name")
Date:    \(.received)
Message: \(.body)
----------------------------------------------------------------"'
            ;;
        sent)
            echo "[SENT] Last $limit messages:"
            echo "----------------------------------------------------------------"
            termux-sms-list -t sent -l "$limit" 2>/dev/null | jq -r '.[] |
                "Number:  \(.number // "Unknown") | ID: \(._id)
Contact: \(.name // "No contact name")
Date:    \(.received)
Message: \(.body)
----------------------------------------------------------------"'
            ;;
        all)
            echo "[ALL] Last $limit messages:"
            echo "----------------------------------------------------------------"
            termux-sms-list -l "$limit" 2>/dev/null | jq -r '.[] |
                "Number:  \(.number // "Unknown") | Type: \(.type) | ID: \(._id)
Contact: \(.name // "No contact name")
Date:    \(.received)
Message: \(.body)
----------------------------------------------------------------"'
            ;;
        +*|[0-9]*)
            echo "[CONVERSATION] Messages with $type:"
            echo "----------------------------------------------------------------"
            termux-sms-list -n "$type" 2>/dev/null | jq -r '.[] |
                "[\(.type == "inbox" ? "RECEIVED" : "SENT")] \(.received)
Message: \(.body)
----------------------------------------------------------------"'
            ;;
        *)
            echo "ERROR: Unknown option: $type"
            echo "Use 'sms help' for usage information"
            return 1
            ;;
    esac
}

# Quick aliases for SMS
alias sms-inbox='sms inbox'
alias sms-sent='sms sent'
alias sms-all='sms all'

# ============================================
# Termux-API: Clipboard (macOS-style)
# ============================================

# Copy to clipboard (like macOS pbcopy)
alias pbcopy='termux-clipboard-set'

# Paste from clipboard (like macOS pbpaste)
alias pbpaste='termux-clipboard-get'

# ============================================
# Termux-API: Share
# ============================================

# Share text or files with Android share menu
share() {
    if [ $# -eq 0 ]; then
        echo "Usage: share <text|file> [options]"
        echo ""
        echo "Examples:"
        echo "  share 'Hello World'           - Share text"
        echo "  echo 'test' | share           - Share from stdin"
        echo "  share file.txt                - Share a file"
        echo "  share -a send image.png       - Share with specific action"
        echo "  share --chooser 'Pick app'    - Custom chooser title"
        echo ""
        echo "Common actions (-a):"
        echo "  send      - Default share action"
        echo "  view      - View the file"
        echo "  edit      - Edit the file"
        return 0
    fi

    # If first arg is a file, share the file
    if [ -f "$1" ]; then
        termux-share "$@"
    else
        # Otherwise, share as text
        termux-share -a send "$@"
    fi
}

# ============================================
# Termux-API: Notifications
# ============================================

# Send notification
notify() {
    local title="Notification"
    local content=""
    local priority="default"

    # Parse arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                echo "Usage: notify [options] <message>"
                echo ""
                echo "Options:"
                echo "  -t, --title <text>     Notification title (default: 'Notification')"
                echo "  -p, --priority <level> Priority: min, low, default, high, max"
                echo "  -i, --id <id>          Notification ID (for updating/removing)"
                echo "  --sound                Enable notification sound"
                echo "  --vibrate <pattern>    Vibrate pattern (e.g., '200,100,200')"
                echo ""
                echo "Examples:"
                echo "  notify 'Task complete'"
                echo "  notify -t 'Build' 'Compilation finished'"
                echo "  notify -p high 'Error occurred'"
                echo "  notify --sound -t 'Alert' 'Important message'"
                echo ""
                echo "Quick aliases:"
                echo "  notify-success <msg>   - Success notification"
                echo "  notify-error <msg>     - Error notification"
                echo "  notify-warn <msg>      - Warning notification"
                return 0
                ;;
            -t|--title)
                title="$2"
                shift 2
                ;;
            -p|--priority)
                priority="$2"
                shift 2
                ;;
            -i|--id)
                local id="$2"
                shift 2
                ;;
            --sound)
                local sound="--sound"
                shift
                ;;
            --vibrate)
                local vibrate="--vibrate $2"
                shift 2
                ;;
            *)
                content="$*"
                break
                ;;
        esac
    done

    # Send notification
    if [ -n "$content" ]; then
        termux-notification --title "$title" --content "$content" --priority "$priority" $sound $vibrate $id
    else
        echo "ERROR: No message provided"
        echo "Use 'notify --help' for usage information"
        return 1
    fi
}

# Quick notification aliases
alias notify-success='notify -t "Success" --sound'
alias notify-error='notify -t "Error" -p high --sound'
alias notify-warn='notify -t "Warning" -p high'

# ============================================
# Termux-API: WiFi Information
# ============================================

# WiFi information and network scanner
wifi() {
    local action="${1:-info}"

    case "$action" in
        -h|--help|help)
            echo "Usage: wifi [info|scan|watch]"
            echo ""
            echo "Commands:"
            echo "  wifi          - Show current WiFi connection details (default)"
            echo "  wifi info     - Show current WiFi connection details"
            echo "  wifi scan     - Scan and list available networks"
            echo "  wifi watch    - Monitor WiFi signal in real-time (Ctrl+C to stop)"
            echo ""
            echo "Examples:"
            echo "  wifi          - Show connection info"
            echo "  wifi scan     - Scan nearby networks"
            echo "  wifi watch    - Monitor signal strength"
            return 0
            ;;
        info)
            echo "[WIFI CONNECTION INFO]"
            echo "================================================================"

            local wifi_data=$(termux-wifi-connectioninfo 2>/dev/null)

            if [ -z "$wifi_data" ]; then
                echo "ERROR: Unable to get WiFi information"
                echo "Make sure Termux:API is installed and has permissions"
                return 1
            fi

            # Parse and display info
            echo "$wifi_data" | jq -r '
                "SSID:           \(.ssid // "Not connected")
BSSID:          \(.bssid // "N/A")
IP Address:     \(.ip // "N/A")
MAC Address:    \(.mac_address // "N/A")
----------------------------------------------------------------
Signal (RSSI):  \(.rssi // "N/A") dBm  \(
    if .rssi then
        if .rssi >= -50 then "(Excellent)"
        elif .rssi >= -60 then "(Good)"
        elif .rssi >= -70 then "(Fair)"
        else "(Poor)"
        end
    else ""
    end
)
Link Speed:     \(.link_speed_mbps // "N/A") Mbps
Frequency:      \(.frequency_mhz // "N/A") MHz  \(
    if .frequency_mhz then
        if .frequency_mhz >= 5000 then "(5 GHz)"
        else "(2.4 GHz)"
        end
    else ""
    end
)
Network ID:     \(.network_id // "N/A")
State:          \(.supplicant_state // "N/A")
Hidden SSID:    \(if .ssid_hidden then "Yes" else "No" end)
================================================================"'
            ;;
        scan)
            echo "[WIFI NETWORK SCAN]"
            echo "Scanning available networks..."
            echo "================================================================"

            termux-wifi-scaninfo 2>/dev/null | jq -r '
                sort_by(-.rssi) |
                .[] |
                "SSID:      \(.ssid // "(Hidden Network)")
BSSID:     \(.bssid)
Signal:    \(.rssi) dBm  \(
    if .rssi >= -50 then "(Excellent)"
    elif .rssi >= -60 then "(Good)"
    elif .rssi >= -70 then "(Fair)"
    else "(Poor)"
    end
)
Frequency: \(.frequency) MHz  \(
    if .frequency >= 5000 then "(5 GHz)"
    else "(2.4 GHz)"
    end
)
----------------------------------------------------------------"'
            echo "================================================================"
            echo "Networks sorted by signal strength (strongest first)"
            ;;
        watch)
            echo "[WIFI SIGNAL MONITOR]"
            echo "Monitoring WiFi signal... (Press Ctrl+C to stop)"
            echo ""

            while true; do
                local wifi_data=$(termux-wifi-connectioninfo 2>/dev/null)
                local timestamp=$(date '+%H:%M:%S')

                clear
                echo "[WIFI SIGNAL MONITOR] - $timestamp"
                echo "================================================================"

                echo "$wifi_data" | jq -r '
                    "SSID:        \(.ssid // "Not connected")
Signal:      \(.rssi // "N/A") dBm  \(
    if .rssi then
        if .rssi >= -50 then "[==========] Excellent"
        elif .rssi >= -60 then "[========--] Good"
        elif .rssi >= -70 then "[=====-----] Fair"
        else "[==--------] Poor"
        end
    else ""
    end
)
Link Speed:  \(.link_speed_mbps // "N/A") Mbps
IP Address:  \(.ip // "N/A")
================================================================"'

                echo ""
                echo "Press Ctrl+C to stop monitoring"
                sleep 2
            done
            ;;
        *)
            echo "ERROR: Unknown option: $action"
            echo "Use 'wifi help' for usage information"
            return 1
            ;;
    esac
}

# Quick alias for WiFi scan
alias wifi-scan='wifi scan'

# ============================================
# Termux-API: Location (GPS)
# ============================================

# Get location information using GPS
location() {
    local action="${1:-info}"
    local provider="${2:-gps}"

    case "$action" in
        -h|--help|help)
            echo "Usage: location [info|maps|copy|watch] [provider]"
            echo ""
            echo "Commands:"
            echo "  location          - Get current GPS location (default)"
            echo "  location info     - Show detailed location information"
            echo "  location maps     - Open location in Google Maps"
            echo "  location copy     - Copy coordinates to clipboard"
            echo "  location watch    - Monitor location in real-time"
            echo ""
            echo "Providers:"
            echo "  gps      - GPS satellites (most accurate, outdoor)"
            echo "  network  - WiFi/cell towers (faster, works indoor)"
            echo "  passive  - Last known location (instant)"
            echo ""
            echo "Examples:"
            echo "  location          - Get GPS location"
            echo "  location info network  - Get location via network"
            echo "  location maps     - Open in Google Maps"
            echo "  location copy     - Copy lat,long to clipboard"
            return 0
            ;;
        info)
            echo "[LOCATION INFO]"
            echo "Provider: $provider"
            echo "Getting location... (this may take 10-30 seconds)"
            echo "================================================================"

            local loc_data=$(termux-location -p "$provider" 2>/dev/null)

            if [ -z "$loc_data" ]; then
                echo "ERROR: Unable to get location"
                echo "Make sure:"
                echo "  - Termux:API app is installed"
                echo "  - Location permissions are granted"
                echo "  - GPS is enabled (for GPS provider)"
                echo "  - You are outdoors or near a window (for GPS)"
                return 1
            fi

            echo "$loc_data" | jq -r '
                if . == null or . == {} then
                    "ERROR: No location data received"
                else
                    "Latitude:       \(.latitude // "N/A")\u00b0
Longitude:      \(.longitude // "N/A")\u00b0
Altitude:       \(.altitude // "N/A") meters
----------------------------------------------------------------
Accuracy:       \(.accuracy // "N/A") meters  \(
    if .accuracy then
        if .accuracy <= 10 then "(Excellent)"
        elif .accuracy <= 50 then "(Good)"
        elif .accuracy <= 100 then "(Fair)"
        else "(Poor)"
        end
    else ""
    end
)
Speed:          \(.speed // "N/A") m/s\(
    if .speed and .speed > 0 then
        "  (\(.speed * 3.6 | floor) km/h)"
    else ""
    end
)
Bearing:        \(.bearing // "N/A")\u00b0\(
    if .bearing then
        if .bearing >= 337.5 or .bearing < 22.5 then " (N)"
        elif .bearing >= 22.5 and .bearing < 67.5 then " (NE)"
        elif .bearing >= 67.5 and .bearing < 112.5 then " (E)"
        elif .bearing >= 112.5 and .bearing < 157.5 then " (SE)"
        elif .bearing >= 157.5 and .bearing < 202.5 then " (S)"
        elif .bearing >= 202.5 and .bearing < 247.5 then " (SW)"
        elif .bearing >= 247.5 and .bearing < 292.5 then " (W)"
        else " (NW)"
        end
    else ""
    end
)
Provider:       \(.provider // "N/A")
================================================================
Google Maps: https://maps.google.com/?q=\(.latitude),\(.longitude)"
                end'
            ;;
        maps)
            echo "[OPEN IN GOOGLE MAPS]"
            echo "Getting location..."

            local loc_data=$(termux-location -p "$provider" 2>/dev/null)

            if [ -z "$loc_data" ]; then
                echo "ERROR: Unable to get location"
                return 1
            fi

            local lat=$(echo "$loc_data" | jq -r '.latitude // empty')
            local lon=$(echo "$loc_data" | jq -r '.longitude // empty')

            if [ -z "$lat" ] || [ -z "$lon" ]; then
                echo "ERROR: Invalid location data"
                return 1
            fi

            local maps_url="https://maps.google.com/?q=${lat},${lon}"
            echo "Location: ${lat}, ${lon}"
            echo "Opening: $maps_url"
            echo ""
            termux-open-url "$maps_url" 2>/dev/null
            echo "Map opened in browser!"
            ;;
        copy)
            echo "[COPY COORDINATES]"
            echo "Getting location..."

            local loc_data=$(termux-location -p "$provider" 2>/dev/null)

            if [ -z "$loc_data" ]; then
                echo "ERROR: Unable to get location"
                return 1
            fi

            local lat=$(echo "$loc_data" | jq -r '.latitude // empty')
            local lon=$(echo "$loc_data" | jq -r '.longitude // empty')

            if [ -z "$lat" ] || [ -z "$lon" ]; then
                echo "ERROR: Invalid location data"
                return 1
            fi

            echo "${lat},${lon}" | termux-clipboard-set
            echo "Copied to clipboard: ${lat},${lon}"
            ;;
        watch)
            echo "[LOCATION MONITOR]"
            echo "Monitoring location... (Press Ctrl+C to stop)"
            echo "Provider: $provider"
            echo ""

            while true; do
                local timestamp=$(date '+%H:%M:%S')

                clear
                echo "[LOCATION MONITOR] - $timestamp"
                echo "Provider: $provider"
                echo "================================================================"

                local loc_data=$(termux-location -p "$provider" -r last 2>/dev/null)

                if [ -n "$loc_data" ]; then
                    echo "$loc_data" | jq -r '
                        if . == null or . == {} then
                            "Waiting for location data..."
                        else
                            "Latitude:   \(.latitude // "N/A")\u00b0
Longitude:  \(.longitude // "N/A")\u00b0
Accuracy:   \(.accuracy // "N/A") meters  \(
    if .accuracy then
        if .accuracy <= 10 then "[==========] Excellent"
        elif .accuracy <= 50 then "[=======---] Good"
        elif .accuracy <= 100 then "[====------] Fair"
        else "[=---------] Poor"
        end
    else ""
    end
)
Speed:      \(.speed // 0) m/s\(
    if .speed and .speed > 0 then
        "  (\(.speed * 3.6 | floor) km/h)"
    else "  (Stationary)"
    end
)
Provider:   \(.provider // "N/A")"
                        end'
                else
                    echo "Waiting for location data..."
                fi

                echo "================================================================"
                echo ""
                echo "Press Ctrl+C to stop monitoring"
                sleep 3
            done
            ;;
        *)
            echo "ERROR: Unknown option: $action"
            echo "Use 'location help' for usage information"
            return 1
            ;;
    esac
}

# Quick aliases
alias loc='location'
alias gps='location info gps'
