# defmodule Network.SSDP.Discovery do
#   @moduledoc """
#   Devices broadcast information about themselves over the network, and control points
#    listen for these broadcasts and use the information to identify interesting devices.
#   """

#   @multicast_address {239, 255, 255, 250}
#   @multicast_port 1900

#   def M_search_message do
#     message =
#       "NOTIFY * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nNT: upnp:rootdevice\r\nNTS: ssdp:alive\r\nUSN: uuid:00000000-0000-0000-0000-000000000000::upnpe:rootdevice\r\nLOCATION: http://localhost:8080/description.xml\r\nCACHE-CONTROL: max-age=1800\r\nSERVER: Elixir\r\n\r\n"
#   end

#   def start_link do
#     {:ok, socket} = :gen_udp.open(0)
#     multicast_port = 1900

#     :ok =
#       :inet.setopts(socket, [
#         {:add_membership, @multicast_address},
#         {:multicast_loop, false},
#         {:multicast_ttl, 4}
#       ])

#     :ok = :gen_udp.bind(socket, multicast_port)
#     send_notification(socket)
#     receive_loop(socket)
#   end

#   defp receive_loop(socket) do
#     receive do
#       {:udp, _, _, data} ->
#         handle_request(data)
#         receive_loop(socket)
#     end
#   end

#   defp send_notification(socket) do
#     message =
#       "NOTIFY * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nNT: upnp:rootdevice\r\nNTS: ssdp:alive\r\nUSN: uuid:00000000-0000-0000-0000-000000000000::upnpe:rootdevice\r\nLOCATION: http://localhost:8080/description.xml\r\nCACHE-CONTROL: max-age=1800\r\nSERVER: Elixir\r\n\r\n"

#     :ok = :gen_udp.send(socket, multicast_address, multicast_port, message)
#   end

#   defp handle_request(data) do
#     case data do
#       "M-SEARCH * HTTP/1.1\r\n" ->
#         send_response(socket)

#       _ ->
#         :ok
#     end
#   end

#   defp send_response(socket) do
#     message =
#       "HTTP/1.1 200 OK\r\nCACHE-CONTROL: max-age=1800\r\nEXT:\r\nLOCATION: http://localhost:8080/description.xml\r\nSERVER: Elixir\r\nST: upnp:rootdevice\r\nUSN: uuid:00000000-0000-0000-0000-000000000000::upnpe:rootdevice\r\n\r\n"

#     :ok = :gen_udp.send(socket, multicast_address, multicast_port, message)
#   end
# end
