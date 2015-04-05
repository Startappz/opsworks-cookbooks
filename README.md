OpsWorks Cookbooks

## Wordpress

The wordpress cookbook allows you to deploy wordpress with a single click. All the wp-config configuration will be auto generated using the custom stack json. 

For example, To deploy a website called example.com, you will add the fillowing json to the stack setting:

```json
{
    "deploy": {
        "application_name": {
            "hostname": "example.com",
                "database":{
                    "database": "example_production",
                    "username": "db_username",
                    "password": "db_password",
                    "host": "db_host"
                },
                "domains": ["example.com"],
                "symlink_before_migrate": {
                    "config/wp-config.php": "wp-config.php"
                }
        }
    }
}
```

OpsWorks and Chef will do the rest.
