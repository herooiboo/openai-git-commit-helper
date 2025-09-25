#!/bin/bash

echo "Enter additional text to include in the request (press Enter to skip):"
read -r USER_ADDITIONAL_TEXT

# Hardcoded OpenAI API Key (Replace with your actual key)
OPENAI_API_KEY="YOUR_API_KEY"

# Ensure git is initialized
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: This is not a Git repository."
    exit 1
fi

# Check if API key is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OpenAI API key is missing."
    exit 1
fi

# Get list of modified and new files
CHANGES=$(git diff --name-only)
NEW_FILES=$(git ls-files --others --exclude-standard)

# If no changes detected, exit early
if [ -z "$CHANGES" ] && [ -z "$NEW_FILES" ]; then
    echo "No changes detected."
    exit 0
fi

# Build the Git changes summary
GIT_DIFF_SUMMARY=""

# Process modified files
if [ -n "$CHANGES" ]; then
    while IFS= read -r FILE; do
        DIFF_CONTENT=$(git diff "$FILE")
        GIT_DIFF_SUMMARY+="Modified: $FILE\n$DIFF_CONTENT\n------------------------------------\n"
    done <<< "$CHANGES"
fi

# Process new files
if [ -n "$NEW_FILES" ]; then
    while IFS= read -r FILE; do
        FILE_CONTENT=$(cat "$FILE" 2>/dev/null || echo "[File not found]")
        GIT_DIFF_SUMMARY+="New file: $FILE\n$FILE_CONTENT\n------------------------------------\n"
    done <<< "$NEW_FILES"
fi

# Limit the diff size for API call (truncate if too large)
MAX_TOKENS=80000000
TRUNCATED_DIFF=$(echo -e "$GIT_DIFF_SUMMARY" | head -c $MAX_TOKENS)

# Combine diff with user additional text
# Note: Insert a separator line if user provided text to keep clear distinction
if [ -n "$USER_ADDITIONAL_TEXT" ]; then
    COMBINED_CONTENT="$TRUNCATED_DIFF

Additional info:
$USER_ADDITIONAL_TEXT"
else
    COMBINED_CONTENT="$TRUNCATED_DIFF"
fi

# API endpoint
API_URL="https://api.openai.com/v1/chat/completions"

# JSON payload for OpenAI API
JSON_PAYLOAD=$(jq -n \
  --arg model "gpt-4o" \
  --arg diff "$COMBINED_CONTENT" \
  '{
    model: $model,
    messages: [
      { role: "system", content: "
      You are Git Commit Message Pro. Generate a concise and meaningful commit message based on the provided Git changes. Keep it clear and descriptive
      Capitalization and Punctuation: Capitalize the first word and do not end in punctuation. If using Conventional Commits, remember to use all lowercase.
Mood: Use imperative mood in the subject line. Example – Add fix for dark mode toggle state. Imperative mood gives the tone you are giving an order or request.
Type of Commit: Specify the type of commit. It is recommended and can be even more beneficial to have a consistent set of words to describe your changes. Example: Bugfix, Update, Refactor, Bump, and so on. See the section on Conventional Commits below for additional information.
Length: The first line should ideally be no longer than 50 characters, and the body should be restricted to 72 characters.
Content: Be direct, try to eliminate filler words and phrases in these sentences (examples: though, maybe, I think, kind of). Think like a journalist.
The commit type can include the following:


feat – a new feature is introduced with the changes
fix – a bug fix has occurred
chore – changes that do not relate to a fix or feature and dont modify src or test files (for example updating dependencies)
refactor – refactored code that neither fixes a bug nor adds a feature
docs – updates to documentation such as a the README or other markdown files
style – changes that do not affect the meaning of the code, likely related to code formatting such as white-space, missing semi-colons, and so on.
test – including new or correcting previous tests
perf – performance improvements
ci – continuous integration related
build – changes that affect the build system or external dependencies
revert – reverts a previous commit


Full Conventional Commit Example
fix: fix foo to enable bar


This fixes the broken behavior of the component by doing xyz. 


BREAKING CHANGE
Before this fix foo was not enabled at all, behavior changes from <old> to <new>


Closes D2IQ-12345



Commit Message Comparisons
Review the following messages and see how many of the suggested guidelines they check off in each category.


Good
feat: improve performance with lazy load implementation for images
chore: update npm dependency to latest version
Fix bug preventing users from submitting the subscribe form
Update incorrect client phone number within footer body per client request
Bad
fixed bug on landing page
Changed style
oops
I think I fixed it this time?
empty commit messages



i want the commit to be like this (not the same do your changes) after the first line 
dont use the following please this is for example only so you know how to generate the commit message dont use same the below but learn from it!
- Removed `xxx` dependency from `xxx` and `xxx`
- Refactored `xxx` to inject `xxx` via constructor instead of resolving it dynamically
- Updated `xxx` to accept explicit parameters instead of array-based input
- Enhanced `xxx` to include additional validation and return structured response data
- Introduced `xxx` event dispatching in `xxx`
i want to get each file in a line or you can group if they can be grouped, 


      " },
      { role: "user", content: $diff }
    ],
    max_tokens: 1000
  }')

# Make request to OpenAI API
RESPONSE=$(curl -s -X POST "$API_URL" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD")

# Extract AI-generated commit message (Handling response errors)
COMMIT_MESSAGE=$(echo "$RESPONSE" | jq -r '.choices[0].message.content // empty')

# Print the commit message
if [ -n "$COMMIT_MESSAGE" ]; then
    echo -e "\nGenerated Commit Message:\n--------------------------------------"
    echo "$COMMIT_MESSAGE"
    echo "--------------------------------------"
else
    echo "Error: Failed to generate commit message or received null response."
    echo "Full API Response: $RESPONSE"
fi
