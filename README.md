# FRITZ!Box Exporter for Grafana
Working with Prometheus over a remote server.

![image](https://user-images.githubusercontent.com/13904220/221359439-154582b4-ef50-4609-8def-5d4ce8e98c6e.png)
Link to the dashboard: https://grafana.com/grafana/dashboards/12579-fritz-box-status/


## Requirements
- Raspberry Pi (1/2/3/4/Zero etc.)
- FRITZ!Box
- Server (with docker installed)
- Prometheus
- Grafana


## Installation  

### 1. FRITZ!Box Setup
To make the call from external to your network working, you need one of the following things:
- Direct access from your remote-server to the FRITZ!Box itself
- FRITZ!box connected with MyFRITZ!
- An Dynamic DNS configured in your FRITZ!Box
- An static IPv4 Address

At first, you need to create the Port Forwardings
Host: Your Raspberry Pi
Ports:
- 7001
- 7002


### 2. Raspberry Pi
Run the raspberry_pi/install.sh script on your raspberry-pi with root privileges.
```
sudo sh install.sh
```


### 3. Server
Copy the Contents of server/ on your server top /opt/fritzbox_exporter.
Copy the `.env.sample` to `.env` and fill the required fields.  

| name | example | Description |
|---|---|---|
| GATEWAY_URL | "http://XYXYX.myfritz.net:7002" | The URL where your FRITZ!Box is reachable from your server |
| USERNAME | "fritzbox_exporter" | The username of your FRITZ!Box user. I recommend to create a new one. |
| PASSWORD | "XYXYXYXY" | The password of the user you provided. |
| LISTEN_ADDRESS | 0.0.0.0:9042 | The IP and port where the exporter should be listen on (It must be reachable for Prometheus) |

If you're having an FRITZ!Box Cable (not DSL), then you need to replate the data/metrics-lua.json with the data/metrics-lua_cable.json
Then start your docker container with `docker compose up -d`.

Now you need to update your prometheus configuration, insert the following code block to the `scrape_configs` section at the end.
```yaml
  - job_name: fritzbox_exporter
     scrape_interval: 60s
    static_configs:
    - targets: ['<IP of the Exporter/Host>:9042']
```

After that, you need to restart the prometheus server/container/service, to make the new configuration reloading.

After all this, you can import the Grafana dashboard from the following URL: https://grafana.com/grafana/dashboards/12579-fritz-box-status/

And now you should be done.

---

## Troubleshoot
**My docker container is continuously restarting**  
Check the logs of the container, you can do this with `docker logs fritzbox_exporter`.

For errors like `level=warning msg="can not collect metrics: GetInfo: SAOPFault: UPnPError 401 (Invalid Action)"`
You need to check your metrics.json and metrics-lua.json, there could be some metriocs which your FRITZ!Box doesnt support.
If you want to create a ticket, please referr to https://github.com/sberk42/fritzbox_exporter/issues


