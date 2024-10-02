require "net/http"
require "json"

class Converter
  COINDESK_API_URL = "https://api.coindesk.com/v1/bpi/currentprice.json"
  module ConversionMethods
    COINS = {
      "BTC" => { "USD" => :btc_to_usd },
      "USD" => { "BTC" => :usd_to_btc }
    }.freeze
  end

  def initialize
    @btc_to_usd_rate = fetch_rate
  end

  def btc_to_usd(btc_amount)
    (btc_amount * @btc_to_usd_rate).round(2)
  end

  def usd_to_btc(usd_amount)
    (usd_amount / @btc_to_usd_rate).round(8)
  end

  def bitcoinize(amount)
    BigDecimal(amount.to_s).round(8)
  end

  def dollarize(amount)
    BigDecimal(amount.to_s).round(2)
  end

  private

  # Consulta la API de CoinDesk para obtener el valor actual de BTC en USD
  def fetch_rate
    url = URI.parse(COINDESK_API_URL)
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      data["bpi"]["USD"]["rate_float"]
    else
      raise "Error fetching BTC to USD rate"
    end
  end
end
