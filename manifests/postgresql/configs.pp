class westfield::postgresql::configs(
  $vmshare              = '/home/vagrant/vmshare',
  ) {
  postgresql::role{'westfield':
    password_hash => '',
    login         => true,
    superuser     => true,
  }

  postgresql::database { 'westfield_development':
    owner     => 'westfield',
    require   => Postgresql::Role['westfield'];
  }

  postgresql::database { 'westfield_test':
    owner     => 'westfield',
    require   => Postgresql::Role['westfield'];
  }

  ################################################################
  # BEGIN USER SERVICE #
  ################################################################
  postgresql::role{'user_service':
    password_hash => 'user_service',
    login         => true,
    createdb      => true,
  }

  # we can't use the shorthand postgresql::db because we need
  # to set the owner as well as privileges, which can only be
  # done with postgresql::database and postgresql::role
  postgresql::database { 'user_service_development':
    owner     => 'user_service',
    require   => Postgresql::Role['user_service'];
  }

  postgresql::database { 'user_service_test':
    owner     => 'user_service',
    require   => Postgresql::Role['user_service'];
  }
  ################################################################
  # END USER SERVICE #
  ################################################################


  ################################################################
  # BEGIN FILE SERVICE #
  ################################################################
  postgresql::role{'file_service':
    password_hash => 'file_service',
    login         => true,
    createdb      => true,
  }

  # we can't use the shorthand postgresql::db because we need
  # to set the owner as well as privileges, which can only be
  # done with postgresql::database and postgresql::role
  postgresql::database { 'file_service_development':
    owner     => 'file_service',
    require   => Postgresql::Role['file_service'];
  }

  postgresql::database { 'file_service_test':
    owner     => 'file_service',
    require   => Postgresql::Role['file_service'];
  }
  ################################################################
  # END FILE SERVICE #
  ################################################################

  ################################################################
  # BEGIN PRODUCT SERVICE # 
  # DISABLED FOR NOW since we just use the rake task in product service
  # rake db:setup; rake db:migrate; rake db:test:prepare
  ################################################################
  postgresql::role{'product_service-rw':
    password_hash => 'product_service-rw',
    login         => true,
    createdb      => true,
  }

  # postgresql::database { 'product_service_test':
  #   owner     => 'product_service-rw',
  #   require   => Postgresql::Role['product_service-rw'];
  # }

  # postgresql::database { 'product_service_development':
  #   owner     => 'product_service-rw',
  #   require   => Postgresql::Role['product_service-rw'];
  # }

  # exec { "create wfss schema on product_service_development":
  #   command => "/usr/bin/psql -U postgres product_service_development -c 'create schema wfss;'",
  #   user => 'postgres',
  #   require => Postgresql::Role['product_service-rw'],
  # }

  # exec { "grant usage to wfss.schema_migrations to product_service-rw":
  #   command => "/usr/bin/psql -U postgres product_service_development -c 'grant select,insert on table wfss.schema_migrations to \"product_service-rw\";'",
  #   user => 'postgres',
  #   require => Postgresql::Role['product_service-rw'],
  # }
  
  ################################################################
  # END PRODUCT SERVICE #
  ################################################################

  ################################################################
  # BEGIN TRADING HOUR SERVICE #
  ################################################################
  postgresql::role{'trading_hour_service-rw':
    password_hash => 'trading_hour_service',
    login         => true,
    createdb      => true,
  }
  
  postgresql::database { 'trading_hour_development':
    owner     => 'trading_hour_service-rw',
    require   => Postgresql::Role['trading_hour_service-rw'];
  }

  postgresql::database { 'trading_hour_service_test':
    owner     => 'trading_hour_service-rw',
    require   => Postgresql::Role['trading_hour_service-rw'];
  }
  ################################################################
  # END TRADING HOUR SERVICE #
  ################################################################

  ################################################################
  # BEGIN STORE SERVICE #
  ################################################################
  postgresql::role{'store_service-rw':
    password_hash => 'store_service-rw',
    login         => true,
    createdb      => true,
  }

  postgresql::database { 'store_service_test':
    owner     => 'store_service-rw',
    require   => Postgresql::Role['store_service-rw'];
  }

  # for dev mode only, need more fine grained control in production
  exec { "grant westfield role to store_service-rw":
    command => "/usr/bin/psql -U postgres postgres -c 'grant westfield to \"store_service-rw\";'",
    user => 'postgres',
    require => Postgresql::Role['store_service-rw'],
  }

  # postgresql::database_grant{'store_service-rw connect to westfield':
  #   privilege    => connect,
  #   db           => 'westfield_development',
  #   role         => 'store_service-rw',
  #   require      => Postgresql::Database['westfield_development']
  # }

  # exec { "grant SELECT,INSERT,UPDATE,DELETE to wfss.retailer to store_service-rw":
  #   command => "/usr/bin/psql -U postgres westfield_development -c 'grant SELECT,INSERT,UPDATE,DELETE on table wfss.retailer to \"store_service-rw\";'",
  #   user => 'postgres',
  #   require => Postgresql::Role['store_service-rw'],
  # }

  # exec { "grant USAGE to wfss.retailer_retailer_id_seq to store_service-rw":
  #   command => "/usr/bin/psql -U postgres westfield_development -c 'grant USAGE on table wfss.retailer_retailer_id_seq to \"store_service-rw\";'",
  #   user => 'postgres',
  #   require => Postgresql::Role['store_service-rw'],
  # }

  # exec { "grant usage to wfss.schema_migrations to store_service-rw":
  #   command => "/usr/bin/psql -U postgres westfield_development -c 'grant select,insert on table wfss.schema_migrations to \"store_service-rw\";'",
  #   user => 'postgres',
  #   require => Postgresql::Role['store_service-rw'],
  # }

  # exec { "grant usage to wfss schema to store_service-rw":
  #   command => "/usr/bin/psql -U postgres westfield_development -c 'grant usage on schema wfss to \"store_service-rw\";'",
  #   user => 'postgres',
  #   require => Postgresql::Role['store_service-rw'],
  # }

  ################################################################
  # END STORE SERVICE #
  ################################################################

  ################################################################
  # BEGIN CENTRE SERVICE #
  ################################################################
  postgresql::role{'centre_service-rw':
    password_hash => 'centre_service-rw',
    login         => true,
    createdb      => true,
  }

  postgresql::database { 'centre_service_test':
    owner     => 'centre_service-rw',
    require   => Postgresql::Role['centre_service-rw'];
  }

  # for dev mode only, need more fine grained control in production
  exec { "grant westfield role to centre_service-rw":
    command => "/usr/bin/psql -U postgres postgres -c 'grant westfield to \"centre_service-rw\";'",
    user => 'postgres',
    require => Postgresql::Role['centre_service-rw'],
  }
  # postgresql::database_grant{'centre_service-rw connect to westfield':
  #   privilege    => connect,
  #   db           => 'westfield_development',
  #   role         => 'centre_service-rw',
  #   require      => Postgresql::Database['westfield_development']
  # }
  ################################################################
  # END CENTRE SERVICE #
  ################################################################

  ################################################################
  # BEGIN EDITORIAL SERVICE #
  ################################################################
  postgresql::role{'editorial_service-rw':
    password_hash => 'editorial_service',
    login         => true,
    createdb      => true,
    superuser     => true,
  }

  postgresql::database { 'editorial_service_development':
    owner     => 'editorial_service-rw',
    require   => Postgresql::Role['editorial_service-rw'];
  }

  postgresql::database { 'editorial_service_test':
    owner     => 'editorial_service-rw',
    require   => Postgresql::Role['editorial_service-rw'];
  }

  # for dev mode only, need more fine grained control in production
  exec { "grant westfield role to editorial_service-rw":
    command => "/usr/bin/psql -U postgres postgres -c 'grant westfield to \"editorial_service-rw\";'",
    user => 'postgres',
    require => Postgresql::Role['editorial_service-rw'],
  }
  ################################################################
  # END EDITORIAL SERVICE #
  ################################################################

  exec {'download westfield dev database':
    command => "/usr/bin/curl -L https://www.dropbox.com/s/2x6cjuckpjxsnck/westfield_development.sql -o ${vmshare}/westfield_development.sql",
    creates => "${vmshare}/westfield_development.sql"
  }

  exec { "load development data into westfield_development table":
    command => "/usr/bin/psql -U westfield -d westfield_development -h localhost < ${vmshare}/westfield_development.sql",
    onlyif => "/usr/bin/test -e ${vmshare}/westfield_development.sql",
    require => [Postgresql::Database['westfield_development'], Exec['download westfield dev database']],
  }
  
  exec { "grant usage to wfss schema to centre_service-rw":
    command => "/usr/bin/psql -U postgres westfield_development -c 'grant usage on schema wfss to \"centre_service-rw\";'",
    user => 'postgres',
    require => [
                Postgresql::Role['centre_service-rw'],
                Exec["load development data into westfield_development table"],
                Postgresql::Database['westfield_development']
                ],
  }

  ################################################################
  # BEGIN DEAL SERVICE #
  ################################################################
  postgresql::role{'deal_service-rw':
    password_hash => 'deal_service-rw',
    login         => true,
    createdb      => true,
  }

  postgresql::database { 'deal_service_development':
    owner     => 'deal_service-rw',
    require   => Postgresql::Role['deal_service-rw'];
  }

  postgresql::database { 'deal_service_test':
    owner     => 'deal_service-rw',
    require   => Postgresql::Role['deal_service-rw'];
  }
  ################################################################
  # END DEAL SERVICE #
  ################################################################

  ################################################################
  # BEGIN CANNED SEARCH SERVICE #
  ################################################################
  postgresql::role{'canned_search_service-rw':
    password_hash => 'canned_search_service',
    login         => true,
    createdb      => true,
  }

  postgresql::database { 'canned_search_service_development':
    owner     => 'canned_search_service-rw',
    require   => Postgresql::Role['canned_search_service-rw'];
  }

  postgresql::database { 'canned_search_service_test':
    owner     => 'canned_search_service-rw',
    require   => Postgresql::Role['canned_search_service-rw'];
  }
  ################################################################
  # END CANNED SEARCH SERVICE #
  ################################################################

  ################################################################
  # BEGIN METRIC SERVICE #
  ################################################################
  postgresql::role{'metric_service-rw':
    password_hash => 'metric_service',
    login         => true,
    createdb      => true,
  }

  postgresql::database { 'metric_service_development':
    owner     => 'metric_service-rw',
    require   => Postgresql::Role['metric_service-rw'];
  }

  postgresql::database { 'metric_service_test':
    owner     => 'metric_service-rw',
    require   => Postgresql::Role['metric_service-rw'];
  }
  ################################################################
  # END METRIC SERVICE #
  ################################################################

  ################################################################
  # BEGIN MOVIE SERVICE #
  ################################################################
  postgresql::role{'movie_service-rw':
    password_hash => 'movie_service-rw',
    login         => true,
    createdb      => true,
  }

  postgresql::database { 'movie_service_development':
    owner     => 'movie_service-rw',
    require   => Postgresql::Role['movie_service-rw'];
  }

  postgresql::database { 'movie_service_test':
    owner     => 'movie_service-rw',
    require   => Postgresql::Role['movie_service-rw'];
  }
  ################################################################
  # END MOVIE SERVICE #
  ################################################################

  ################################################################
  # BEGIN AAA CONSOLE SERVICE #
  ################################################################
  postgresql::role{'aaa_console-rw':
    password_hash => 'aaa_console',
    login         => true,
    createdb      => true,
  }

  postgresql::database { 'aaa_console_development':
    owner     => 'aaa_console-rw',
    require   => Postgresql::Role['aaa_console-rw'];
  }

  postgresql::database { 'aaa_console_test':
    owner     => 'aaa_console-rw',
    require   => Postgresql::Role['aaa_console-rw'];
  }
  ################################################################
  # END AAA CONSOLE SERVICE #
  ################################################################

  ################################################################
  # BEGIN AAA SERVICE #
  ################################################################
  postgresql::role{'aaa_service-rw':
    password_hash => 'aaa_service-rw',
    login         => true,
    createdb      => true,
  }

  postgresql::database { 'aaa_service_development':
    owner     => 'aaa_service-rw',
    require   => Postgresql::Role['aaa_service-rw'];
  }

  postgresql::database { 'aaa_service_test':
    owner     => 'aaa_service-rw',
    require   => Postgresql::Role['aaa_service-rw'];
  }
  ################################################################
  # END AAA SERVICE #
  ################################################################
}
