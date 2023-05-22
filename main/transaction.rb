require 'json'
require 'rest-client'

# Obtener los mercados disponibles en Buda.com
response = RestClient.get 'https://www.buda.com/api/v2/markets'
markets = JSON.parse(response.body)

# Crear el archivo HTML
html = File.open('transacciones.html', 'w')

# Escribir el encabezado del archivo HTML
html.puts('<html><body>')
html.puts('<h1>Transacciones de mayor valor en Buda.com</h1>')

# Recorrer los mercados
markets.each do |market|
  # Obtener la transacción de mayor valor en las últimas 24 horas para cada mercado
  response = RestClient.get "https://www.buda.com/api/v2/markets/#{market['id']}/trades"
  trades = JSON.parse(response.body)
  highest_trade = trades.max_by { |trade| trade['amount'] }

  # Escribir la información en el archivo HTML
  html.puts("<h2>#{market['name']}</h2>")
  html.puts("<p>Transacción de mayor valor:</p>")
  html.puts("<p>Fecha: #{highest_trade['date']}</p>")
  html.puts("<p>Precio: #{highest_trade['price']}</p>")
  html.puts("<p>Cantidad: #{highest_trade['amount']}</p>")
  html.puts("<p>Total: #{highest_trade['total']}</p>")
end

# Cerrar el archivo HTML
html.puts('</body></html>')
html.close

puts 'Archivo HTML generado exitosamente.'
