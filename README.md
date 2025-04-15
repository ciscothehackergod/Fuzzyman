

---
You should have the FFUF to be installed in your system for this script to work .

to install FFUF go this url : https://github.com/ffuf/ffuf
 you should also have golang installed in your pc aswell .   


Note : Rename the domains list to domains.txt and the wordlist file to list.txt

# Automated Directory Bruteforce Script

This script automates directory bruteforcing on a list of URLs using **FFUF**. Perfect for bug bounty hunters, penetration testers, or anyone who wants to quickly test multiple domains for hidden files and directories.

## Features

- **Automated fuzzing** of multiple domains.
- **Customizable** parameters (threads, wordlist, extensions).
- **Low resource usage** (works fine on 1GB RAM, 1-core VPS).
- **Random user-agent rotation** to avoid blocking.
- **Output results** in JSON format.

## Requirements

- **FFUF**: Install it from [FFUF GitHub](https://github.com/ffuf/ffuf).
- **Bash shell** (Linux/macOS recommended).
- **Wordlist** (e.g., `list.txt` from SecLists).

## Installation

1. **Install FFUF**:
   ```bash
   sudo apt install ffuf  # On Ubuntu/Debian
   ```

2. **Download the script**:
   [Download the script](#)

3. **Create `domains.txt`**: Add URLs you want to brute force, one per line:
   ```
   https://example.com
   https://another.com
   ```

4. **Set up wordlist**: Customize or use an existing one (e.g., `list.txt`).

## Usage

1. Make the script executable:
   ```bash
   chmod +x fuzz_script.sh
   ```

2. Run the script:
   ```bash
   ./fuzz_script.sh
   ```

Results will be saved in the `results/` directory as JSON files for each domain.

## Customize

- **Threads**: Adjust `threads` for speed.
- **Extensions**: Modify `extensions` for file types.
- **Status codes**: Modify `status_codes` to filter responses.

## License

MIT License – Feel free to modify and use it as you like.

---


