book() {
  local dir="$HOME/Books"
  mkdir -p "$dir"
  case "$1" in
    search)
      shift
      [[ -z "$*" ]] && { echo "usage: book search <query>"; return 1; }
      local query="${*// /+}"
      echo "Searching gutenberg..."
      local pick
      pick=$(for p in 1 2 3; do
        curl -sL "https://gutendex.com/books?search=$query&page=$p" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for b in data['results']:
    epub = b['formats'].get('application/epub+zip', '')
    if epub:
        authors = ', '.join(a['name'] for a in b['authors'])
        print(f\"{b['title']} — {authors}\t{epub}\")
" 2>/dev/null
      done | fzf --with-nth=1 --delimiter='\t' --prompt='pick a book: ')
      [[ -z "$pick" ]] && return
      local url="${pick##*$'\t'}"
      local name="${pick%%$'\t'*}"
      local filename="${name// /_}.epub"
      echo "Downloading: $name"
      curl -L -o "$dir/$filename" "$url" && echo "Saved to $dir/$filename"
      ;;
    read)
      local pick
      pick=$(ls "$dir"/*.epub 2>/dev/null | sed 's|.*/||; s|\.epub$||; s|_| |g' | fzf --prompt='pick a book: ')
      [[ -z "$pick" ]] && return
      epy "$dir/${pick// /_}.epub"
      ;;
    list)
      ls "$dir"/*.epub 2>/dev/null | sed 's|.*/||; s|\.epub$||; s|_| |g' || echo "No books yet. Try: book search <query>"
      ;;
    rm)
      local pick
      pick=$(ls "$dir"/*.epub 2>/dev/null | sed 's|.*/||; s|\.epub$||; s|_| |g' | fzf --prompt='remove a book: ')
      [[ -z "$pick" ]] && return
      rm "$dir/${pick// /_}.epub" && echo "Removed: $pick"
      ;;
    *)
      echo "usage: book <search|read|list|rm> [query]"
      ;;
  esac
}
