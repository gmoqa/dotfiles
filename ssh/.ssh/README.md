# SSH Configuration

⚠️ **IMPORTANT SECURITY NOTICE** ⚠️

This directory should ONLY contain:
- ✅ `config` - SSH client configuration
- ✅ `known_hosts` - Server fingerprints (optional)

**NEVER commit these files:**
- ❌ Private keys (id_rsa, id_ed25519, etc.)
- ❌ Public keys (id_rsa.pub, id_ed25519.pub)
- ❌ Any file containing secrets or credentials

Keys should be managed separately and securely.
