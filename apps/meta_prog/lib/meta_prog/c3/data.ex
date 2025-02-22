defmodule MetaProg.Lib.MetaProg.C3.Data do
  def test() do
    [
      {:comment,
       " saved from url=(0062)https://www.iana.org/assignments/media-types/media-types.xhtml "},
      {"html",
       [
         {"xmlns", "http://www.w3.org/1999/xhtml"},
         {"xmlns:iana", "http://www.iana.org/assignments"}
       ],
       [
         {"head", [],
          [
            {"meta",
             [
               {"http-equiv", "Content-Type"},
               {"content", "text/html; charset=UTF-8"}
             ], []},
            {"link",
             [
               {"rel", "stylesheet"},
               {"href", "./media_types_files/iana-registry.css"},
               {"type", "text/css"}
             ], []},
            {"script",
             [
               {"type", "text/javascript"},
               {"src", "./media_types_files/jquery.js"}
             ], [""]},
            {"script", [{"type", "text/javascript"}, {"src", "./media_types_files/sort.js"}],
             [""]},
            {"title", [], ["Media Types"]}
          ]},
         {"body", [],
          [
            {"header", [],
             [
               {"div", [],
                [
                  {"a", [{"href", "https://www.iana.org/"}],
                   [
                     {"img",
                      [
                        {"src", "./media_types_files/iana-logo-header.svg"},
                        {"alt", "Internet Assigned Numbers Authority"}
                      ], []}
                   ]}
                ]}
             ]},
            {"article", [],
             [
               {"h1", [], ["Media Types"]},
               {"dl", [],
                [
                  {"dt", [], ["Last Updated"]},
                  {"dd", [], ["2025-02-18"]},
                  {"dt", [], ["Registration Procedure(s)"]},
                  {"dd", [],
                   [
                     {"pre", [],
                      [
                        "Expert Review for Vendor and Personal Trees. For Standards Tree, see [",
                        {"a", [{"href", "https://www.iana.org/go/rfc6838"}], ["RFC6838"]},
                        "], Section 3.1."
                      ]}
                   ]},
                  {"dt", [], ["Expert(s)"]},
                  {"dd", [],
                   [
                     {"pre", [], ["Alexey Melnikov, Darrel Miller, Murray Kucherawy (backup)"]}
                   ]},
                  {"dt", [], ["Reference"]},
                  {"dd", [],
                   [
                     "[",
                     {"a", [{"href", "https://www.iana.org/go/rfc6838"}], ["RFC6838"]},
                     "][",
                     {"a", [{"href", "https://www.iana.org/go/rfc4855"}], ["RFC4855"]},
                     "]"
                   ]},
                  {"dt", [], ["Note"]},
                  {"dd", [],
                   [
                     {"pre", [],
                      [
                        "[",
                        {"a", [{"href", "https://www.iana.org/go/rfc2046"}], ["RFC2046"]},
                        "] specifies that Media Types (formerly known as MIME types) and Media\nSubtypes will be assigned and listed by the IANA.\n\nProcedures for registering Media Types can be found in [",
                        {"a", [{"href", "https://www.iana.org/go/rfc6838"}], ["RFC6838"]},
                        "], [",
                        {"a", [{"href", "https://www.iana.org/go/rfc4289"}], ["RFC4289"]},
                        "], \nand [",
                        {"a", [{"..."}], ["..."]},
                        "]. Additional procedures for registering media types for transfer \nvia Real-time Transport Protocol (RTP) can be found in [",
                        {"a", "..."},
                        "].\n\nPer Section 3.1 of [",
                        "..."
                      ]}
                   ]},
                  {"dt", [], ["Note"]},
                  {"dd", [],
                   [
                     {"pre", [],
                      [
                        "Some early registrations have no registration template. The absence of a \ntemplate does not imply a different or reduced registration status.\n"
                      ]}
                   ]},
                  {"dt", [], ["Note"]},
                  {"dd", [],
                   [
                     {"pre", [],
                      [
                        "Per Section 12.5.1 of [",
                        {"a", [{"href", "https://www.iana.org/go/rfc9110"}], ["RFC9110"]},
                        "], use of the \"q\" parameter name to control \ncontent negotiation would interfere with any media type parameter having the \nsame name. Hence, the media type registry disallows parameters named \"q\".\n\n"
                      ]}
                   ]},
                  {"dt", [], ["Available Formats"]},
                  {"dd", [],
                   [
                     {"a",
                      [
                        {"class", "altformat"},
                        {"href", "https://www.iana.org/assignments/media-types/media-types.xml"}
                      ], [{"img", [{"src", "..."}], []}, {"br", [], []}, "XML"]},
                     {"a",
                      [
                        {"class", "altformat"},
                        {"href", "https://www.iana.org/assignments/media-types/media-types.xhtml"}
                      ], [{"img", [{"..."}], []}, {"br", [], "..."}, "HTML"]},
                     {"a",
                      [
                        {"class", "altformat"},
                        {"href", "https://www.iana.org/assignments/media-types/media-types.txt"}
                      ], [{"img", ["..."], "..."}, {"br", "..."}, "Plain text"]}
                   ]}
                ]},
               {"p", [], [{"b", [], ["Registries included below"]}]},
               {"ul", [],
                [
                  {"li", [],
                   [
                     {"a",
                      [
                        {"href",
                         "https://www.iana.org/assignments/media-types/media-types.xhtml#application"}
                      ], ["application"]}
                   ]},
                  {"li", [],
                   [
                     {"a",
                      [
                        {"href",
                         "https://www.iana.org/assignments/media-types/media-types.xhtml#audio"}
                      ], ["audio"]}
                   ]},
                  {"li", [],
                   [
                     {"a",
                      [
                        {"href",
                         "https://www.iana.org/assignments/media-types/media-types.xhtml#example"}
                      ], ["example"]}
                   ]},
                  {"li", [],
                   [
                     {"a",
                      [
                        {"href",
                         "https://www.iana.org/assignments/media-types/media-types.xhtml#font"}
                      ], ["font"]}
                   ]},
                  {"li", [],
                   [
                     {"a",
                      [
                        {"href",
                         "https://www.iana.org/assignments/media-types/media-types.xhtml#haptics"}
                      ], ["haptics"]}
                   ]},
                  {"li", [],
                   [
                     {"a",
                      [
                        {"href",
                         "https://www.iana.org/assignments/media-types/media-types.xhtml#image"}
                      ], ["image"]}
                   ]},
                  {"li", [],
                   [
                     {"a",
                      [
                        {"href",
                         "https://www.iana.org/assignments/media-types/media-types.xhtml#message"}
                      ], ["message"]}
                   ]},
                  {"li", [],
                   [
                     {"a",
                      [
                        {"href",
                         "https://www.iana.org/assignments/media-types/media-types.xhtml#model"}
                      ], ["model"]}
                   ]},
                  {"li", [],
                   [
                     {"a",
                      [
                        {"href",
                         "https://www.iana.org/assignments/media-types/media-types.xhtml#multipart"}
                      ], ["multipart"]}
                   ]},
                  {"li", [],
                   [
                     {"a",
                      [
                        {"href",
                         "https://www.iana.org/assignments/media-types/media-types.xhtml#text"}
                      ], ["text"]}
                   ]},
                  {"li", [],
                   [
                     {"a",
                      [
                        {"href",
                         "https://www.iana.org/assignments/media-types/media-types.xhtml#video"}
                      ], ["video"]}
                   ]}
                ]},
               {"h2", [],
                [
                  {"a", [{"name", "application"}, {"id", "application"}], []},
                  "application"
                ]},
               {"dl", [],
                [
                  {"dt", [], ["Available Formats"]},
                  {"dd", [],
                   [
                     {"a",
                      [
                        {"class", "altformat"},
                        {"href", "https://www.iana.org/assignments/media-types/application.csv"}
                      ],
                      [
                        {"img", [{"src", "./media_types_files/text-csv.png"}], []},
                        {"br", [], []},
                        "CSV"
                      ]}
                   ]}
                ]},
               {"table", [{"id", "table-application"}, {"class", "sortable"}],
                [
                  {"thead", [],
                   [
                     {"tr", [{"style", "cursor: pointer;"}],
                      [
                        {"th", [],
                         [
                           "Name ",
                           {"img",
                            [
                              {"style", "vertical-align:middle"},
                              {"src", "./media_types_files/sort_none.gif"}
                            ], []}
                         ]},
                        {"th", [],
                         [
                           "Template ",
                           {"img",
                            [
                              {"style", "vertical-align:middle"},
                              {"src", "./media_types_files/sort_none.gif"}
                            ], []}
                         ]},
                        {"th", [],
                         [
                           "Reference ",
                           {"img",
                            [
                              {"style", "vertical-align:middle"},
                              {"src", "./media_types_files/sort_none.gif"}
                            ], []}
                         ]}
                      ]}
                   ]},
                  {"tbody", [],
                   [
                     {"tr", [],
                      [
                        {"td", [], ["1d-interleaved-parityfec"]},
                        {"td", [],
                         [
                           {"a",
                            [
                              {"href",
                               "https://www.iana.org/assignments/media-types/application/1d-interleaved-parityfec"}
                            ], ["application/1d-interleaved-parityfec"]}
                         ]},
                        {"td", [],
                         [
                           "[",
                           {"a", [{"href", "https://www.iana.org/go/rfc6015"}], ["RFC6015"]},
                           "]"
                         ]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["3gpdash-qoe-report+xml"]},
                        {"td", [],
                         [
                           {"a",
                            [
                              {"href",
                               "https://www.iana.org/assignments/media-types/application/3gpdash-qoe-report+xml"}
                            ], ["application/3gpdash-qoe-report+xml"]}
                         ]},
                        {"td", [],
                         [
                           "[",
                           {"a",
                            [
                              {"href",
                               "https://www.iana.org/assignments/media-types/media-types.xhtml#_3GPP"}
                            ], ["_3GPP"]},
                           "][",
                           {"a", [{"..."}], ["..."]},
                           "]"
                         ]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["3gppHal+json"]},
                        {"td", [],
                         [
                           {"a",
                            [
                              {"href",
                               "https://www.iana.org/assignments/media-types/application/3gppHal+json"}
                            ], ["application/3gppHal+json"]}
                         ]},
                        {"td", [],
                         [
                           "[",
                           {"a", [{"href", "..."}], ["_3GPP"]},
                           "][",
                           {"a", ["..."], "..."},
                           "]"
                         ]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["3gppHalForms+json"]},
                        {"td", [],
                         [
                           {"a",
                            [
                              {"href",
                               "https://www.iana.org/assignments/media-types/application/3gppHalForms+json"}
                            ], ["application/3gppHalForms+json"]}
                         ]},
                        {"td", [], ["[", {"a", [{"..."}], ["..."]}, "][", {"a", "..."}, "]"]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["3gpp-ims+xml"]},
                        {"td", [], [{"a", [{"href", "..."}], ["application/3gpp-ims+xml"]}]},
                        {"td", [], ["[", {"a", ["..."], "..."}, "][", {"..."}, "..."]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["A2L"]},
                        {"td", [], [{"a", [{"..."}], ["..."]}]},
                        {"td", [], ["[", {"a", "..."}, "][", "..."]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["ace-groupcomm+cbor"]},
                        {"td", [], [{"a", ["..."], "..."}]},
                        {"td", [], ["[", {"..."}, "..."]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["ace-trl+cbor"]},
                        {"td", [], [{"a", "..."}]},
                        {"td", [], ["[", "..."]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["ace+cbor"]},
                        {"td", [], [{"..."}]},
                        {"td", [], ["..."]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["ace+json"]},
                        {"td", [], ["..."]},
                        {"td", [], "..."}
                      ]},
                     {"tr", [], [{"td", [], ["..."]}, {"td", [], "..."}, {"td", "..."}]},
                     {"tr", [], [{"td", [], "..."}, {"td", "..."}, {"..."}]},
                     {"tr", [], [{"td", "..."}, {"..."}, "..."]},
                     {"tr", [], [{"..."}, "..."]},
                     {"tr", [], ["..."]},
                     {"tr", [], "..."},
                     {"tr", "..."},
                     {"..."},
                     "..."
                   ]}
                ]},
               {"h2", [], [{"a", [{"name", "audio"}, {"id", "audio"}], []}, "audio"]},
               {"dl", [],
                [
                  {"dt", [], ["Available Formats"]},
                  {"dd", [],
                   [
                     {"a",
                      [
                        {"class", "altformat"},
                        {"href", "https://www.iana.org/assignments/media-types/audio.csv"}
                      ],
                      [
                        {"img", [{"src", "./media_types_files/text-csv.png"}], []},
                        {"br", [], []},
                        "CSV"
                      ]}
                   ]}
                ]},
               {"table", [{"id", "table-audio"}, {"class", "sortable"}],
                [
                  {"thead", [],
                   [
                     {"tr", [{"style", "cursor: pointer;"}],
                      [
                        {"th", [],
                         [
                           "Name ",
                           {"img",
                            [
                              {"style", "vertical-align:middle"},
                              {"src", "./media_types_files/sort_none.gif"}
                            ], []}
                         ]},
                        {"th", [],
                         [
                           "Template ",
                           {"img", [{"style", "vertical-align:middle"}, {"src", "..."}], []}
                         ]},
                        {"th", [], ["Reference ", {"img", [{"style", "..."}, {"..."}], []}]}
                      ]}
                   ]},
                  {"tbody", [],
                   [
                     {"tr", [],
                      [
                        {"td", [], ["1d-interleaved-parityfec"]},
                        {"td", [],
                         [
                           {"a",
                            [
                              {"href",
                               "https://www.iana.org/assignments/media-types/audio/1d-interleaved-parityfec"}
                            ], ["audio/1d-interleaved-parityfec"]}
                         ]},
                        {"td", [], ["[", {"a", [{"..."}], ["..."]}, "]"]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["32kadpcm"]},
                        {"td", [], [{"a", [{"href", "..."}], ["audio/32kadpcm"]}]},
                        {"td", [], ["[", {"a", ["..."], "..."}, "][", {"..."}, "..."]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["3gpp"]},
                        {"td", [], [{"a", [{"..."}], ["..."]}]},
                        {"td", [], ["[", {"a", "..."}, "][", "..."]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["3gpp2"]},
                        {"td", [], [{"a", ["..."], "..."}]},
                        {"td", [], ["[", {"..."}, "..."]}
                      ]},
                     {"tr", [],
                      [
                        {"td", [], ["aac"]},
                        {"td", [], [{"a", "..."}]},
                        {"td", [], ["[", "..."]}
                      ]},
                     {"tr", [],
                      [{"td", [], ["ac3"]}, {"td", [], [{"..."}]}, {"td", [], ["..."]}]},
                     {"tr", [], [{"td", [], ["AMR"]}, {"td", [], ["..."]}, {"td", [], "..."}]},
                     {"tr", [], [{"td", [], ["..."]}, {"td", [], "..."}, {"td", "..."}]},
                     {"tr", [], [{"td", [], "..."}, {"td", "..."}, {"..."}]},
                     {"tr", [], [{"td", "..."}, {"..."}, "..."]},
                     {"tr", [], [{"..."}, "..."]},
                     {"tr", [], ["..."]},
                     {"tr", [], "..."},
                     {"tr", "..."},
                     {"..."},
                     "..."
                   ]}
                ]},
               {"h2", [], [{"a", [{"name", "example"}, {"id", "example"}], []}, "example"]},
               {"dl", [],
                [
                  {"dt", [], ["Note"]},
                  {"dd", [],
                   [
                     {"pre", [],
                      [
                        "The 'example' media type is used for examples. Any subtype following the media\ntype syntax may be used in those examples. No subtype can be registered with\nIANA. For more information see[",
                        {"a", [{"href", "https://www.iana.org/go/rfc4735"}], ["RFC4735"]},
                        "].\n\nNote: The occurrence of an 'example' media type as a media type outside\nof examples, e.g. in a Content-Type header, is an error and should be\nreported to the implementor.[",
                        {"a", [{"href", "https://www.iana.org/go/rfc2045"}], ["RFC2045"]},
                        "][",
                        {"a", [{"..."}], ["..."]},
                        "] \nspecifies that Content Types, Content Subtypes, Character Sets, Access \nTypes, and conversion values for MIME mail will be assigned and listed \nby the IANA."
                      ]}
                   ]},
                  {"dt", [], ["Note"]},
                  {"dd", [],
                   [
                     {"pre", [],
                      [
                        "Other MIME Media Type Parameters: [",
                        {"a",
                         [
                           {"href", "https://www.iana.org/assignments/media-types-parameters"}
                         ], ["IANA registry ", {"..."}]},
                        "]"
                      ]}
                   ]}
                ]},
               {"table", [],
                [
                  {"tbody", [],
                   [
                     {"tr", [],
                      [
                        {"td", [{"colspan", "0"}],
                         [{"i", [], ["No registrations at this time."]}]}
                      ]}
                   ]}
                ]},
               {"h2", [], [{"a", [{"name", "font"}, {"id", "font"}], []}, "font"]},
               {"dl", [],
                [
                  {"dt", [], ["Available Formats"]},
                  {"dd", [],
                   [
                     {"a",
                      [
                        {"class", "altformat"},
                        {"href", "https://www.iana.org/assignments/media-types/font.csv"}
                      ],
                      [
                        {"img", [{"src", "./media_types_files/text-csv.png"}], []},
                        {"br", [], []},
                        "CSV"
                      ]}
                   ]}
                ]},
               {"table", [{"id", "table-font"}, {"class", "sortable"}],
                [
                  {"thead", [],
                   [
                     {"tr", [{"style", "cursor: pointer;"}],
                      [
                        {"th", [], ["Name ", {"..."}]},
                        {"th", [], ["Template ", "..."]},
                        {"th", [], ["..."]}
                      ]}
                   ]},
                  {"tbody", [],
                   [
                     {"tr", [],
                      [
                        {"td", [], ["collection"]},
                        {"td", [], ["..."]},
                        {"td", [], "..."}
                      ]},
                     {"tr", [], [{"td", [], ["..."]}, {"td", [], "..."}, {"td", "..."}]},
                     {"tr", [], [{"td", [], "..."}, {"td", "..."}, {"..."}]},
                     {"tr", [], [{"td", "..."}, {"..."}, "..."]},
                     {"tr", [], [{"..."}, "..."]},
                     {"tr", [], ["..."]}
                   ]}
                ]},
               {"h2", [], [{"a", [{"name", "haptics"}, {"id", "haptics"}], []}, "haptics"]},
               {"dl", [],
                [
                  {"dt", [], ["Available Formats"]},
                  {"dd", [],
                   [
                     {"a",
                      [
                        {"class", "altformat"},
                        {"href", "https://www.iana.org/assignments/media-types/haptics.csv"}
                      ], [{"img", ["..."], "..."}, {"br", "..."}, "CSV"]}
                   ]}
                ]},
               {"table", [{"id", "table-haptics"}, {"class", "sortable"}],
                [
                  {"thead", [],
                   [
                     {"tr", [{"style", "cursor: pointer;"}],
                      [{"th", [], "..."}, {"th", "..."}, {"..."}]}
                   ]},
                  {"tbody", [],
                   [
                     {"tr", [], [{"td", "..."}, {"..."}, "..."]},
                     {"tr", [], [{"..."}, "..."]},
                     {"tr", [], ["..."]}
                   ]}
                ]},
               {"h2", [], [{"a", [{"name", "image"}, {"id", "image"}], []}, "image"]},
               {"dl", [],
                [
                  {"dt", [], ["Available Formats"]},
                  {"dd", [], [{"a", [{"..."}, "..."], ["..."]}]}
                ]},
               {"table", [{"id", "table-image"}, {"class", "sortable"}],
                [
                  {"thead", [], [{"tr", [{"..."}], ["..."]}]},
                  {"tbody", [], [{"tr", [], "..."}, {"tr", "..."}, {"..."}, "..."]}
                ]},
               {"h2", [], [{"a", [{"name", "message"}, {"id", "message"}], []}, "message"]},
               {"dl", [], [{"dt", [], ["Available Formats"]}, {"dd", [], [{"..."}]}]},
               {"table", [{"id", "table-message"}, {"class", "sortable"}],
                [{"thead", [], [{"..."}]}, {"tbody", [], ["..."]}]},
               {"h2", [], [{"a", [{"..."}, "..."], []}, "model"]},
               {"dl", [], [{"dt", [], "..."}, {"dd", "..."}]},
               {"table", [{"id", "table-model"}, {"class", "..."}], [{"thead", "..."}, {"..."}]},
               {"h2", [], [{"..."}, "..."]},
               {"dl", [], ["..."]},
               {"table", ["..."], "..."},
               {"h2", "..."},
               {"..."},
               "..."
             ]},
            {"footer", [],
             [
               {"div", [],
                [
                  {"a", [{"href", "https://www.iana.org/help/licensing-terms"}],
                   ["Licensing Terms"]}
                ]}
             ]}
          ]}
       ]}
    ]
  end
end
