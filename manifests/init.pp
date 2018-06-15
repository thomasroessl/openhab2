# == Class: openhab2
#
# Installs and configures openhab2.
#
# === Examples
#
#  class { 'openhab2': }
#
# === Authors
#
# Thomas Roessl <e11775192@student.tuwien.ac.at>
#
class openhab2 {

  $javapackage = $::osfamily ? {
    'redhat' => 'java-1.8.0-openjdk',
    'debian' => 'openjdk-8-jre'
  }

  class { 'java' :
    package => $javapackage,
  }

  case $::osfamily {
    'redhat': {
      file { 'repo-file':
        ensure  => 'present',
        path    => '/etc/yum.repos.d/openhab.repo',
        content => file('openhab2/stable.repo')
      }
      package { 'openhab2':
        ensure  => 'installed',
        require => File['repo-file']
      }
    }
    'debian': {
      exec { 'aptget-addkey':
        command => "wget -qO - 'https://bintray.com/user/downloadSubjectPublicKey?username=openhab' | sudo apt-key add -",
        path    => '/bin:/usr/bin'
      }
      exec { 'aptget-addrepo':
        command =>"echo 'deb https://dl.bintray.com/openhab/apt-repo2 stable main' | sudo tee /etc/apt/sources.list.d/openhab2.list",
        path    => '/bin:/usr/bin',
        require => Exec['aptget-addkey']
      }
      exec { 'aptget-update':
        command => "sudo apt-get update",
        path    => '/usr/bin',
        require => Exec['aptget-addrepo']
      }
      package { 'openhab2':
        ensure  => 'installed',
        require => Exec['aptget-update']
      }
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

  service { 'openhab2':
    ensure => 'running',
    enable => true
  }
}
