# 📦 Repository Sync Script

A Bash script to synchronize multiple Git repositories and download files from a single configuration file.  
It provides a clean, repeatable way to keep projects, tools, and scripts up to date.

---

## ✨ Features

- ⬇️ Clone Git repositories
- 🔄 Pull updates for existing repositories
- 📦 Download non-Git files via direct URLs
- 📂 Custom target subdirectories and folder names
- 🔁 Safe Git updates using `git pull --rebase --autostash`
- 🧾 Simple configuration file
- ✅ Safe to run multiple times

---

## 📁 Default Directory Layout

All repositories and files are stored under: ~/projects/

Example layout:

projects/
├── backend/
│ └── api-service/
├── frontend/
│ └── web-app/
└── tools/
└── script.sh


---

## 📄 Configuration File: `repos.list`

Each line in `repos.list` defines one repository or file to sync.

### Format


### Fields

| Field | Description |
|-----|-------------|
| `URL` | Git repository URL (`.git`) or direct file URL |
| `subdirectory` | *(Optional)* Subfolder inside `~/projects` |
| `folder_name` | *(Optional)* Target directory name |

### Examples

```text
# Git repositories
https://github.com/user/project.git | backend | api-service
https://github.com/user/frontend.git | frontend |

# File download
https://example.com/script.sh | tools | utility-scripts


