class westfield::gitconfig::install {
  file { "gitconfig":
    path    => "/home/vagrant/.gitconfig",
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => '0644',
    content => template('westfield/gitconfig'),
  }
}
