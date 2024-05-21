# 🃏 Joke Fetcher Script

This repository contains scripts in *Bash* to fetch jokes from the [icanhazdadjoke](https://icanhazdadjoke.com/api) API based on user-defined search terms. The scripts fetch a new set of jokes every 15 seconds for 1 minute, displaying each joke individually.

## 📜 Problem Statement

Write a script to call the https://icanhazdadjoke.com/api endpoint for a new set of jokes every 15 seconds for 1 minute. The script should:
- Accept user input for a search term and the number of jokes in a set.
- Provide each joke in the set individually, not all at once.

### Example
> Fetch 3 jokes with the search term 'snow'.

## 💡 Solution Overview

### Features
- Accept user input for a search term and number of jokes.
- Make API requests to fetch jokes based on the search term.
- Display each joke individually with a 15-second delay between sets.
- Run the entire process for 1 minute.

### Languages
- [Bash](#bash-script-solution)

## 🐚 Bash Script Solution

### Script

```bash
#!/bin/bash

# Function to fetch jokes
fetch_jokes() {
  search_term=$1
  num_jokes=$2
  interval=$3
  total_duration=$4
  
  # Calculate the total number of requests based on duration and interval
  total_requests=$((total_duration / interval))
  
  for ((i=0; i<total_requests; i++))
  do
    for ((j=0; j<num_jokes; j++))
    do
      joke=$(curl -s "https://icanhazdadjoke.com/search?term=${search_term}" -H "Accept: application/json" | jq -r ".results[$j].joke")
      echo "Joke $((j+1)): $joke"
    done
    sleep $interval
  done
}

# User input
echo "Enter search term:"
read search_term
echo "Enter number of jokes per set:"
read num_jokes

# Call the function with search term, number of jokes, interval, and duration
fetch_jokes $search_term $num_jokes 15 60
