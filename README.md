# Hadoop v2 script

Hadoop v2 script in advanced.

### Hadoop v2 script list

- start-yarn.sh
- stop-yarn.sh

### Feature:

- Able to  start or stop one or more specified ResourceManagers on any one of cluster nodes
- Support both of ResourceManager single point (**SP**) and high availability (**HA**)
  - **SP**: start or stop RM by `yarn.resourcemanager.hostname`
  - **HA**: start or stop RMs by all `yarn.resourcemanager.hostname.rm-id`
