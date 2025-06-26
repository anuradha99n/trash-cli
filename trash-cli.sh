#!/bin/bash

TRASH_DIR="~/.local/share/trash-cli"
FILES_DIR="$TRASH_DIR/files"
INFO_DIR="$TRASH_DIR/info"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

mkdir -p "$FILES_DIR" "$INFO_DIR"

function trash_file() {
    for item in "$@"; do
        if [[ ! -e "$item" ]]; then
            echo "trash-cli: '$item' does not exist"
            continue
        fi

        BASENAME=$(basename "$item")
        ID="${BASENAME}_$TIMESTAMP"
        mv "$item" "$FILES_DIR/$ID"

        echo -e "OriginalPath=$(realpath "$item")\nDeletedAt=$(date)\nSavedAs=$ID" > "$INFO_DIR/$ID.info"
        echo "Moved '$item' to trash"
    done
}

function list_trash() {
    for info in "$INFO_DIR"/*.info; do
        [[ -e "$info" ]] || { echo "(Trash is empty)"; return; }
        ID=$(basename "$info" .info)
        ORIG=$(grep OriginalPath "$info" | cut -d'=' -f2-)
        DATE=$(grep DeletedAt "$info" | cut -d'=' -f2-)
        echo "$ID -> $ORIG (Deleted at: $DATE)"
    done
}

function restore_file() {
    if [[ -z "$1" ]]; then
        echo "Usage: trash-cli restore <file_id>"
        return
    fi

    ID="$1"
    INFO_FILE="$INFO_DIR/$ID.info"
    FILE="$FILES_DIR/$ID"

    if [[ ! -f "$INFO_FILE" || ! -f "$FILE" ]]; then
        echo "trash-cli: ID '$ID' not found in trash"
        return
    fi

    DEST=$(grep OriginalPath "$INFO_FILE" | cut -d'=' -f2-)
    DEST_DIR=$(dirname "$DEST")

    mkdir -p "$DEST_DIR"
    mv "$FILE" "$DEST"
    rm "$INFO_FILE"

    echo "Restored to: $DEST"
}

function empty_trash() {
    rm -rf "$FILES_DIR"/* "$INFO_DIR"/*
    echo "Trash emptied."
}

# Main command dispatcher
case "$1" in
    put)
        shift
        trash_file "$@"
        ;;
    list)
        list_trash
        ;;
    restore)
        restore_file "$2"
        ;;
    empty)
        empty_trash
        ;;
    help|*)
        echo "Usage:"
        echo "  trash-cli put <file1> [file2...]  - Move files to trash"
        echo "  trash-cli list                    - List trashed files"
        echo "  trash-cli restore <file_id>       - Restore a trashed file"
        echo "  trash-cli empty                   - Empty the trash"
        ;;
esac
