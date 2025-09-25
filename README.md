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

