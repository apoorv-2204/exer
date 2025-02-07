# defmodule SSDP.Client do
#   use GenServer
#   require Logger
#   # import SweetXml
#   alias SSDP.Parser

#   defmodule SSDP.Client.State do
#     defstruct port: nil, udp: nil, devices: []
#   end

#   alias SSDP.Client.State
#   @port 1900
#   @multicast_ip {239, 255, 255, 250}
#   # @multicast_ip_string "239.255.255.250"
#   # @multicast_port "1900"

#   def discover_messages do
#     [
#       "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\nMX: 3\r\nST: upnp:rootdevice\r\n\r\n",
#       "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\nMX: 3\r\nST: ssdp:all\r\n\r\n",
#       "TYPE: WM-DISCOVER\r\nVERSION: 1.0\r\n\r\nservices:com.marvell.wm.system*\r\n\r\n"
#     ]
#   end

#   def start_link do
#     GenServer.start_link(__MODULE__, @port, name: __MODULE__)
#   end

#   def discover do
#     GenServer.call(__MODULE__, :discover)
#   end

#   def devices do
#     GenServer.call(__MODULE__, :devices)
#   end

#   def add_handler(handler) do
#     GenServer.call(__MODULE__, {:handler, handler})
#   end

#   def start do
#     GenServer.call(__MODULE__, :start)
#   end

#   def init(port) do
#     {:ok, %State{:port => port}}
#   end

#   def handle_call(:start, _from, state) do
#     {:reply, :ok,
#      case state.udp do
#        nil ->
#          udp_options = [
#            :binary,
#            add_membership: {@multicast_ip, {0, 0, 0, 0}},
#            multicast_if: {0, 0, 0, 0},
#            multicast_loop: false,
#            multicast_ttl: 2,
#            reuseaddr: true
#          ]

#          {:ok, udp} = :gen_udp.open(state.port, udp_options)
#          Process.send_after(self(), :discover, 0)
#          %State{state | udp: udp}

#        _exists ->
#          state
#      end}
#   end

#   def handle_call(:register, {pid, _ref}, state) do
#     Logger.info("Registering: #{inspect(pid)}")
#     Registry.register(SSDP.Registry, SSDP, pid)
#     {:reply, :ok, state}
#   end

#   def handle_call(:devices, _from, state) do
#     {:reply, state.devices, state}
#   end

#   def handle_info(:discover, state) do
#     Enum.each(discover_messages(), fn m ->
#       Process.send_after(self(), {:ping, m}, (:rand.uniform() * 1000) |> round)
#     end)

#     Process.send_after(self(), :discover, 61000)
#     {:noreply, state}
#   end

#   def handle_info({:ping, discover}, state) do
#     Logger.debug("Sending Discovery: #{discover}")
#     :gen_udp.send(state.udp, @multicast_ip, @port, discover)
#     {:noreply, state}
#   end

#   def handle_info({:udp, _s, ip, _port, <<"M-SEARCH * HTTP/1.1", _rest::binary>>}, state) do
#     {:noreply, state}
#   end

#   def handle_info({:udp, _s, ip, _port, <<"HTTP/1.1 200 OK", _rest::binary>>}, state) do
#     parse_xml(rest, ip)
#     {:noreply, state}
#   end

#   def handle_info({:udp, _s, ip, _port, <<"NOTIFY * HTTP/1.1", _rest::binary>>}, state) do
#     parse_xml(rest, ip)
#     {:noreply, state}
#   end

#   def handle_info({:udp, _s, ip, _port, <<"TYPE: WM-NOTIFY", rest::binary>>}, state) do
#     parse_json(rest, ip)
#     {:noreply, state}
#   end

#   def handle_info({:udp, _s, _ip, _port, _rest}, state), do: {:noreply, state}

#   def handle_info({:result, result}, state) do
#     {:noreply,
#      case result do
#        {:ok, obj} ->
#          obj |> update_devices(state)

#        {:error, reason} ->
#          Logger.debug("SSDP Client Error Parsing Meta: #{inspect(reason)}")
#          state
#      end}
#   end

#   def handle_info({:udp_passive, _}, state), do: {:noreply, state}

#   def update_devices(device, state) do
#     # SSDP.dispatch(SSDP, {:device, device})

#     case state.devices |> Enum.any?(fn dev -> dev.device.udn == device.device.udn end) do
#       false ->
#         Logger.debug(
#           "New Device #{device.device.friendly_name}: #{device.device.udn} #{inspect(device)}"
#         )

#         %State{state | :devices => [device | state.devices]}

#       true ->
#         Logger.debug("Existing Device: #{device.device.friendly_name}: #{device.device.udn}")
#         state
#     end
#   end

#   def parse_keys(rest) do
#     raw_params = String.split(rest, ["\r\n", "\n"])

#     mapped_params =
#       Enum.map(raw_params, fn x ->
#         case String.split(x, ":", parts: 2) do
#           [k, v] -> {String.to_atom(String.downcase(k)), String.trim(v)}
#           _ -> nil
#         end
#       end)

#     Enum.reject(mapped_params, &(&1 == nil))
#   end

#   def parse_json(rest, ip) do
#     s = self()

#     SSDP.TaskSupervisor
#     |> Task.Supervisor.start_child(fn ->
#       resp = parse_keys(rest)
#       ip = :inet_parse.ntoa(ip)
#       url = Keyword.fetch(resp, :location)

#       res =
#         case HTTPoison.get(url, [], hackney: [:insecure]) do
#           {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
#             obj = Jason.decode!(body)

#             obj = %{
#               :version => %{
#                 :major => obj["api_version"],
#                 :minor => 0
#               },
#               :uri => URI.parse(url),
#               :url => "http://#{ip}",
#               :device => %{
#                 :device_type => Keyword.fetch(resp, :service),
#                 :friendly_name => "Radio Thermostat",
#                 :manufacturer => "Radio Thermostat",
#                 :serial_number => obj["uuid"],
#                 :icon_list => [],
#                 :service_list => [],
#                 :udn => obj["uuid"]
#               }
#             }

#             {:ok, obj}

#           {:ok, %HTTPoison.Response{status_code: 404}} ->
#             {:error, "Not Found"}

#           {:ok, %HTTPoison.Response{body: body}} ->
#             {:error, body}

#           {:error, %HTTPoison.Error{reason: reason}} ->
#             {:error, reason}
#         end

#       s |> send({:result, res})
#     end)
#   end

#   def parse_xml(rest, _ip) do
#     s = self()

#     SSDP.TaskSupervisor
#     |> Task.Supervisor.start_child(fn ->
#       resp = parse_keys(rest)
#       url = Keyword.fetch(resp, :location)

#       res =
#         case HTTPoison.get(Keyword.fetch(resp, :location), [], hackney: [:insecure]) do
#           {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
#             obj = body |> Parser.parse()
#             obj = %{obj | :uri => URI.parse(url)}
#             {:ok, obj}

#           {:ok, %HTTPoison.Response{status_code: 404}} ->
#             {:ok, resp |> parse_empty_response}

#           {:ok, %HTTPoison.Response{body: _body}} ->
#             {:ok, resp |> parse_empty_response}

#           {:error, %HTTPoison.Error{reason: _reason}} ->
#             {:ok, resp |> parse_empty_response}
#         end

#       s |> send({:result, res})
#     end)
#   end

#   def parse_empty_response(keys) do
#     url = Keyword.fetch(keys, :location)
#     serial = Keyword.fetch(keys, :usn)
#     type = Keyword.fetch(keys, :st)

#     %{
#       :version => %{
#         :major => 1,
#         :minor => 0
#       },
#       :uri => URI.parse(url),
#       :url => url,
#       :device => %{
#         :device_type => type,
#         :friendly_name => "Unknown",
#         :manufacturer => "Unknown",
#         :serial_number => serial,
#         :icon_list => [],
#         :service_list => [],
#         :udn => serial
#       }
#     }
#   end
# end
