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
