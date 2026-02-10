import urllib.request
import ssl

ssl._create_default_https_context = ssl._create_unverified_context

url = "https://github.com/home-assistant/operating-system/archive/refs/heads/dev.zip"
filename = "os.zip"

print(f"Downloading {url} to {filename}...")
try:
    urllib.request.urlretrieve(url, filename)
    print("Download complete.")
except Exception as e:
    print(f"Error: {e}")
