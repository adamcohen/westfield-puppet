define westfield::apache::configs($ssl = false, $redirect_non_ssl = true, $passenger_ruby = undef) {
  $server_name = regsubst($title, '_', '-', 'G')

  if $hostname == 'vagrant' {
    $docroot = "/home/vagrant/vmshare/${title}/public"
    $docroot_owner = 'vagrant'
    $vhost_name = "${server_name}.development.dbg.westfield.com"
    $server_alias_name = "${server_name}.production.dbg.westfield.com"
  }
  else {
    $docroot = "/var/www/${title}/current/public"
    $docroot_owner = 'root'
    $vhost_name = "${server_name}.production.dbg.westfield.com"
    $server_alias_name = "${server_name}.development.dbg.westfield.com"
  }

  # create an ssl enabled vhost
  if $ssl == true
  {
    # redirect all non ssl traffic to https://
    if $redirect_non_ssl == true
    {
      # redirect http to https
      apache::vhost {"${vhost_name}-redirect-ssl":
        docroot => $docroot,
        docroot_owner => $docroot_owner,
        docroot_group => $docroot_owner,

        servername => "${vhost_name}",
        port       => '8080',

        rewrite_rule => '^/?(.*) https://%{SERVER_NAME}/$1 [R,L]',
        rewrite_cond => '%{REQUEST_URI} !^\/status\.json',
      }

      apache::vhost { "${vhost_name}":
        port       => '443',

        docroot_owner => $docroot_owner,
        docroot_group => $docroot_owner,

        docroot => $docroot,

        ssl => true,
        
        serveraliases => [
                          "${server_name}.uat.dbg.westfield.com",
                          "${server_name}.systest.dbg.westfield.com",
                          "${server_name}.test.dbg.westfield.com",
                          "${server_alias_name}",
                          "${server_name}.*.xip.io",
                          ],


        passenger_ruby => $passenger_ruby,

        passenger_high_performance => true,

        directories => [ { path => $docroot, passenger_enabled => 'on', allow_override  => 'all' } ],

        add_listen => false,
      }
    }
    else
    {
      apache::vhost { "${vhost_name}":
        port       => '8080',

        docroot_owner => $docroot_owner,
        docroot_group => $docroot_owner,

        docroot => $docroot,

        serveraliases => [
                          "${server_name}.uat.dbg.westfield.com",
                          "${server_name}.systest.dbg.westfield.com",
                          "${server_name}.test.dbg.westfield.com",
                          "${server_alias_name}",
                          "${server_name}.*.xip.io",
                          ],


        passenger_ruby => $passenger_ruby,

        passenger_high_performance => true,

        directories => [ { path => $docroot, passenger_enabled => 'on', allow_override  => 'all' } ],

        add_listen => false,
      }

      apache::vhost { "${vhost_name}-ssl":
        port       => '443',
        servername => "${vhost_name}",

        docroot_owner => $docroot_owner,
        docroot_group => $docroot_owner,

        docroot => $docroot,

        ssl => true,
        
        serveraliases => [
                          "${server_name}.uat.dbg.westfield.com",
                          "${server_name}.systest.dbg.westfield.com",
                          "${server_name}.test.dbg.westfield.com",
                          "${server_alias_name}",
                          ],


        passenger_ruby => $passenger_ruby,

        passenger_high_performance => true,

        directories => [ { path => $docroot, passenger_enabled => 'on', allow_override  => 'all' } ],

        add_listen => false,
      }
    }
  }
  else
  {
    apache::vhost { "${vhost_name}":
      port       => '8080',

      docroot_owner => $docroot_owner,
      docroot_group => $docroot_owner,

      docroot => $docroot,

      serveraliases => [
                        "${server_name}.uat.dbg.westfield.com",
                        "${server_name}.systest.dbg.westfield.com",
                        "${server_name}.test.dbg.westfield.com",
                        "${server_alias_name}",
                        ],


      passenger_ruby => $passenger_ruby,

      passenger_high_performance => true,

      directories => [ { path => $docroot, passenger_enabled => 'on', allow_override  => 'all' } ],

      add_listen => false,
    }
  }
}
