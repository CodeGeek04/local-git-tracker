mkdir -p "$HOME/.git-essentials"
gclone () {
    local url=$1
    local dest=$2
    
    # Registry file
    local registry="$HOME/.git-essentials/git-clones"
    
    # Check if this repo is already cloned
    if grep -q "$url" "$registry" 2>/dev/null; then
        echo "⚠️  This repository is already cloned:"
        grep "$url" "$registry"
        echo -n "Continue anyway? (y/n) "
        read -r REPLY
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    # Clone the repo
    if [ -z "$dest" ]; then
        git clone "$url"
    else
        git clone "$url" "$dest"
    fi
    
    # Record in registry
    if [ $? -eq 0 ]; then
        echo "$url -> $(cd "$dest" && pwd)" >> "$registry"
    fi
}
