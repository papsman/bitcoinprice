import http.server
import threading
import json
import time
import urllib.request

# Replace with your own API key
API_KEY = "2901f9f65a50b3383f891aa933e623cc952f433b90995014234d47f7fcf00630"
API_URL = f"https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD&api_key={API_KEY}"
UPDATE_INTERVAL = 10  # Update price every 10 seconds

# Initialize price and average variables
current_price = None
average_prices = []
average_duration = 600  # 10 minutes in seconds

class PriceHandler(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        global current_price, average_prices

        # Update price if it's older than update interval
        if current_price is None or time.time() - current_price[1] > UPDATE_INTERVAL:
            with urllib.request.urlopen(API_URL) as response:
                data = json.loads(response.read().decode())
                current_price = (data["USD"], time.time())

            # Update average price list
            average_prices.append(current_price[0])
            if len(average_prices) > average_duration // UPDATE_INTERVAL:
                average_prices.pop(0)

        # Calculate average price
        average_price = sum(average_prices) / len(average_prices) if average_prices else 0

        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        
        response_data = json.dumps({"current_price": current_price[0], "average_price": average_price})
        self.wfile.write(response_data.encode())

def update_price():
    global current_price, average_prices

    while True:
        # Update price in a separate thread
        with urllib.request.urlopen(API_URL) as response:
            data = json.loads(response.read().decode())
            current_price = (data["USD"], time.time())

        # Update average price list
        average_prices.append(current_price[0])
        if len(average_prices) > average_duration // UPDATE_INTERVAL:
            average_prices.pop(0)

        time.sleep(UPDATE_INTERVAL)

# Start price update thread
price_update_thread = threading.Thread(target=update_price)
price_update_thread.daemon = True
price_update_thread.start()

# Start HTTP server
PORT = 8000
with http.server.HTTPServer(("", PORT), PriceHandler) as httpd:
    print(f"Serving on port {PORT}")
    httpd.serve_forever()
