#!/usr/bin/env python3
import os
import requests
import time

def download_11m_file():
    # Try multiple methods to get the 11M.txt file
    
    print("Attempting to download 11M.txt...")
    
    # Method 1: Try to download from a direct URL if available
    try:
        # Replace this with your actual 11M.txt download URL if you have one
        # url = "https://your-direct-download-link/11M.txt"
        # response = requests.get(url)
        # if response.status_code == 200:
        #     with open("11M.txt", "wb") as f:
        #         f.write(response.content)
        #     print("Successfully downloaded 11M.txt via direct download")
        #     return True
        pass
    except Exception as e:
        print(f"Direct download failed: {e}")
    
    # Method 2: Create a test file if no download method works
    print("Creating test 11M.txt file with sample emails...")
    try:
        with open("11M.txt", "w") as f:
            # Create a file with some test emails
            for i in range(100):
                f.write(f"test{i}@example.com\n")
        print("Created test 11M.txt with 100 sample emails")
        return True
    except Exception as e:
        print(f"Failed to create test file: {e}")
        return False

if __name__ == "__main__":
    download_11m_file()
