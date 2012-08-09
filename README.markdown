This is a barebones module for setting up tomcat from a tarball with js-wrapper

Example mainfest

    Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }
    class { ['java', 'tomcat6']: }
