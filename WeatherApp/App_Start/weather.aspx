<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="weather.aspx.cs" Inherits="WeatherApp.App_Start.weather" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Weather App</title>

    <style>
        * {
    font-family: 'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;
        }

        body {
            background-color: cornflowerblue;
        }

        .container {
            width: 300px;
            background-color: white;
            display: block;
            margin: 0 auto;
            border-radius: 10px;
            padding-bottom: 50px;
        }

        .app-title {
            width: 300px;
            height: 50px;
            border-radius: 10px 10px 0 0;
        }

        .app-title p {
            text-align: center;
            padding: 15px;
            margin: 0 auto;
            font-size: 1.2em;
            color: #515e8a;
        }

        .notification {
            background-color: #cccaca;
            display: none;
        }

        .notification p {
            color: #6e1d24;
            font-size: 1.2em;
            margin: 0;
            text-align: center;
            padding: 10px 0;
        }

        .weather-container {
            width: 300px;
            height: 260px;
            background-color: #ebf3fc;
        }

        .weather-icon {
            width: 300px;
            height: 128px;
        }

        .weather-icon img {
            display: block;
            margin: 0 auto;
        }

        .temperature-value {
            width: 300px;
            height: 60px;
        }

        .temperature-value p {
            padding: 0;
            margin: 0;
            color: cornflowerblue;
            font-size: 4em;
            text-align: center;
            cursor: pointer;
        }

        .temperature-value p:hover {
        }

        .temperature-value span {
            color: cornflowerblue;
            font-size: 0.5em;
        }

        .temperature-description {
        }

        .temperature-description p {
            padding: 8px;
            margin: 0;
            color: cornflowerblue;
            text-align: center;
            font-size: 1.2em;
        }

        .location {
        }

        .location p {
            margin: 0;
            padding: 0;
            color: cornflowerblue;
            text-align: center;
            font-size: 0.8em;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="app-title">
                <p>Weather</p>
            </div>
            <div class="notification">
                <asp:Label ID="NotificationLabel" runat="server"></asp:Label>
            </div>
            <div class="weather-container">
                <div class="weather-icon">
                    <asp:Image ID="WeatherIcon" runat="server" ImageUrl="~/Icons/unknown-weather-icon.png" />
                </div>
                <div class="temperature-value">
                    <p>
                        <asp:Label ID="TemperatureValue" runat="server" Text="- "></asp:Label>&deg<span>C</span>
                    </p>
                </div>
                <div class="temperature-description">
                    <p>
                        <asp:Label ID="TemperatureDescription" runat="server"><%=  Weather.Description %></asp:Label>
                    </p>
                </div>
                <div class="location">
                    <p>
                        <asp:Label ID="LocationInfo" runat="server" Text="-"></asp:Label>
                    </p>
                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        const KELVIN = 273.00;
        const api = "82005d27a116c2880c8f0fcb866998a0";
        const iconElement = document.querySelector(".weather-icon");
        const tempElement = document.querySelector(".temperature-value p");
        const descElement = document.querySelector(".temperature-description p");
        const locationElement = document.querySelector(".location p");
        const notificationElement = document.querySelector(".notification");

        const weather = { "Description":" - ", "City" : "Baia Mare", "Country" : " - ", "IconId" : "unknown-weather-icon", "Temperature" : { "Value" : 20, "Unit" : "C" }};
        if ('geolocation' in navigator) {
            navigator.geolocation.getCurrentPosition(setPosition, showError);
        } else {
            notificationElement.style.display = "block";
            notificationElement.innerHTML = "<p>Please use a browser with active geolocation.</p>";
        }
        function setPosition(position) {
            let latitude = position.coords.latitude;
            let longitude = position.coords.longitude;

            getWeather(latitude, longitude);
        }

        function showError(error) {
            notificationElement.style.display = "block";
            notificationElement.innerHTML = `<p> ${error.message} </p>`;
        }
        function getWeather(latitude, longitude) {
            let apiKey = `https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=${api}`; //weather api

            fetch(apiKey)
                .then(function (response) {
                    let data = response.json();
                    return data;
                })
                .then(function (data) {
                    console.log(data);
                    console.log(data.main.temp);
                    weather.Temperature.Value = Math.floor(data.main.temp - KELVIN);
                    weather.Description = data.weather[0].description;
                    weather.IconId = data.weather[0].icon;
                    weather.City = data.name;
                    weather.Country = data.sys.country;
                })
                .then(function () {
                    displayWeather();
                });
        }

        function displayWeather() {
            iconElement.innerHTML = `<img src="../Icons/${weather.IconId}.png"/>`;
            tempElement.innerHTML = `${weather.Temperature.Value}&deg<span>C</span>`;
            descElement.innerHTML = weather.Description;
            locationElement.innerHTML = `${weather.City}, ${weather.Country}`;
        }
</script>
</body>
</html>