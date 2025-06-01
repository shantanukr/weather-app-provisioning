from flask import Flask, render_template
import requests

app = Flask(__name__)

@app.route('/weather/<city>')
def get_weather(city):
    api_key = "YOUR_API_KEY"
    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}"
    response = requests.get(url)
    data = response.json()
    return render_template('weather.html', data=data)