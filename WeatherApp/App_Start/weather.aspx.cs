using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net.Http;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Newtonsoft.Json;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace WeatherApp.App_Start
{
    public partial class weather : System.Web.UI.Page
    {
        public const double KELVIN = 273;
        private readonly HttpClient client = new HttpClient();

        public WeatherData Weather { get; set; } = new WeatherData() { Description = " - ", City = "Baia Mare", Country = " - ", IconId = "unknown-weather-icon", Temperature = new Temperature() { Value = 20, Unit = "C"} };

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // initializarea datelor pt vreme
                Weather.Temperature = new Temperature { Unit = "celsius" };
            }
        }

        [System.Web.Services.WebMethod]

        private void UpdateWeatherDisplay(WeatherResponse data)
        {
            Weather.Temperature.Value = Math.Floor(data.Main.Temp - KELVIN);
            Weather.Description = data.Weather[0].Description;
            Weather.IconId = data.Weather[0].Icon;
            Weather.City = data.Name;
            Weather.Country = data.Sys.Country;

            // update UI
            WeatherIcon.ImageUrl = $"~/Icons/{Weather.IconId}.png";
            TemperatureValue.Text = Weather.Temperature.Value.ToString();
            TemperatureDescription.Text = Weather.Description;
            LocationInfo.Text = $"{Weather.City}, {Weather.Country}";
        }

        private double CelsiusToFahrenheit(double temperature)
        {
            return (temperature * 9 / 5) + 32;
        }
    }

    public class WeatherData
    {
        public Temperature Temperature { get; set; }
        public string Description { get; set; }
        public string IconId { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
    }

    public class Temperature
    {
        public double Value { get; set; }
        public string Unit { get; set; }
    }

    public class WeatherResponse
    {
        public MainInfo Main { get; set; }
        public WeatherInfo[] Weather { get; set; }
        public string Name { get; set; }
        public SysInfo Sys { get; set; }
    }

    public class MainInfo
    {
        public double Temp { get; set; }
    }

    public class WeatherInfo
    {
        public string Description { get; set; }
        public string Icon { get; set; }
    }

    public class SysInfo
    {
        public string Country { get; set; }
    }

}