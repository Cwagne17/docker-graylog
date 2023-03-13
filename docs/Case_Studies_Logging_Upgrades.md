# Case Studies Logging Upgrades

This file describes different options to upgrade the current graylog stack.

## Case 1: WHY ARE OUR LOGS PUBLICLY ACCESSIBLE?

The previous IT team was lazy and misconfigured the docker compose script to use default credentials.

Apparently anyone who knows the IP address of the graylog server can access it using the default credentials. (`admin:admin`). This is a HUGE security risk, please get on it immediately.

Additionally, our mongodb is publicly accessible as well and can be accessed using the default credentials. I forget what they are, but I think you can figure it out.

## Case 2: Securing Graylog

We need to secure our graylog instance. Identify what can be done from the [graylog documentation](https://go2docs.graylog.org/5-0/downloading_and_installing_graylog/docker_installation.htm?tocpath=Downloading%20and%20Installing%20Graylog%7CInstalling%20Graylog%7C_____2) and implement it.

## Case 3: Configure SMTP Alerts

Alerts can be setup in graylog to send to emails (including ingame emails). Following the graylog documentation to setup SMTP is a good start.

[Graylog SMTP Configuration](https://go2docs.graylog.org/5-0/downloading_and_installing_graylog/docker_installation.htm?tocpath=Downloading%20and%20Installing%20Graylog%7CInstalling%20Graylog%7C_____2#Configuration)

## Case 4: Setting up useful Graylog queries/filters/alerts/etc

Graylog is a powerful tool, but it's not very useful if you don't know how to use it. We need to setup some useful queries, filters, alerts, dashboards, etc. to make graylog useful.
