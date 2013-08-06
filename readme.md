MonitRB
=======

MonitRB tries to fill in the gap between your Rails app configuration and your server configuration by providing a
wrapper around Monit, storing your configuration files within your project.

Usage
=====

Start with a simple configuration for your master node:

```yaml
require 'monitrb'

MonitRB.create do |config|
  config.process = 'resque'
  config.pidfile = '/path/to/pidfile'
end
```

$ monitrb generate config --path=path/to/monitrb/file
$ monitrb list
