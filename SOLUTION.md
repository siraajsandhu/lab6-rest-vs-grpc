
| Method           | Local (ms) | Same-Zone (ms) | Different Region (ms) |
|------------------|-------|-----------|------------------|
| REST add         | 2.599 |  3.927 |    320.789 |
| gRPC add         | 0.804 |  1.283 |    192.528 |
| REST rawimg      | 5.337 | 13.254 |   1320.935 |
| gRPC rawimg      |12.817 | 14.420 |    288.448 |
| REST dotproduct  | 3.205 |  5.516 |    324.206 |
| gRPC dotproduct  | 0.877 |  1.288 |    171.481 |
| REST jsonimg     |37.757 | 47.225 |   1509.292 |
| gRPC jsonimg     |29.623 | 33.150 |    390.485 |
| PING             | 0.050 |  0.378 |    140.953 |

gRPC was faster than REST in nearly every case, and the gap grew with network latency. For small messages (add, dotproduct), gRPC was about 2-3x faster locally and in the same zone (e.g., 0.80 vs 2.60 ms for add). Cross-region, REST took about 320 ms, roughly 2.3x the 141 ms ping RTT, while gRPC took 170-190 ms, roughly 1.2-1.4x the RTT. This is pretty much what we expect. REST opens a new TCP connection per request, so it pays one RTT for the handshake and another RTT for the request and response, while gRPC reuses a single connection and pays only the one RTT for the request itself. Over link with longer latency that extra round trip should constitute most of the overhead, so network latency accounts for a larger proportion of the differences. The effect is larger for big payloads since each new REST connection will reset TCP's slow start mechanism, which ramps up the number of packets sent adaptively. The one exception is locally, where gRPC is sometimes slower than REST. With no actual network latency to hide it, gRPC’s serialization overhead becomes much more visible. So its advantage likely comes from connection resuse.