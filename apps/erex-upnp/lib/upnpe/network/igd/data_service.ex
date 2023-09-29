defmodule Network.IGD.DataService do
  @moduledoc false
  defstruct control_url: "", event_sub_url: "", scpd_url: "", service_type: ""

  @type t :: %__MODULE__{
          control_url: String.t(),
          event_sub_url: String.t(),
          scpd_url: String.t(),
          service_type: String.t()
        }

  # This structure is used to store information about different UPnP services. Including WANCommonInterfaceConfig service,
  # WANIPConnection service, WANPPPConnection service, and the WANIPv6FirewallControl service. The fields of the structure
  # are used to store the control URLs, event subscription URLs, SCPD URLs, and service type identifiers for these services

  #### Jargon Help

  # UPnP Root Device -A physical device can contain one or more root devices. Root devices contain one ore more devices. A
  # root device is modeled with a UPnPDevice object, there is no separate interface defined for root devices.
  #
  # UPnP Device - The representation of a UPnP device. A UPnP device may contain other UPnP devices and UPnP services.This
  # entity is represented by a UPnPDevice object. A device can be local (implemented in the Framework) or external (implemented
  # by another device on the net).
  #
  # UPnP Service -A UPnP device consists of a number of services. A UPnP service has a number of UPnP state variables that can be
  # queried and modified with actions. This concept is represented by a UPnPService object.
  #
  # UPnP State Variable - A variable associated with a UPnP service, represented by a UPnPStateVariable object.
  #
  # UPnP Local State Variable - Extends the UPnPStateVariable interface when the state variable is implemented locally.
  # provides access to the actual value.
  #
  # UPnP Event Listener Service - A listener to events coming from UPnP devices.
  #
  # UPnP Host - The machine that hosts the code to run a UPnP device or control point.
  #
  # UPnP Control Point - A UPnP device that is intended to control UPnP devices over a network.(a UPnP remote controller).
  #
  # UPnP Exception - An exception that delivers errors that were discovered in the UPnP layer.
  #
  # UDN - Unique Device Name, a name that uniquely identifies the a specific device.
  #
  #  UPnP Device Architecture specification: a set of standards for UPnP devices.
  #  https://openconnectivity.org/upnp-specs/UPnP-arch-DeviceArchitecture-v2.0-20200417.pdf
  #  https://docs.osgi.org/specification/osgi.cmpn/7.0.0/service.upnp.html#:~:text=The%20UPnP%20Device%20Architecture%20specification,managed%20in%20a%20remote%20system.
  #  http://www.upnp.org/specs/arch/UPnP-arch-DeviceArchitecture-v1.0-20080424.pdf
  # https://learn.microsoft.com/en-us/windows/win32/upnp/overview-of-universal-plug-and-play
  # https://www.csie.ntu.edu.tw/~b90087/paper/UPnP-DeviceArchitecture-v1.0-20060720.pdf
  #
  #  WANPPPConnection
  #
  # WANPPPConnection is a UPnP service that allows clients to configure and manage PPP connections on a UPnP  (IGD).
  # The UPnP Device Architecture specification, which is a set of specifications for UPnP devices, defines it.
  # The WANPPPConnection service allows you to execute a variety of actions on a PPP connection,including changing
  # the connection type (e.g., PPPoE, PPTP, L2TP), configuring connection parameters (e.g., username, password,
  # authentication type), and creating or terminating the connection.
  #
  # Clients can access the WANPPPConnection service to manage PPP connections on a UPnP IGD programmatically,
  # for example, to connect to the Internet or a virtual private network (VPN). The control interface of the service
  # is normally accessed over HTTP, using a URL supplied in the IGD's device description.
  #
  # https://upnpy.readthedocs.io/en/latest/Introduction/
  # https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-upigd/84124c98-03df-4c0e-94e5-c83d65bc0b94
  # https://docs.netgate.com/pfsense/en/latest/services/upnp.html#upnp-nat-pmp-and-ipv6

  #
  # WANCommonInterfaceConfig
  #
  # Defined in UPnP Device Architecture specification
  #  The WANCommonInterfaceConfig service allows you to execute a variety of activities on the common interface, such
  #  as retrieving and setting the connection type and status, as well as receiving interface statistics. The common
  #  interface connects the IGD to the wide area network (WAN), and it is used to connect to the Internet or other
  #  WAN resources.
  # Clients can utilise the WANCommonInterfaceConfig service to control the common interface on a UPnP IGD programmatically,
  # such as monitoring connection status or changing connection settings. The control interface of the service is normally
  # accessed over HTTP, using a URL supplied in the IGD's device description.
  #
  # https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-upigd/0dc69eb9-2360-44ac-995d-f54fb49eeb7f
  # https://www.rubydoc.info/gems/UPnP-IGD/UPnP/Control/Service/WANCommonInterfaceConfig
  # https://www.cisco.com/assets/sol/sb/isa500_emulator/help/guide/ad1992792.html
  # https://campus.barracuda.com/product/nextgenfirewallx/doc/11796507/how-to-configure-wan-interfaces/

  #
  # WANIPv6FirewallControl
  #
  # Defined in UPnP Device Architecture specification
  # Provides firewall functions, accessed via http url in IGD device description.
end
