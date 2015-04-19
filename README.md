Bakebox cookbook
=============================

Making deploying ruby Rack apps just a little bit easier

Requirements
------------

## Operating systems
* ubuntu
* oel
* rhel

Attributes
----------

## Attributes you must set
```
default[:bakebox][:app][:name] = 'dummyapp'
default[:bakebox][:app][:domain] = 'dummyapp'
```
## Optional but worthwhile to override

### SSL (if you override the following parameters Nginx will be configured to use SSL
```
default[:bakebox][:app][:ssl][:cert] = '<INSERT CERT HERE>'
default[:bakebox][:app][:ssl][:key] = '<INSERT PRIVATE KEY HERE>'
```
### APP Specific config files

```
database_yml = {name: 'database.yml', content: '<INSERT CONTENT HERE>'
default[:bakebox][:app][:config_files] = [database_yml]
```
All configs go in /path/to/app/shared/config for Capistrano to symlink

### APP Settings

```
default[:bakebox][:app][:ruby] = '2.2.2'
default[:bakebox][:app][:gems] = ['bundler']
default[:bakebox][:app][:upgrade] = false
default[:bakebox][:app][:deployers] = {
  deployer_1: '<SSH PUBLIC KEY GOES HERE>',
  deployer_2: '<SSH PUBLIC KEY GOES HERE>'
}
```

Usage
-----
#### bakebox::default

Just include `bakebox` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[bakebox]"
  ]
}
```

and don't forget to overwrite the required attributes

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github
