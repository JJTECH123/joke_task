import requests
import time

def fetch_jokes(search_term, num_jokes, interval, total_duration):
    total_requests = total_duration // interval
    
    for _ in range(total_requests):
        response = requests.get(f"https://icanhazdadjoke.com/search?term={search_term}", headers={"Accept": "application/json"})
        jokes = response.json().get("results", [])
        
        for i in range(min(num_jokes, len(jokes))):
            print(f"Joke {i+1}: {jokes[i]['joke']}")
        
        time.sleep(interval)

if _name_ == "_main_":
    search_term = input("Enter search term: ")
    num_jokes = int(input("Enter number of jokes per set: "))
    
    # Call the function with search term, number of jokes, interval, and duration
    fetch_jokes(search_term, num_jokes, 15, 60)
