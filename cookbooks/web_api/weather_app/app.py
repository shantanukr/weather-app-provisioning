from flask import Flask, render_template
from dotenv import load_dotenv
import requests
import os

load_dotenv()

app = Flask(__name__)

@app.route('/weather/<city>')
def get_weather(city):
    api_key = os.getenv("SECRET_KEY", "default-key")
    url = f'http://api.weatherapi.com/v1/current.json?key=&q=London&aqi=no'
    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}"
    response = requests.get(url)
    data = response.json()
    return render_template('weather.html', data=data)