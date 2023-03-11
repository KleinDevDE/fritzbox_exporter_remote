---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---

### Description
**Describe the bug**
A clear and concise description of what the bug is.

### Logs
**Logs of the exporter, if this is the issue**
To get the logs of the container, run `docker log fritzbox_exporter`.
If the issue is Reverse-Proxy related, you also need to attach the data/nginx.log.
However, you should remove sensitive data (IP address) from the logs first.

**Logs of the reverse-proxy, if this is the problem**
Nginx: `var/log/nginx/access.log`
Apache: `/var/log/apache2/access. log`
However, you should remove sensitive data (IP address) from the logs first.

### Behavior
**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.


### Version informations
**Raspberry-Pi (or other hardware you installed the local reverse proxy)**
- Which OS?
- Which OS version?
- Which nginx/apache2 version?

**Server (with Prometheus and/or Fritzbox exporter installed)**
- Which OS?
- Which OS version?
- Which docker version?

**Grafana**
- Which Version?
- Did you made custom changes to the panel?
If yes, could it be possible that this is the reason of the issue?

### Additional
**Additional context**
Add any other context about the problem here.
