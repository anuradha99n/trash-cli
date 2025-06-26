# 🗑️ trash-cli

A simple, safe, and scriptable **command-line trash manager** for Linux. Instead of deleting files permanently with `rm`, use `trash-cli` to move them to a recoverable trash bin — just like your desktop environment.

---

## 📦 Features

- Safely "delete" files or directories by moving them to a trash bin
- Restore trashed files to their original location
- List all trashed files with deletion timestamps
- Permanently empty the trash
- Fully terminal-based with no external dependencies

---
## 📂 Directory Structure

```bash
    ~/.local/share/trash-cli
    ├── files/       # Trashed files/folders
    └── info/        # Metadata (original path, deletion time)  
```
---

## 🛠️ Installation

1. **Clone the Repo or Download project**

2. **Copy the script**

    Copy `trash-cli.sh` file to `/usr/local/bin/`

    ```bash
    cp trash-cli.sh /usr/local/bin/trash-cli
    ```
3. **Make it Executable**
    ```bash
    sudo chmod +x /usr/local/bin/trash-cli
    ```

---
## 🚀 Usage

### 1. Move file/folder to trash:
```bash
trash-cli put myfile.txt folder/
```
### 2. List all trashed items:
```bash
trash-cli list
```

Example Output:
```bash
myfile.txt_20250605181230 -> /home/user/myfile.txt (Deleted at: Wed Jun  5 18:12:30 2025)
```
### 3. Restore a trashed item:
```bash
trash-cli restore myfile.txt_20250605181230
```
Restores to the original directory (if it still exists).
### 4. Empty the trash:
```bash
trash-cli empty
```
