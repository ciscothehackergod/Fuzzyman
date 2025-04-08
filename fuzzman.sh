#!/bin/bash

wordlist="./list.txt"  # Assetnote's real-world tested list
status_codes="200,301,302,401,403,407,500,502"
extensions=".php,.bak,.old,.txt,.conf,.ini,.log,.sql,.json,.js,.html,.xml,.env,.yml,.yaml,.config,.db"
threads=20  # Reduced threads to lower memory usage
delay=1  # Delay of 1 second between requests to reduce load
output_dir="results"
chunk_size=20000  # Chunk size for wordlist (process 50,000 lines at a time)

# List of common User-Agent strings
user_agents=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/91.0.864.59 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/89.0 Safari/537.36"
    "Mozilla/5.0 (Windows NT 6.1; rv:54.0) Gecko/20100101 Firefox/54.0"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"
    "Mozilla/5.0 (Linux; Android 10; Pixel 3 XL) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36"
    "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.0"
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
)

# Check for available swap space to prevent memory issues
if ! swapon -s; then
    echo "[*] No swap space found. Creating swap file..."
    sudo fallocate -l 1G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
    echo "[*] Swap file created and activated."
else
    echo "[*] Swap space is already available."
fi

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Split the wordlist into smaller chunks
split -l $chunk_size "$wordlist" "${wordlist}_chunk_"

# Loop through the chunks and fuzz each one
for chunk in ${wordlist}_chunk_*; do
  echo "[*] Fuzzing with chunk: $chunk"

  while read -r url; do
    domain=$(echo "$url" | awk -F/ '{print $3}')
    echo "[*] Bruteforcing directories at $url"

    # Randomize User-Agent for each request
    user_agent="${user_agents[$RANDOM % ${#user_agents[@]}]}"

    # Start the fuzzing process with randomized User-Agent
    ffuf -u "$url/FUZZ" \
         -w "$chunk" \
         -mc "$status_codes" \
         -e "$extensions" \
         -r \  # Follow redirects
         -t "$threads" \
         -o "$output_dir/${domain}_$(basename "$chunk").json" \
         -of json \
         -H "User-Agent: $user_agent" \
         -H "Accept-Language: en-US,en;q=0.9" \
         -H "Referer: $url" \
         -delay $delay  # Adjusted delay to reduce load

    # Optional: Sleep for a random time between requests to mimic human behavior
    sleep $((RANDOM % 2 + 1))  # Random sleep between 1 and 2 seconds
  done < domains.txt

  echo "[*] Finished fuzzing chunk: $chunk"
done

echo "[*] Fuzzing complete!"
