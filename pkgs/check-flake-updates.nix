{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "check-flake-updates";
  runtimeInputs = with pkgs; [
    jq
    coreutils
  ];
  text = ''
    FLAKE_LOCK="''${1:-flake.lock}"

    if [[ ! -f "$FLAKE_LOCK" ]]; then
      echo "Error: $FLAKE_LOCK not found" >&2
      exit 1
    fi

    format_timestamp() {
      local ts="$1"
      date -u -d "@$ts" "+%Y-%m-%d %H:%M:%S UTC" 2>/dev/null || date -u -r "$ts" "+%Y-%m-%d %H:%M:%S UTC" 2>/dev/null || echo "unknown"
    }

    echo "Checking for input updates in $FLAKE_LOCK..."
    echo ""

    ROOT_INPUTS=$(jq -r '.nodes.root.inputs | keys[]' "$FLAKE_LOCK")
    for input in $ROOT_INPUTS; do
      node_name=$(jq -r ".nodes.root.inputs[\"$input\"]" "$FLAKE_LOCK")

      # Get .nodes."$node_name".locked."$attr"
      get_locked() {
        jq -r ".nodes[\"$node_name\"].locked.$1" "$FLAKE_LOCK"
      }

      node_type=$(get_locked type)
      if [[ "$node_type" != "github" ]]; then
        continue
      fi

      owner=$(get_locked owner)
      repo=$(get_locked repo)
      current_rev=$(get_locked rev)
      current_timestamp=$(get_locked lastModified)
      current_date=$(format_timestamp "$current_timestamp")

      ref=$(jq -r ".nodes[\"$node_name\"].original.ref // empty" "$FLAKE_LOCK")
      if [[ -n "$ref" ]]; then
        flake_ref="github:$owner/$repo/$ref"
      else
        flake_ref="github:$owner/$repo"
      fi

      if ! flake_info=$(nix flake info "$flake_ref" --json 2>/dev/null); then
        echo "$input: Failed to fetch flake info"
        continue
      fi

      latest_rev=$(echo "$flake_info" | jq -r '.revision // empty')
      if [[ -z "$latest_rev" ]]; then
        echo "$input: Could not parse latest revision from flake info"
        continue
      fi

      latest_timestamp=$(echo "$flake_info" | jq -r '.lastModified // empty')
      if [[ -n "$latest_timestamp" ]]; then
        latest_date=$(format_timestamp "$latest_timestamp")
      else
        latest_date="unknown"
      fi

      if [[ "$current_rev" != "$latest_rev" ]]; then
        current_short="''${current_rev:0:7}"
        latest_short="''${latest_rev:0:7}"
        echo "$input ($flake_ref)"
        echo " Current: $current_short ($current_date)"
        echo " Latest:  $latest_short ($latest_date)"
        echo " Diff: https://github.com/$owner/$repo/compare/$current_short...$latest_short"
        echo ""
      fi
    done
  '';
}
