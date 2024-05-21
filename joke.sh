#!/bin/bash

# Function to fetch all jokes and display them in sets
fetch_jokes() {
  search_term=$1
  num_jokes=$2
  interval=$3
  total_duration=$4

  # Fetch all jokes for the search term
  all_jokes=()
  page=1
  while true; do
    response=$(curl -k -s "https://icanhazdadjoke.com/search?term=${search_term}&page=${page}" -H "Accept: application/json")
    jokes=$(echo "$response" | jq -r '.results[] | @base64')

    # Check if there are no more jokes
    if [ -z "$jokes" ]; then
      break
    fi

    # Add jokes to the array
    while IFS= read -r joke; do
      all_jokes+=("$joke")
    done <<< "$jokes"

    page=$((page + 1))
  done

  # Function to decode base64 encoded jokes
  decode_joke() {
    echo "$1" | base64 --decode | jq -r '.joke'
  }

  # Display jokes in sets
  total_jokes=${#all_jokes[@]}
  total_requests=$((total_duration / interval))

  for ((i=0; i<total_requests; i++)); do
    echo "Displaying set $((i + 1)):"
    start_index=$((i * num_jokes))
    end_index=$((start_index + num_jokes - 1))
    if [ $start_index -ge $total_jokes ]; then
      echo "No more jokes to display."
      break
    fi
    for ((j=start_index; j<=end_index && j<total_jokes; j++)); do
      joke=$(decode_joke "${all_jokes[$j]}")
      echo "Joke $((j + 1)): $joke"
    done
    sleep $interval
  done

  # Handle remaining jokes if any
  remaining_jokes_start_index=$((total_requests * num_jokes))
  remaining_jokes_count=$((total_jokes - remaining_jokes_start_index))
  if [ $remaining_jokes_count -gt 0 ] && [ $remaining_jokes_count -lt $num_jokes ]; then
    echo "There are $remaining_jokes_count remaining jokes. Do you want to see them? (yes/no)"
    read user_input
    if [ "$user_input" = "yes" ]; then
      echo "Displaying remaining jokes:"
      for ((j=remaining_jokes_start_index; j<total_jokes; j++)); do
        joke=$(decode_joke "${all_jokes[$j]}")
        echo "Joke $((j + 1)): $joke"
      done
    else
      echo "Exiting without displaying remaining jokes."
    fi
  fi
}

# User input
echo "Enter search term:"
read search_term
echo "Enter number of jokes per set:"
read num_jokes

# Call the function with search term, number of jokes, interval, and duration
fetch_jokes $search_term $num_jokes 15 60
