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
