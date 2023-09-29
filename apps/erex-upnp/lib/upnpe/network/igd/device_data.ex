defmodule Network.Igd.DeviceData do
  alias Network.IGD.DataService

  defstruct current_elem_name: "",
            base_url: "",
            presentationurl: "",
            level: 0,
            cif: %DataService{},
            first: %DataService{},
            second: %DataService{},
            ipv6fc: %DataService{},
            tmp: %DataService{}
end
