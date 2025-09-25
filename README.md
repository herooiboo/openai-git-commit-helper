# Git Commit Message Generator

Automate generating clear, concise, and convention-compliant Git commit messages using OpenAI’s GPT model. This script summarizes recent code changes and optional user input, then requests a structured commit message.

## Features

- Detects modified and new files in a Git repository
- Summarizes code diffs for OpenAI input
- Prompts for additional user notes to enhance context
- Generates commit messages following Conventional Commit standards
- Outputs a ready-to-use commit message for consistent project history

## Usage

1. Place the script in your Git repository root.
2. Run the script to generate a commit message: `./gitgpt.sh`
3. Enter any additional text when prompted or press Enter to skip.
4. Review the generated commit message output.
5. Use the message in your `git commit` command.

## Requirements

- Bash shell
- Git installed and initialized in the directory
- OpenAI API key (insert in the script)

### How to Run Git Commit Message Script in PhpStorm with a Key Binding (Windows, Linux, macOS)

1. **Save and Make Script Executable**

- On Linux/macOS: `chmod +x /path/to/gitgpt.sh`
- On Windows (using WSL or Git Bash, no chmod needed usually):
Use the script as is or adjust for your shell environment.

2. **Add External Tool in PhpStorm**

- Open PhpStorm Settings/Preferences:
- Windows/Linux: `File` > `Settings`
- macOS: `PhpStorm` > `Preferences`

- Go to `Tools` > `External Tools`

- Click `+` to add a new tool

- Fill fields according to your OS:

| OS      | Program                      | Arguments                                    | Working directory    |
|---------|------------------------------|----------------------------------------------|---------------------|
| Linux/macOS | `/bin/bash`                | `-c '/path/to/generate_commit_message.sh'`  | `$ProjectFileDir$`   |
| Windows  | `C:\Windows\System32\bash.exe` or path to Git Bash (e.g. `C:\Program Files\Git\bin\bash.exe`) | `-c '/path/to/generate_commit_message.sh'`  | `$ProjectFileDir$`   |

3. **Assign Keyboard Shortcut**

- In Settings/Preferences, go to `Keymap`
- Search for your new External Tool name (e.g., "Generate Git Commit Message")
- Right-click it and select `Add Keyboard Shortcut`
- Press your desired shortcut (e.g., `Ctrl+Alt+M` or `Cmd+Alt+M` on macOS)
- Click `OK` to confirm

4. **Usage**

- Press the assigned shortcut inside PhpStorm to run the script
- Follow any on-screen prompts (e.g., entering additional text)
- See the commit message output in the Run or Terminal console within PhpStorm

---

This setup works cross-platform if the script and shell environment are accessible and properly configured.
